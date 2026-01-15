/**
 * @file main.cpp
 * @brief DiveChecker ESP32-C3 Firmware v4.5.0
 * 
 * @details
 * High-precision pressure monitoring for freediving training.
 * 
 * Features:
 *   - 160Hz BME280 sensor sampling
 *   - ECDSA P-256 authentication
 *   - Persistent device settings in NVS (name, PIN)
 *   - PIN-protected device configuration
 *   - Unique serial number from chip ID
 *   - WS2812 RGB LED status indication
 *   - Adaptive baseline for temperature drift compensation
 * 
 * @author Kim DaeHyun (kernalix7@kodenet.io)
 * @copyright Copyright (C) 2025-2026 KodeNet
 * @license Apache License 2.0
 */

#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_BME280.h>
#include <Preferences.h>
#include <Adafruit_NeoPixel.h>
#include <mbedtls/ecdsa.h>
#include <mbedtls/sha256.h>
#include <mbedtls/ctr_drbg.h>
#include <mbedtls/entropy.h>
#include <esp_system.h>
#include <esp_mac.h>

// ============================================================================
// Firmware Version
// ============================================================================

#define FW_VERSION_STRING   "4.5.0"

// ============================================================================
// Hardware Configuration
// ============================================================================

#define I2C_SDA         8
#define I2C_SCL         9
#define I2C_FREQ        400000

#define WS2812_PIN      3
#define WS2812_COUNT    1

// ============================================================================
// Sensor Configuration (Stable settings from v3.0.0)
// ============================================================================

#define BME280_ADDR             0x76
#define INTERNAL_SAMPLE_RATE    100     // Hz - fixed internal sampling
#define DEFAULT_OUTPUT_RATE     8       // Hz - default output rate
#define MIN_OUTPUT_RATE         4       // Hz - minimum (most stable)
#define MAX_OUTPUT_RATE         50      // Hz - maximum (less averaging)
#define MAX_SAMPLES_PER_OUTPUT  (INTERNAL_SAMPLE_RATE / MIN_OUTPUT_RATE)  // 25 samples max
#define SAMPLE_INTERVAL_MS      (1000 / INTERNAL_SAMPLE_RATE)  // 10ms

// ============================================================================
// Connection & Device Settings
// ============================================================================

#define CONNECTION_TIMEOUT_MS   3000
#define BEACON_INTERVAL_MS      200
#define DEVICE_NAME_MAX_LEN     24
#define DEVICE_PIN_LEN          4
#define NVS_NAMESPACE           "divechk"

// ============================================================================
// ECDSA Keys
// ============================================================================

#if __has_include("keys/ecdsa_keys.h")
    #include "keys/ecdsa_keys.h"
#else
    #warning "Using placeholder ECDSA keys!"
    static const uint8_t ECDSA_PRIVATE_KEY[32] = {0};
    static const uint8_t ECDSA_PUBLIC_KEY[65] = {0};
#endif

// ============================================================================
// LED States
// ============================================================================

enum LedState { LED_OFF, LED_BOOT, LED_USB_WAIT, LED_USB_READY, LED_CONNECTED };

// ============================================================================
// Global Variables
// ============================================================================

Adafruit_BME280 bme;
Adafruit_NeoPixel led(WS2812_COUNT, WS2812_PIN, NEO_GRB + NEO_KHZ800);
Preferences prefs;

char g_serial_number[13];
char g_device_name[DEVICE_NAME_MAX_LEN + 1] = "DiveChecker";
char g_device_pin[DEVICE_PIN_LEN + 1] = "0000";

bool g_sensor_ready = false;

bool g_connected = false;
unsigned long g_last_ping_ms = 0;
unsigned long g_last_beacon_ms = 0;
unsigned long g_last_sample_ms = 0;
unsigned long g_last_output_ms = 0;

// Output rate (configurable via 'F' command)
int g_output_rate = DEFAULT_OUTPUT_RATE;  // Hz
int g_output_interval_ms = 1000 / DEFAULT_OUTPUT_RATE;  // ms
int g_samples_per_output = INTERNAL_SAMPLE_RATE / DEFAULT_OUTPUT_RATE;

// Sample buffer for average filtering (sized for minimum rate = max samples)
float g_sample_buffer[MAX_SAMPLES_PER_OUTPUT + 2];
int g_sample_count = 0;

// Baseline
float g_baseline_pressure = 0;
bool g_baseline_set = false;

mbedtls_ecdsa_context g_ecdsa_ctx;
mbedtls_ctr_drbg_context g_ctr_drbg;
mbedtls_entropy_context g_entropy;
bool g_ecdsa_initialized = false;

#define CMD_BUFFER_SIZE 72
char g_cmd_buffer[CMD_BUFFER_SIZE];
uint8_t g_cmd_pos = 0;
char g_cmd_type = 0;

// ============================================================================
// LED Functions
// ============================================================================

void led_set_color(uint8_t r, uint8_t g, uint8_t b) {
    led.setPixelColor(0, led.Color(r, g, b));
    led.show();
}

void led_set_state(LedState state) {
    const uint8_t brightness = 50;
    switch (state) {
        case LED_OFF:       led_set_color(0, 0, 0); break;
        case LED_BOOT:      led_set_color(brightness, 0, 0); break;
        case LED_USB_WAIT:  led_set_color(60, 25, 0); break;
        case LED_USB_READY: led_set_color(0, 0, brightness); break;
        case LED_CONNECTED: led_set_color(0, brightness, 0); break;
    }
}

// ============================================================================
// NVS Storage
// ============================================================================

void load_settings() {
    prefs.begin(NVS_NAMESPACE, true);
    String name = prefs.getString("name", "DiveChecker");
    String pin = prefs.getString("pin", "0000");
    strncpy(g_device_name, name.c_str(), DEVICE_NAME_MAX_LEN);
    strncpy(g_device_pin, pin.c_str(), DEVICE_PIN_LEN);
    prefs.end();
}

void save_settings() {
    prefs.begin(NVS_NAMESPACE, false);
    prefs.putString("name", g_device_name);
    prefs.putString("pin", g_device_pin);
    prefs.end();
}

// ============================================================================
// Device Identification
// ============================================================================

void init_serial_number() {
    uint8_t mac[6];
    esp_efuse_mac_get_default(mac);
    snprintf(g_serial_number, sizeof(g_serial_number),
             "%02X%02X%02X%02X%02X%02X",
             mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
}

// ============================================================================
// ECDSA Authentication
// ============================================================================

bool ecdsa_init() {
    if (g_ecdsa_initialized) return true;
    
    bool all_zero = true;
    for (int i = 0; i < 32; i++) {
        if (ECDSA_PRIVATE_KEY[i] != 0) { all_zero = false; break; }
    }
    if (all_zero) {
        Serial.println("WARN:Placeholder keys");
        return false;
    }
    
    mbedtls_ecdsa_init(&g_ecdsa_ctx);
    mbedtls_ctr_drbg_init(&g_ctr_drbg);
    mbedtls_entropy_init(&g_entropy);
    
    const char *pers = "divechecker_ecdsa";
    if (mbedtls_ctr_drbg_seed(&g_ctr_drbg, mbedtls_entropy_func, &g_entropy,
                              (const unsigned char *)pers, strlen(pers)) != 0) {
        return false;
    }
    
    if (mbedtls_ecp_group_load(&g_ecdsa_ctx.grp, MBEDTLS_ECP_DP_SECP256R1) != 0) {
        return false;
    }
    
    if (mbedtls_mpi_read_binary(&g_ecdsa_ctx.d, ECDSA_PRIVATE_KEY, 32) != 0) {
        return false;
    }
    
    g_ecdsa_initialized = true;
    Serial.println("INFO:ECDSA OK");
    return true;
}

void ecdsa_sign_nonce(const char* nonce_hex) {
    if (!g_ecdsa_initialized) {
        Serial.println("ERR:ECDSA not init");
        return;
    }
    
    uint8_t nonce[32];
    size_t nonce_len = strlen(nonce_hex) / 2;
    if (nonce_len > 32) nonce_len = 32;
    
    for (size_t i = 0; i < nonce_len; i++) {
        char hex[3] = {nonce_hex[i*2], nonce_hex[i*2+1], 0};
        nonce[i] = strtol(hex, NULL, 16);
    }
    
    uint8_t hash[32];
    mbedtls_sha256(nonce, nonce_len, hash, 0);
    
    mbedtls_mpi r, s;
    mbedtls_mpi_init(&r);
    mbedtls_mpi_init(&s);
    
    if (mbedtls_ecdsa_sign(&g_ecdsa_ctx.grp, &r, &s, &g_ecdsa_ctx.d,
                           hash, 32, mbedtls_ctr_drbg_random, &g_ctr_drbg) != 0) {
        Serial.println("ERR:Sign failed");
        mbedtls_mpi_free(&r);
        mbedtls_mpi_free(&s);
        return;
    }
    
    uint8_t r_buf[32], s_buf[32];
    mbedtls_mpi_write_binary(&r, r_buf, 32);
    mbedtls_mpi_write_binary(&s, s_buf, 32);
    
    Serial.print("SIG:");
    for (int i = 0; i < 32; i++) Serial.printf("%02X", r_buf[i]);
    for (int i = 0; i < 32; i++) Serial.printf("%02X", s_buf[i]);
    Serial.println();
    
    mbedtls_mpi_free(&r);
    mbedtls_mpi_free(&s);
}

// ============================================================================
// PIN Verification
// ============================================================================

bool pin_verify(const char* pin) {
    return strncmp(pin, g_device_pin, DEVICE_PIN_LEN) == 0;
}

bool pin_is_valid_format(const char* pin) {
    for (int i = 0; i < DEVICE_PIN_LEN; i++) {
        if (pin[i] < '0' || pin[i] > '9') return false;
    }
    return true;
}

// ============================================================================
// BME280 Sensor
// ============================================================================

void sensor_init() {
    Serial.print("INFO:Sensor init... ");
    
    if (bme.begin(BME280_ADDR) || bme.begin(0x77)) {
        g_sensor_ready = true;
        Serial.println("OK");
    } else {
        Serial.println("FAILED");
        return;
    }
    
    Wire.beginTransmission(BME280_ADDR);
    Wire.write(0xD0);
    Wire.endTransmission();
    Wire.requestFrom(BME280_ADDR, (uint8_t)1);
    uint8_t chip_id = Wire.read();
    Serial.printf("INFO:ChipID=0x%02X (%s)\n", chip_id,
                  chip_id == 0x58 ? "BMP280" : chip_id == 0x60 ? "BME280" : "Unknown");
    
    // Stable settings from v3.0.0: Pressure X16 + IIR X2
    // X16 oversampling = high resolution, low noise
    // X2 IIR = fast response while filtering sensor noise
    bme.setSampling(
        Adafruit_BME280::MODE_NORMAL,
        Adafruit_BME280::SAMPLING_X1,      // Temperature (min for speed)
        Adafruit_BME280::SAMPLING_X16,     // Pressure X16 (stable!)
        Adafruit_BME280::SAMPLING_NONE,    // Humidity disabled
        Adafruit_BME280::FILTER_X2,        // IIR X2 (fast response)
        Adafruit_BME280::STANDBY_MS_0_5    // Fast standby
    );
    
    float p = bme.readPressure() / 100.0f;
    float t = bme.readTemperature();
    Serial.printf("INFO:Test %.2f hPa %.1f C\n", p, t);
}

void sensor_debug_test() {
    Serial.println("INFO:Sensor debug test...");
    
    if (!g_sensor_ready) {
        Serial.println("ERR:Sensor not ready");
        return;
    }
    
    Wire.beginTransmission(BME280_ADDR);
    Wire.write(0xD0);
    Wire.endTransmission();
    Wire.requestFrom(BME280_ADDR, (uint8_t)1);
    uint8_t chip_id = Wire.read();
    
    Wire.beginTransmission(BME280_ADDR);
    Wire.write(0xF4);
    Wire.endTransmission();
    Wire.requestFrom(BME280_ADDR, (uint8_t)1);
    uint8_t ctrl_meas = Wire.read();
    
    Wire.beginTransmission(BME280_ADDR);
    Wire.write(0xF5);
    Wire.endTransmission();
    Wire.requestFrom(BME280_ADDR, (uint8_t)1);
    uint8_t config = Wire.read();
    
    Serial.printf("ChipID: 0x%02X | CTRL_MEAS: 0x%02X | CONFIG: 0x%02X\n",
                  chip_id, ctrl_meas, config);
    
    Serial.println("Reading raw data...");
    for (int i = 0; i < 5; i++) {
        Wire.beginTransmission(BME280_ADDR);
        Wire.write(0xF7);
        Wire.endTransmission();
        Wire.requestFrom(BME280_ADDR, (uint8_t)6);
        
        uint8_t data[6];
        for (int j = 0; j < 6; j++) data[j] = Wire.read();
        
        int32_t adc_P = ((int32_t)data[0] << 12) | ((int32_t)data[1] << 4) | (data[2] >> 4);
        int32_t adc_T = ((int32_t)data[3] << 12) | ((int32_t)data[4] << 4) | (data[5] >> 4);
        
        float pressure = bme.readPressure() / 100.0f;
        Serial.printf("[%d] P_adc=%d T_adc=%d | %.2f hPa\n", i, adc_P, adc_T, pressure);
        delay(200);
    }
    
    Serial.println("INFO:Test complete");
}

// ============================================================================
// Command Processing
// ============================================================================

void process_command(char c) {
    unsigned long now_ms = millis();
    
    if (g_cmd_type != 0) {
        if (c == '\n' || c == '\r') {
            g_cmd_buffer[g_cmd_pos] = '\0';
            
            switch (g_cmd_type) {
                case 'N': case 'n': {
                    if (g_cmd_pos >= DEVICE_PIN_LEN) {
                        char pin[DEVICE_PIN_LEN + 1];
                        strncpy(pin, g_cmd_buffer, DEVICE_PIN_LEN);
                        pin[DEVICE_PIN_LEN] = '\0';
                        
                        if (pin_verify(pin)) {
                            const char* name = g_cmd_buffer + DEVICE_PIN_LEN;
                            if (strlen(name) > 0) {
                                strncpy(g_device_name, name, DEVICE_NAME_MAX_LEN);
                                g_device_name[DEVICE_NAME_MAX_LEN] = '\0';
                                save_settings();
                                Serial.println("INFO:Name saved");
                            }
                        } else {
                            Serial.println("ERR:Wrong PIN");
                        }
                    }
                    break;
                }
                case 'W': case 'w': {
                    if (g_cmd_pos == DEVICE_PIN_LEN * 2) {
                        char old_pin[DEVICE_PIN_LEN + 1];
                        char new_pin[DEVICE_PIN_LEN + 1];
                        strncpy(old_pin, g_cmd_buffer, DEVICE_PIN_LEN);
                        old_pin[DEVICE_PIN_LEN] = '\0';
                        strncpy(new_pin, g_cmd_buffer + DEVICE_PIN_LEN, DEVICE_PIN_LEN);
                        new_pin[DEVICE_PIN_LEN] = '\0';
                        
                        if (pin_verify(old_pin) && pin_is_valid_format(new_pin)) {
                            strncpy(g_device_pin, new_pin, DEVICE_PIN_LEN);
                            g_device_pin[DEVICE_PIN_LEN] = '\0';
                            save_settings();
                            Serial.println("INFO:PIN changed");
                        } else {
                            Serial.println("ERR:Invalid PIN");
                        }
                    }
                    break;
                }
                case 'A': case 'a': {
                    if (g_cmd_pos >= 32) {
                        ecdsa_sign_nonce(g_cmd_buffer);
                    } else {
                        Serial.println("ERR:Nonce too short");
                    }
                    break;
                }
                case 'F': case 'f': {
                    // Set output frequency: F8, F16, F32, F50
                    int rate = atoi(g_cmd_buffer);
                    if (rate >= MIN_OUTPUT_RATE && rate <= MAX_OUTPUT_RATE) {
                        g_output_rate = rate;
                        g_output_interval_ms = 1000 / rate;
                        g_samples_per_output = INTERNAL_SAMPLE_RATE / rate;
                        g_sample_count = 0;  // Clear buffer
                        Serial.printf("INFO:Output rate %dHz (%d samples avg)\n", 
                                      g_output_rate, g_samples_per_output);
                    } else {
                        Serial.printf("ERR:Rate must be %d-%dHz\n", 
                                      MIN_OUTPUT_RATE, MAX_OUTPUT_RATE);
                    }
                    break;
                }
            }
            g_cmd_type = 0;
            g_cmd_pos = 0;
        } else if (g_cmd_pos < CMD_BUFFER_SIZE - 1) {
            g_cmd_buffer[g_cmd_pos++] = c;
        }
        return;
    }
    
    switch (c) {
        case 'P': case 'p':
            g_last_ping_ms = now_ms;
            if (!g_connected) {
                g_connected = true;
                g_baseline_set = false;  // Reset baseline on new connection
                g_sample_count = 0;
                led_set_state(LED_CONNECTED);
                Serial.println("INFO:Connected");
            }
            Serial.println("PONG");
            break;
            
        case 'R': case 'r':
            g_baseline_set = false;
            g_sample_count = 0;
            Serial.println("INFO:Baseline reset");
            break;
            
        case 'C': case 'c':
            Serial.printf("CFG:%d\n", g_output_rate);
            break;
        
        case 'F': case 'f':
            // Set output frequency: F8, F16, F32, F50
            g_cmd_type = c;
            g_cmd_pos = 0;
            break;
            
        case 'I': case 'i':
            Serial.printf("INFO:Serial %s\n", g_serial_number);
            Serial.printf("INFO:Name %s\n", g_device_name);
            Serial.printf("INFO:FW %s\n", FW_VERSION_STRING);
            Serial.printf("INFO:Sensor %s\n", g_sensor_ready ? "OK" : "Error");
            break;
            
        case 'T': case 't':
            sensor_debug_test();
            break;
            
        case 'N': case 'n':
        case 'W': case 'w':
        case 'A': case 'a':
            g_cmd_type = c;
            g_cmd_pos = 0;
            break;
            
        case 'B': case 'b':
            Serial.println("INFO:Rebooting...");
            Serial.flush();
            delay(200);
            ESP.restart();
            break;
    }
}

// ============================================================================
// Sensor Reading (Stable v3.0.0 style)
// ============================================================================

// Collect sample at 100Hz into buffer
void collect_sample() {
    if (g_sample_count < g_samples_per_output) {
        g_sample_buffer[g_sample_count++] = bme.readPressure() / 100.0f;
    }
}

// Get average from sample buffer (simple and stable)
float get_average() {
    if (g_sample_count == 0) return 0;
    
    float sum = 0;
    for (int i = 0; i < g_sample_count; i++) {
        sum += g_sample_buffer[i];
    }
    return sum / g_sample_count;
}

// Process and send at 8Hz
void process_and_send() {
    if (g_sample_count == 0) return;
    
    // Get average of collected samples
    float pressure = get_average();
    g_sample_count = 0;
    
    // Set baseline on first valid reading
    if (!g_baseline_set) {
        g_baseline_pressure = pressure;
        g_baseline_set = true;
        Serial.printf("INFO:Baseline %.3f hPa\n", g_baseline_pressure);
    }
    
    // Calculate delta from baseline (hPa * 1000 for precision)
    float relativePressure = pressure - g_baseline_pressure;
    int32_t pressureInt = (int32_t)(relativePressure * 1000.0f);
    
    // Very small values to zero (noise floor)
    if (pressureInt > -1 && pressureInt < 1) {
        pressureInt = 0;
    }
    
    // Send: D:1234 (delta pressure x1000 in hPa)
    Serial.printf("D:%d\n", pressureInt);
}

// ============================================================================
// Startup Banner
// ============================================================================

void print_startup_banner() {
    Serial.println();
    Serial.println("========================================");
    Serial.printf("  DiveChecker ESP32-C3 v%s\n", FW_VERSION_STRING);
    Serial.printf("  %dHz -> %dHz Output (F%d-%d)\n", INTERNAL_SAMPLE_RATE, g_output_rate, MIN_OUTPUT_RATE, MAX_OUTPUT_RATE);
    Serial.println("========================================");
    Serial.printf("Device : %s\n", g_device_name);
    Serial.printf("Serial : %s\n", g_serial_number);
    Serial.printf("I2C    : GP%d/GP%d @ %dkHz\n", I2C_SDA, I2C_SCL, I2C_FREQ / 1000);
    Serial.printf("Sensor : %s (X16 + IIR X2)\n", g_sensor_ready ? "OK" : "NOT FOUND");
    Serial.printf("ECDSA  : %s\n", g_ecdsa_initialized ? "OK" : "NOT INIT");
    Serial.printf("Output : %dHz (%d samples avg)\n", g_output_rate, g_samples_per_output);
    Serial.println("INFO:Ready");
    Serial.println("========================================");
}

// ============================================================================
// Setup
// ============================================================================

void setup() {
    Serial.begin(115200);
    
    unsigned long start = millis();
    while (!Serial && (millis() - start < 3000)) delay(10);
    delay(300);
    
    led.begin();
    led.setBrightness(50);
    led_set_state(LED_BOOT);
    
    init_serial_number();
    load_settings();
    
    Wire.begin(I2C_SDA, I2C_SCL);
    Wire.setClock(I2C_FREQ);
    
    sensor_init();
    ecdsa_init();
    
    led_set_state(LED_USB_READY);
    print_startup_banner();
}

// ============================================================================
// Main Loop
// ============================================================================

void loop() {
    unsigned long now_ms = millis();
    
    // Process serial commands
    while (Serial.available()) {
        process_command(Serial.read());
    }
    
    // Connection timeout check
    if (g_connected && (now_ms - g_last_ping_ms > CONNECTION_TIMEOUT_MS)) {
        g_connected = false;
        led_set_state(LED_USB_READY);
        Serial.println("INFO:Disconnected");
    }
    
    // Beacon when not connected
    if (!g_connected && (now_ms - g_last_beacon_ms >= BEACON_INTERVAL_MS)) {
        g_last_beacon_ms = now_ms;
        Serial.printf("BEACON:%s:%s\n", g_serial_number, g_device_name);
    }
    
    // Sensor reading (only when connected)
    if (g_sensor_ready && g_connected) {
        // 100Hz internal sampling
        if (now_ms - g_last_sample_ms >= SAMPLE_INTERVAL_MS) {
            g_last_sample_ms = now_ms;
            collect_sample();
        }
        
        // Dynamic output rate (default 8Hz, configurable via F command)
        if (now_ms - g_last_output_ms >= (unsigned long)g_output_interval_ms) {
            g_last_output_ms = now_ms;
            process_and_send();
        }
    }
    
    delayMicroseconds(100);
}

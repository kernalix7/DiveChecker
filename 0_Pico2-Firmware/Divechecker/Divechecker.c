/**
 * @file Divechecker.c
 * @brief DiveChecker RP2350 (Pico 2) Firmware v4.3.0
 * 
 * @details
 * Dual-core architecture for high-precision pressure monitoring:
 *   - Core 0: USB CDC communication, command processing
 *   - Core 1: 160Hz BMP280 sensor sampling
 * 
 * Features:
 *   - Persistent device settings in Flash (name, PIN)
 *   - PIN-protected device configuration
 *   - Unique serial number from chip ID
 *   - WS2812 RGB LED status indication
 * 
 * @author Kim DaeHyun (kernalix7@kodenet.io)
 * @copyright Copyright (C) 2025-2026 KodeNet
 * @license Apache License 2.0
 */

#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#include "pico/stdlib.h"
#include "pico/stdio_usb.h"
#include "pico/multicore.h"
#include "pico/util/queue.h"
#include "pico/unique_id.h"
#include "pico/bootrom.h"  // For BOOTSEL reboot

#include "hardware/i2c.h"
#include "hardware/gpio.h"
#include "hardware/pio.h"
#include "hardware/flash.h"
#include "hardware/sync.h"

// mbedtls for ECDSA authentication
#include "mbedtls/ecdsa.h"
#include "mbedtls/sha256.h"
#include "mbedtls/ctr_drbg.h"
#include "mbedtls/ecp.h"

#include "pico/rand.h"
#include <stdlib.h>  // for strtol

#include "ws2812.pio.h"

// ============================================================================
// ECDSA Key Configuration
// ============================================================================
// Build modes:
// 1. Development: Keys from flash (ecdsa_private_keys.h)
// 2. Production: Keys from OTP (define USE_OTP_KEYS)
// ============================================================================

// Uncomment for production builds with OTP keys:
// #define USE_OTP_KEYS

#if defined(USE_OTP_KEYS)
    // Production: Read keys from OTP at runtime
    #include "otp_keys.h"
    uint8_t ECDSA_PRIVATE_KEY[32] = {0};
    uint8_t ECDSA_PUBLIC_KEY[65] = {0};
    static bool g_otp_keys_loaded = false;
#elif __has_include("keys/ecdsa_private_keys.h")
    // Development: Keys from header file
    #include "keys/ecdsa_private_keys.h"
#else
    // Placeholder keys for development - REPLACE WITH REAL KEYS!
    #warning "Using placeholder ECDSA keys! Run generate_keys.sh to create real keys."
    static const uint8_t ECDSA_PRIVATE_KEY[32] = {0};
    static const uint8_t ECDSA_PUBLIC_KEY[65] = {0};
#endif

/* ============================================================================
 * Configuration Constants
 * ========================================================================== */

// Firmware version
#define FW_VERSION_MAJOR    4
#define FW_VERSION_MINOR    5
#define FW_VERSION_PATCH    0
#define FW_VERSION_STRING   "4.5.0"

// I2C Configuration
#define I2C_PORT            i2c0
#define I2C_SDA_PIN         8
#define I2C_SCL_PIN         9
#define I2C_BAUDRATE        400000      // 400kHz (BMP280 max spec)

// BMP280 Sensor
#define BMP280_I2C_ADDR     0x76
#define BMP280_CHIP_ID      0x58
#define BME280_CHIP_ID      0x60

// Sampling Configuration (Stable v3.0.0 style)
#define INTERNAL_SAMPLE_RATE_HZ  100     // Fixed internal sampling rate
#define DEFAULT_OUTPUT_RATE_HZ   8       // Default output rate
#define MIN_OUTPUT_RATE_HZ       4       // Minimum (most stable)
#define MAX_OUTPUT_RATE_HZ       50      // Maximum (less averaging)
#define MAX_SAMPLES_PER_OUTPUT   (INTERNAL_SAMPLE_RATE_HZ / MIN_OUTPUT_RATE_HZ)  // 25 max
#define SAMPLE_INTERVAL_US       (1000000 / INTERNAL_SAMPLE_RATE_HZ)  // 10ms

// Connection Timeout
#define CONNECTION_TIMEOUT_MS   3000

// WS2812 LED (RP2350 Zero SuperMini)
#define WS2812_PIN          16
#define WS2812_IS_RGBW      false
#define LED_BRIGHTNESS      50

// Flash Storage (last 4KB sector of 4MB flash)
#define FLASH_SIZE_BYTES        (4 * 1024 * 1024)
#define FLASH_SETTINGS_OFFSET   (FLASH_SIZE_BYTES - FLASH_SECTOR_SIZE)
#define SETTINGS_MAGIC          0x44495646  // "DIVF"

// Device Settings Limits
#define DEVICE_NAME_MAX_LEN     24      // UTF-8 bytes (8 Korean chars or 24 ASCII)
#define DEVICE_PIN_LEN          4

// Inter-core Queue
#define PRESSURE_QUEUE_SIZE     32

/* ============================================================================
 * Type Definitions
 * ========================================================================== */

/**
 * @brief Flash-stored device settings structure
 * @note Must be exactly FLASH_PAGE_SIZE (256 bytes) for flash programming
 */
typedef struct __attribute__((packed)) {
    uint32_t magic;
    char pin[DEVICE_PIN_LEN + 1];
    char name[DEVICE_NAME_MAX_LEN + 1];
    uint8_t _reserved[FLASH_PAGE_SIZE - sizeof(uint32_t) - (DEVICE_PIN_LEN + 1) - (DEVICE_NAME_MAX_LEN + 1)];
} device_settings_t;

_Static_assert(sizeof(device_settings_t) == FLASH_PAGE_SIZE, 
               "device_settings_t must be exactly FLASH_PAGE_SIZE");

/**
 * @brief Pressure data packet for inter-core communication
 */
typedef struct {
    int32_t delta_x1000;  // Delta pressure in hPa * 1000
} pressure_packet_t;

/**
 * @brief BMP280 calibration data
 */
typedef struct {
    uint16_t dig_T1;
    int16_t  dig_T2, dig_T3;
    uint16_t dig_P1;
    int16_t  dig_P2, dig_P3, dig_P4, dig_P5;
    int16_t  dig_P6, dig_P7, dig_P8, dig_P9;
    int32_t  t_fine;    // Temperature for pressure compensation
} bmp280_calib_t;

/**
 * @brief LED status colors
 */
typedef enum {
    LED_STATE_OFF,
    LED_STATE_BOOT,         // Red
    LED_STATE_USB_WAIT,     // Yellow blink
    LED_STATE_USB_READY,    // Blue
    LED_STATE_APP_CONNECTED // Green
} led_state_t;

/* ============================================================================
 * BMP280 Register Definitions
 * ========================================================================== */

#define BMP280_REG_ID           0xD0
#define BMP280_REG_RESET        0xE0
#define BMP280_REG_CTRL_MEAS    0xF4
#define BMP280_REG_CONFIG       0xF5
#define BMP280_REG_PRESS_MSB    0xF7
#define BMP280_REG_CALIB_START  0x88
#define BMP280_CALIB_LEN        24

#define BMP280_RESET_VALUE      0xB6
// Stable settings: osrs_t=001 (x1), osrs_p=101 (x16), mode=11 (normal) = 0x57
#define BMP280_CTRL_STABLE      0x57    // T:x1, P:x16, normal mode
#define BMP280_CONFIG_FILTERED  0x04    // standby=0.5ms, filter=x2

// Removed adaptive baseline - send absolute pressure values
// App will handle baseline and filtering

/* ============================================================================
 * Global State
 * ========================================================================== */

// Device identification
static char g_serial_number[PICO_UNIQUE_BOARD_ID_SIZE_BYTES * 2 + 1];
static char g_device_name[DEVICE_NAME_MAX_LEN + 1] = "DiveChecker";
static char g_device_pin[DEVICE_PIN_LEN + 1] = "0000";

// Sensor state
static bmp280_calib_t g_calib;
static volatile bool g_sensor_ready = false;

// Baseline for delta calculation
static volatile float g_baseline_pressure = 0;
static volatile bool g_baseline_set = false;
static bool g_baseline_printed = false;

// Connection state
static volatile bool g_app_connected = false;
static volatile uint64_t g_last_ping_ms = 0;

// Output rate (configurable via 'F' command)
static volatile int g_output_rate = DEFAULT_OUTPUT_RATE_HZ;
static volatile int g_output_interval_ms = 1000 / DEFAULT_OUTPUT_RATE_HZ;
static volatile int g_samples_per_output = INTERNAL_SAMPLE_RATE_HZ / DEFAULT_OUTPUT_RATE_HZ;

// Inter-core communication
static queue_t g_pressure_queue;

// LED
static PIO g_ws2812_pio = pio0;
static uint g_ws2812_sm = 0;

// Command parsing
// Command buffer (64 for auth nonce + margin)
#define CMD_BUFFER_SIZE 72
static char g_cmd_buffer[CMD_BUFFER_SIZE];
static uint8_t g_cmd_pos = 0;
static char g_cmd_type = 0;

/* ============================================================================
 * WS2812 LED Functions
 * ========================================================================== */

static inline uint32_t rgb_to_grb(uint8_t r, uint8_t g, uint8_t b) {
    return ((uint32_t)g << 16) | ((uint32_t)r << 8) | (uint32_t)b;
}

static inline void led_set_color(uint8_t r, uint8_t g, uint8_t b) {
    pio_sm_put_blocking(g_ws2812_pio, g_ws2812_sm, rgb_to_grb(r, g, b) << 8u);
}

static void led_init(void) {
    uint offset = pio_add_program(g_ws2812_pio, &ws2812_program);
    ws2812_program_init(g_ws2812_pio, g_ws2812_sm, offset, WS2812_PIN, 800000, WS2812_IS_RGBW);
}

static void led_set_state(led_state_t state) {
    switch (state) {
        case LED_STATE_OFF:          led_set_color(0, 0, 0);                     break;
        case LED_STATE_BOOT:         led_set_color(LED_BRIGHTNESS, 0, 0);        break;
        case LED_STATE_USB_WAIT:     led_set_color(60, 25, 0);                   break;
        case LED_STATE_USB_READY:    led_set_color(0, 0, LED_BRIGHTNESS);        break;
        case LED_STATE_APP_CONNECTED:led_set_color(0, LED_BRIGHTNESS, 0);        break;
    }
}

/* ============================================================================
 * Flash Storage Functions
 * ========================================================================== */

static const device_settings_t* flash_get_settings_ptr(void) {
    return (const device_settings_t*)(XIP_BASE + FLASH_SETTINGS_OFFSET);
}

static void flash_load_settings(void) {
    const device_settings_t *settings = flash_get_settings_ptr();
    
    if (settings->magic == SETTINGS_MAGIC) {
        strncpy(g_device_name, settings->name, DEVICE_NAME_MAX_LEN);
        g_device_name[DEVICE_NAME_MAX_LEN] = '\0';
        strncpy(g_device_pin, settings->pin, DEVICE_PIN_LEN);
        g_device_pin[DEVICE_PIN_LEN] = '\0';
    } else {
        strcpy(g_device_name, "DiveChecker");
        strcpy(g_device_pin, "0000");
    }
}

static void flash_save_settings(void) {
    device_settings_t new_settings = { .magic = SETTINGS_MAGIC };
    strncpy(new_settings.pin, g_device_pin, DEVICE_PIN_LEN);
    new_settings.pin[DEVICE_PIN_LEN] = '\0';
    strncpy(new_settings.name, g_device_name, DEVICE_NAME_MAX_LEN);
    new_settings.name[DEVICE_NAME_MAX_LEN] = '\0';
    memset(new_settings._reserved, 0xFF, sizeof(new_settings._reserved));
    
    uint32_t irq_state = save_and_disable_interrupts();
    flash_range_erase(FLASH_SETTINGS_OFFSET, FLASH_SECTOR_SIZE);
    flash_range_program(FLASH_SETTINGS_OFFSET, (const uint8_t*)&new_settings, FLASH_PAGE_SIZE);
    restore_interrupts(irq_state);
}

/* ============================================================================
 * Device Settings API
 * ========================================================================== */

static bool pin_verify(const char *pin) {
    return strncmp(pin, g_device_pin, DEVICE_PIN_LEN) == 0;
}

static bool pin_is_valid_format(const char *pin) {
    for (int i = 0; i < DEVICE_PIN_LEN; i++) {
        if (pin[i] < '0' || pin[i] > '9') return false;
    }
    return true;
}

static void device_set_name(const char *name) {
    strncpy(g_device_name, name, DEVICE_NAME_MAX_LEN);
    g_device_name[DEVICE_NAME_MAX_LEN] = '\0';
    flash_save_settings();
}

static void device_set_pin(const char *pin) {
    strncpy(g_device_pin, pin, DEVICE_PIN_LEN);
    g_device_pin[DEVICE_PIN_LEN] = '\0';
    flash_save_settings();
}

/* ============================================================================
 * ECDSA Authentication Functions
 * ========================================================================== */

// Custom entropy source using RP2350 hardware RNG
static int rp2350_entropy_func(void *data, unsigned char *output, size_t len) {
    (void)data;
    for (size_t i = 0; i < len; i += 4) {
        uint32_t rnd = get_rand_32();
        size_t to_copy = (len - i) < 4 ? (len - i) : 4;
        memcpy(output + i, &rnd, to_copy);
    }
    return 0;
}

static mbedtls_ecdsa_context g_ecdsa_ctx;
static mbedtls_ctr_drbg_context g_ctr_drbg;
static bool g_ecdsa_initialized = false;

/**
 * @brief Initialize ECDSA context with private key
 * @return true if successful
 */
static bool ecdsa_init(void) {
    if (g_ecdsa_initialized) return true;
    
#if defined(USE_OTP_KEYS)
    // Load keys from OTP (production mode)
    if (!g_otp_keys_loaded) {
        if (!otp_keys_programmed()) {
            printf("WARN:OTP keys not programmed\n");
            return false;
        }
        if (!otp_init_keys(ECDSA_PRIVATE_KEY, ECDSA_PUBLIC_KEY)) {
            printf("ERR:Failed to load OTP keys\n");
            return false;
        }
        g_otp_keys_loaded = true;
        printf("INFO:Keys loaded from OTP\n");
    }
#endif
    
    // Check if placeholder keys are in use
    bool key_is_zero = true;
    for (int i = 0; i < 32; i++) {
        if (ECDSA_PRIVATE_KEY[i] != 0) {
            key_is_zero = false;
            break;
        }
    }
    if (key_is_zero) {
        printf("WARN:ECDSA keys not configured\n");
        return false;
    }
    
    // Initialize contexts
    mbedtls_ecdsa_init(&g_ecdsa_ctx);
    mbedtls_ctr_drbg_init(&g_ctr_drbg);
    
    // Seed DRBG with hardware RNG
    const char *pers = "divechecker_ecdsa";
    int ret = mbedtls_ctr_drbg_seed(&g_ctr_drbg, rp2350_entropy_func, NULL,
                                     (const unsigned char *)pers, strlen(pers));
    if (ret != 0) {
        printf("ERR:DRBG seed failed: %d\n", ret);
        return false;
    }
    
    // Load private key (mbedtls 3.x API - also sets up the curve)
    ret = mbedtls_ecp_read_key(MBEDTLS_ECP_DP_SECP256R1, &g_ecdsa_ctx,
                                ECDSA_PRIVATE_KEY, 32);
    if (ret != 0) {
        printf("ERR:Private key load failed: %d\n", ret);
        return false;
    }
    
    // Compute public key from private key (mbedtls 3.x API)
    ret = mbedtls_ecp_keypair_calc_public(&g_ecdsa_ctx,
                                           mbedtls_ctr_drbg_random, &g_ctr_drbg);
    if (ret != 0) {
        printf("ERR:Public key compute failed: %d\n", ret);
        return false;
    }
    
    g_ecdsa_initialized = true;
    return true;
}

/**
 * @brief Sign a challenge (nonce) with ECDSA
 * @param nonce_hex 32-byte challenge from app (hex string, 64 chars)
 * @param nonce_len Length of nonce string
 */
static void ecdsa_sign_challenge(const char *nonce_hex, size_t nonce_len) {
    if (!g_ecdsa_initialized) {
        if (!ecdsa_init()) {
            printf("AUTH_ERR:ECDSA not ready\n");
            return;
        }
    }
    
    // Validate nonce length (expect 64 hex chars = 32 bytes)
    if (nonce_len != 64) {
        printf("AUTH_ERR:Invalid nonce length\n");
        return;
    }
    
    // Convert hex string to bytes
    uint8_t nonce[32];
    for (int i = 0; i < 32; i++) {
        char hex_byte[3] = {nonce_hex[i*2], nonce_hex[i*2+1], '\0'};
        nonce[i] = (uint8_t)strtol(hex_byte, NULL, 16);
    }
    
    // Hash the nonce with SHA-256
    uint8_t hash[32];
    mbedtls_sha256(nonce, 32, hash, 0);
    
    // Sign the hash
    uint8_t sig[MBEDTLS_ECDSA_MAX_LEN];
    size_t sig_len = 0;
    
    int ret = mbedtls_ecdsa_write_signature(&g_ecdsa_ctx, MBEDTLS_MD_SHA256,
                                             hash, 32, sig, sizeof(sig), &sig_len,
                                             mbedtls_ctr_drbg_random, &g_ctr_drbg);
    if (ret != 0) {
        printf("AUTH_ERR:Sign failed: %d\n", ret);
        return;
    }
    
    // Output signature as hex
    printf("AUTH_OK:");
    for (size_t i = 0; i < sig_len; i++) {
        printf("%02x", sig[i]);
    }
    printf("\n");
}

/* ============================================================================
 * I2C Helper Functions
 * ========================================================================== */

static inline void i2c_write_register(uint8_t reg, uint8_t value) {
    uint8_t buf[2] = {reg, value};
    i2c_write_blocking(I2C_PORT, BMP280_I2C_ADDR, buf, 2, false);
}

static inline void i2c_read_registers(uint8_t start_reg, uint8_t *buffer, size_t len) {
    i2c_write_blocking(I2C_PORT, BMP280_I2C_ADDR, &start_reg, 1, true);
    i2c_read_blocking(I2C_PORT, BMP280_I2C_ADDR, buffer, len, false);
}

/* ============================================================================
 * BMP280 Sensor Functions
 * ========================================================================== */

static bool bmp280_init(void) {
    uint8_t chip_id;
    i2c_read_registers(BMP280_REG_ID, &chip_id, 1);
    
    printf("INFO:ChipID=0x%02X", chip_id);
    if (chip_id == BMP280_CHIP_ID) {
        printf(" (BMP280)\n");
    } else if (chip_id == BME280_CHIP_ID) {
        printf(" (BME280)\n");
    } else {
        printf(" (Unknown)\n");
        return false;
    }
    
    // Soft reset
    i2c_write_register(BMP280_REG_RESET, BMP280_RESET_VALUE);
    sleep_ms(10);
    
    // Read calibration data
    uint8_t calib_raw[BMP280_CALIB_LEN];
    i2c_read_registers(BMP280_REG_CALIB_START, calib_raw, BMP280_CALIB_LEN);
    
    // Parse calibration (little-endian 16-bit values)
    g_calib.dig_T1 = calib_raw[0]  | (calib_raw[1]  << 8);
    g_calib.dig_T2 = calib_raw[2]  | (calib_raw[3]  << 8);
    g_calib.dig_T3 = calib_raw[4]  | (calib_raw[5]  << 8);
    g_calib.dig_P1 = calib_raw[6]  | (calib_raw[7]  << 8);
    g_calib.dig_P2 = calib_raw[8]  | (calib_raw[9]  << 8);
    g_calib.dig_P3 = calib_raw[10] | (calib_raw[11] << 8);
    g_calib.dig_P4 = calib_raw[12] | (calib_raw[13] << 8);
    g_calib.dig_P5 = calib_raw[14] | (calib_raw[15] << 8);
    g_calib.dig_P6 = calib_raw[16] | (calib_raw[17] << 8);
    g_calib.dig_P7 = calib_raw[18] | (calib_raw[19] << 8);
    g_calib.dig_P8 = calib_raw[20] | (calib_raw[21] << 8);
    g_calib.dig_P9 = calib_raw[22] | (calib_raw[23] << 8);
    
    // BMP280 requires config to be written in sleep mode FIRST
    // Step 1: Ensure sleep mode (after reset, already in sleep)
    i2c_write_register(BMP280_REG_CTRL_MEAS, 0x00);  // Force sleep mode
    sleep_ms(5);
    
    // Step 2: Write config register (IIR filter) while in sleep mode
    i2c_write_register(BMP280_REG_CONFIG, BMP280_CONFIG_FILTERED);
    sleep_ms(5);
    
    // Step 3: Write ctrl_meas to enable measurements and start normal mode
    // Stable: osrs_t=001 (x1), osrs_p=101 (x16), mode=11 (normal) = 0x57
    i2c_write_register(BMP280_REG_CTRL_MEAS, BMP280_CTRL_STABLE);
    sleep_ms(50);  // Wait for first measurement
    
    // Verify registers were written correctly
    uint8_t ctrl_meas_read, config_read;
    i2c_read_registers(BMP280_REG_CTRL_MEAS, &ctrl_meas_read, 1);
    i2c_read_registers(BMP280_REG_CONFIG, &config_read, 1);
    printf("INFO:CTRL_MEAS=0x%02X CONFIG=0x%02X (X16+IIR2)\n", ctrl_meas_read, config_read);
    
    return true;
}

static float bmp280_read_pressure(void) {
    uint8_t data[6];
    i2c_read_registers(BMP280_REG_PRESS_MSB, data, 6);
    
    // Parse 20-bit ADC values
    int32_t adc_P = ((int32_t)data[0] << 12) | ((int32_t)data[1] << 4) | (data[2] >> 4);
    int32_t adc_T = ((int32_t)data[3] << 12) | ((int32_t)data[4] << 4) | (data[5] >> 4);
    
    // Temperature compensation (required for accurate pressure)
    int32_t var1 = ((((adc_T >> 3) - ((int32_t)g_calib.dig_T1 << 1))) * 
                    ((int32_t)g_calib.dig_T2)) >> 11;
    int32_t var2 = (((((adc_T >> 4) - ((int32_t)g_calib.dig_T1)) * 
                      ((adc_T >> 4) - ((int32_t)g_calib.dig_T1))) >> 12) * 
                    ((int32_t)g_calib.dig_T3)) >> 14;
    g_calib.t_fine = var1 + var2;
    
    // Pressure compensation (64-bit arithmetic for precision)
    int64_t p_var1 = ((int64_t)g_calib.t_fine) - 128000;
    int64_t p_var2 = p_var1 * p_var1 * (int64_t)g_calib.dig_P6;
    p_var2 += (p_var1 * (int64_t)g_calib.dig_P5) << 17;
    p_var2 += ((int64_t)g_calib.dig_P4) << 35;
    p_var1 = ((p_var1 * p_var1 * (int64_t)g_calib.dig_P3) >> 8) + 
             ((p_var1 * (int64_t)g_calib.dig_P2) << 12);
    p_var1 = ((((int64_t)1) << 47) + p_var1) * ((int64_t)g_calib.dig_P1) >> 33;
    
    if (p_var1 == 0) return 0.0f;
    
    int64_t p = 1048576 - adc_P;
    p = (((p << 31) - p_var2) * 3125) / p_var1;
    p_var1 = (((int64_t)g_calib.dig_P9) * (p >> 13) * (p >> 13)) >> 25;
    p_var2 = (((int64_t)g_calib.dig_P8) * p) >> 19;
    p = ((p + p_var1 + p_var2) >> 8) + (((int64_t)g_calib.dig_P7) << 4);
    
    return (float)p / 25600.0f;  // Convert to hPa
}

/* ============================================================================
 * Command Processing
 * ========================================================================== */

/**
 * @brief Process a single character from USB input
 * 
 * Supported commands:
 *   P           - Ping (keep connection alive)
 *   R           - Reset baseline pressure
 *   C           - Get configuration (sample rate)
 *   I           - Get device info (serial, name)
 *   N<pin><name>- Set device name (requires PIN)
 *   W<old><new> - Change PIN (requires current PIN)
 */
static void cmd_process_char(char c) {
    uint64_t now_ms = time_us_64() / 1000;
    
    // Multi-character command in progress?
    if (g_cmd_type != 0) {
        if (c == '\n' || c == '\r') {
            g_cmd_buffer[g_cmd_pos] = '\0';
            
            switch (g_cmd_type) {
                case 'N': case 'n': {
                    // Format: N<4-digit PIN><name>
                    if (g_cmd_pos >= DEVICE_PIN_LEN) {
                        char pin[DEVICE_PIN_LEN + 1];
                        strncpy(pin, g_cmd_buffer, DEVICE_PIN_LEN);
                        pin[DEVICE_PIN_LEN] = '\0';
                        
                        if (pin_verify(pin)) {
                            const char *name = g_cmd_buffer + DEVICE_PIN_LEN;
                            if (strlen(name) > 0) {
                                device_set_name(name);
                                printf("INFO:Name saved\n");
                            } else {
                                printf("ERR:Empty name\n");
                            }
                        } else {
                            printf("ERR:Wrong PIN\n");
                        }
                    } else {
                        printf("ERR:Format N<PIN><NAME>\n");
                    }
                    break;
                }
                
                case 'W': case 'w': {
                    // Format: W<old 4-digit><new 4-digit>
                    if (g_cmd_pos == DEVICE_PIN_LEN * 2) {
                        char old_pin[DEVICE_PIN_LEN + 1];
                        char new_pin[DEVICE_PIN_LEN + 1];
                        strncpy(old_pin, g_cmd_buffer, DEVICE_PIN_LEN);
                        old_pin[DEVICE_PIN_LEN] = '\0';
                        strncpy(new_pin, g_cmd_buffer + DEVICE_PIN_LEN, DEVICE_PIN_LEN);
                        new_pin[DEVICE_PIN_LEN] = '\0';
                        
                        if (!pin_verify(old_pin)) {
                            printf("ERR:Wrong PIN\n");
                        } else if (!pin_is_valid_format(new_pin)) {
                            printf("ERR:PIN must be 4 digits\n");
                        } else {
                            device_set_pin(new_pin);
                            printf("INFO:PIN changed\n");
                        }
                    } else {
                        printf("ERR:Format W<OLD><NEW>\n");
                    }
                    break;
                }
                
                case 'A': case 'a': {
                    // Format: A<64 hex chars = 32 byte nonce>
                    // ECDSA challenge-response authentication
                    ecdsa_sign_challenge(g_cmd_buffer, g_cmd_pos);
                    break;
                }
                
                case 'F': case 'f': {
                    // Set output frequency: F8, F16, F32, F50
                    int rate = atoi(g_cmd_buffer);
                    if (rate >= MIN_OUTPUT_RATE_HZ && rate <= MAX_OUTPUT_RATE_HZ) {
                        g_output_rate = rate;
                        g_output_interval_ms = 1000 / rate;
                        g_samples_per_output = INTERNAL_SAMPLE_RATE_HZ / rate;
                        printf("INFO:Output rate %dHz (%d samples avg)\n", 
                               g_output_rate, g_samples_per_output);
                    } else {
                        printf("ERR:Rate must be %d-%dHz\n", 
                               MIN_OUTPUT_RATE_HZ, MAX_OUTPUT_RATE_HZ);
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
    
    // Single-character commands
    switch (c) {
        case 'P': case 'p':
            g_last_ping_ms = now_ms;
            if (!g_app_connected) {
                g_app_connected = true;
                g_baseline_set = false;  // Reset baseline on new connection
                g_baseline_printed = false;
                led_set_state(LED_STATE_APP_CONNECTED);
                printf("INFO:Connected\n");
            }
            printf("PONG\n");
            break;
            
        case 'R': case 'r':
            g_baseline_set = false;
            printf("INFO:Baseline reset\n");
            break;
            
        case 'C': case 'c':
            printf("CFG:%d\n", g_output_rate);
            break;
        
        case 'F': case 'f':
            // Set output frequency: F8, F16, F32, F50
            g_cmd_type = c;
            g_cmd_pos = 0;
            break;
            
        case 'I': case 'i':
            printf("INFO:Serial %s\n", g_serial_number);
            printf("INFO:Name %s\n", g_device_name);
            printf("INFO:Sensor %s\n", g_sensor_ready ? "OK" : "Error");
            break;
        
        case 'T': case 't': {
            // Debug test: read raw sensor data and fix if needed
            printf("INFO:Sensor debug test...\n");
            
            // Read chip ID
            uint8_t chip_id, ctrl_meas, config_reg;
            uint8_t reg = 0xD0;
            i2c_write_blocking(I2C_PORT, BMP280_I2C_ADDR, &reg, 1, true);
            i2c_read_blocking(I2C_PORT, BMP280_I2C_ADDR, &chip_id, 1, false);
            
            reg = 0xF4;  // CTRL_MEAS
            i2c_write_blocking(I2C_PORT, BMP280_I2C_ADDR, &reg, 1, true);
            i2c_read_blocking(I2C_PORT, BMP280_I2C_ADDR, &ctrl_meas, 1, false);
            
            reg = 0xF5;  // CONFIG
            i2c_write_blocking(I2C_PORT, BMP280_I2C_ADDR, &reg, 1, true);
            i2c_read_blocking(I2C_PORT, BMP280_I2C_ADDR, &config_reg, 1, false);
            
            printf("ChipID: 0x%02X | CTRL_MEAS: 0x%02X | CONFIG: 0x%02X\n", 
                   chip_id, ctrl_meas, config_reg);
            
            // Check if pressure measurement is disabled (osrs_p = 000)
            if ((ctrl_meas & 0x1C) == 0x00) {
                printf("WARN: Pressure disabled! Reinitializing...\n");
                
                // Force sleep mode
                i2c_write_register(BMP280_REG_CTRL_MEAS, 0x00);
                sleep_ms(10);
                
                // Write config in sleep mode
                i2c_write_register(BMP280_REG_CONFIG, BMP280_CONFIG_FILTERED);
                sleep_ms(10);
                
                // Enable normal mode with T+P measurement
                // osrs_t=001, osrs_p=101 (x16), mode=11 = 0x57
                i2c_write_register(BMP280_REG_CTRL_MEAS, 0x57);
                sleep_ms(100);
                
                // Read back to verify
                reg = 0xF4;
                i2c_write_blocking(I2C_PORT, BMP280_I2C_ADDR, &reg, 1, true);
                i2c_read_blocking(I2C_PORT, BMP280_I2C_ADDR, &ctrl_meas, 1, false);
                printf("After reinit: CTRL_MEAS=0x%02X (expect 0x57)\n", ctrl_meas);
            }
            
            // Read raw data using FORCED MODE (single shot, guaranteed complete)
            printf("Testing FORCED MODE (single measurement, X16)...\n");
            for (int i = 0; i < 5; i++) {
                // Trigger single forced measurement
                // osrs_t=001, osrs_p=101 (x16), mode=01 (forced) = 0x55
                i2c_write_register(BMP280_REG_CTRL_MEAS, 0x55);
                sleep_ms(50);  // Wait for measurement (max 6.4ms, use 50ms to be safe)
                
                uint8_t data[6];
                reg = 0xF7;
                i2c_write_blocking(I2C_PORT, BMP280_I2C_ADDR, &reg, 1, true);
                i2c_read_blocking(I2C_PORT, BMP280_I2C_ADDR, data, 6, false);
                
                int32_t adc_P = ((int32_t)data[0] << 12) | ((int32_t)data[1] << 4) | (data[2] >> 4);
                int32_t adc_T = ((int32_t)data[3] << 12) | ((int32_t)data[4] << 4) | (data[5] >> 4);
                printf("[%d] FORCED: P=%02X%02X%02X T=%02X%02X%02X | P_adc=%d T_adc=%d\n", 
                       i, data[0], data[1], data[2], data[3], data[4], data[5], adc_P, adc_T);
                sleep_ms(100);
            }
            
            // Restore normal mode (X16)
            i2c_write_register(BMP280_REG_CTRL_MEAS, 0x57);
            
            printf("INFO:Test complete\n");
            break;
        }
            
        case 'N': case 'n':
        case 'W': case 'w':
        case 'A': case 'a':
            g_cmd_type = c;
            g_cmd_pos = 0;
            break;
            
        case 'B': case 'b':
            // Reboot to BOOTSEL mode for firmware update
            printf("INFO:Rebooting to BOOTSEL...\n");
            stdio_flush();  // Ensure message is sent
            sleep_ms(200);  // Give time for USB to complete
            // Disable interrupts and reset to BOOTSEL
            multicore_reset_core1();  // Stop Core 1 first
            reset_usb_boot(0, 0);     // 0,0 = no PICOBOOT, no mass storage disable
            // Should not reach here
            break;
    }
}

/* ============================================================================
 * Core 1: Sensor Sampling Task
 * ========================================================================== */

static void core1_sensor_task(void) {
    // Initialize I2C on Core 1
    i2c_init(I2C_PORT, I2C_BAUDRATE);
    gpio_set_function(I2C_SDA_PIN, GPIO_FUNC_I2C);
    gpio_set_function(I2C_SCL_PIN, GPIO_FUNC_I2C);
    gpio_pull_up(I2C_SDA_PIN);
    gpio_pull_up(I2C_SCL_PIN);
    
    sleep_ms(100);  // Sensor power-up delay
    
    g_sensor_ready = bmp280_init();
    
    // Signal Core 0 that initialization is complete
    multicore_fifo_push_blocking(g_sensor_ready ? 1 : 0);
    
    // Sample buffer for averaging (sized for minimum rate = max samples)
    float sample_buffer[MAX_SAMPLES_PER_OUTPUT + 2];
    int sample_count = 0;
    
    // Timing
    uint64_t last_sample_us = 0;
    uint64_t last_output_ms = 0;
    
    // Main sampling loop
    while (true) {
        if (g_sensor_ready && g_app_connected) {
            uint64_t now_us = time_us_64();
            uint64_t now_ms = now_us / 1000;
            
            // 100Hz internal sampling
            if (now_us - last_sample_us >= SAMPLE_INTERVAL_US) {
                last_sample_us = now_us;
                
                if (sample_count < g_samples_per_output) {
                    sample_buffer[sample_count++] = bmp280_read_pressure();
                }
            }
            
            // Dynamic output rate (configurable via F command)
            if (now_ms - last_output_ms >= (uint64_t)g_output_interval_ms) {
                last_output_ms = now_ms;
                
                if (sample_count > 0) {
                    // Calculate average
                    float sum = 0;
                    for (int i = 0; i < sample_count; i++) {
                        sum += sample_buffer[i];
                    }
                    float avg_pressure = sum / sample_count;
                    sample_count = 0;
                    
                    // Set baseline on first valid reading
                    if (!g_baseline_set) {
                        g_baseline_pressure = avg_pressure;
                        g_baseline_set = true;
                    }
                    
                    // Calculate delta (hPa * 1000 for precision)
                    float delta = avg_pressure - g_baseline_pressure;
                    int32_t delta_x1000 = (int32_t)(delta * 1000.0f);
                    
                    // Noise floor
                    if (delta_x1000 > -1 && delta_x1000 < 1) {
                        delta_x1000 = 0;
                    }
                    
                    // Send to Core 0
                    pressure_packet_t packet = {
                        .delta_x1000 = delta_x1000
                    };
                    queue_try_add(&g_pressure_queue, &packet);
                }
            }
        } else {
            // Reset when not connected
            sample_count = 0;
        }
        
        sleep_us(100);
    }
}

/* ============================================================================
 * Core 0: Main Entry Point
 * ========================================================================== */

static void init_serial_number(void) {
    pico_unique_board_id_t board_id;
    pico_get_unique_board_id(&board_id);
    snprintf(g_serial_number, sizeof(g_serial_number),
             "%02X%02X%02X%02X%02X%02X%02X%02X",
             board_id.id[0], board_id.id[1], board_id.id[2], board_id.id[3],
             board_id.id[4], board_id.id[5], board_id.id[6], board_id.id[7]);
}

static void print_startup_banner(void) {
    printf("\n");
    printf("========================================\n");
    printf("  DiveChecker RP2350 v%s\n", FW_VERSION_STRING);
    printf("  Dual-Core %dHz -> %dHz Output\n", INTERNAL_SAMPLE_RATE_HZ, g_output_rate);
    printf("========================================\n\n");
    printf("Device : %s\n", g_device_name);
    printf("Serial : %s\n", g_serial_number);
    printf("I2C    : GP%d/GP%d @ %dkHz\n", I2C_SDA_PIN, I2C_SCL_PIN, I2C_BAUDRATE / 1000);
    printf("Sensor : %s (X16 + IIR X2)\n", g_sensor_ready ? "OK" : "NOT FOUND");
    printf("Mode   : Core0=USB, Core1=Sensor\n");
    printf("Output : %dHz (%d-%dHz, F<rate> to change)\n", g_output_rate, MIN_OUTPUT_RATE_HZ, MAX_OUTPUT_RATE_HZ);
    printf("Filter : Average (%d samples)\n", g_samples_per_output);
    printf("\nINFO:Ready\n");
    printf("========================================\n");
}

int main(void) {
    // Initialize device identity
    init_serial_number();
    flash_load_settings();
    
    // Initialize USB CDC
    stdio_init_all();
    
    // Initialize inter-core queue
    queue_init(&g_pressure_queue, sizeof(pressure_packet_t), PRESSURE_QUEUE_SIZE);
    
    // Initialize LED
    led_init();
    led_set_state(LED_STATE_BOOT);
    
    // Launch sensor task on Core 1
    multicore_launch_core1(core1_sensor_task);
    
    // Wait for Core 1 initialization
    uint32_t sensor_status = multicore_fifo_pop_blocking();
    g_sensor_ready = (sensor_status == 1);
    
    // Wait for USB connection with blinking LED
    bool blink = false;
    while (!stdio_usb_connected()) {
        blink = !blink;
        led_set_state(blink ? LED_STATE_USB_WAIT : LED_STATE_OFF);
        sleep_ms(500);
    }
    led_set_state(LED_STATE_USB_READY);
    sleep_ms(500);
    
    // Print startup info
    print_startup_banner();
    
    // Main loop: USB communication on Core 0
    uint64_t last_beacon_ms = 0;
    
    while (true) {
        uint64_t now_ms = time_us_64() / 1000;
        
        // Process incoming USB data
        int c = getchar_timeout_us(0);
        if (c != PICO_ERROR_TIMEOUT) {
            cmd_process_char((char)c);
        }
        
        // Check for connection timeout
        if (g_app_connected && (now_ms - g_last_ping_ms > CONNECTION_TIMEOUT_MS)) {
            g_app_connected = false;
            g_baseline_printed = false;  // Reset for next connection
            led_set_state(LED_STATE_USB_READY);
            printf("INFO:Disconnected\n");
        }
        
        // Send beacon for auto-sync when not connected to app
        // Format: BEACON:<serial>:<name>
        if (!g_app_connected && (now_ms - last_beacon_ms >= 200)) {
            last_beacon_ms = now_ms;
            printf("BEACON:%s:%s\n", g_serial_number, g_device_name);
        }
        
        // Forward pressure data from Core 1
        pressure_packet_t packet;
        while (queue_try_remove(&g_pressure_queue, &packet)) {
            if (g_app_connected) {
                // Send baseline info once
                if (!g_baseline_printed && g_baseline_set) {
                    printf("INFO:Baseline %.3f hPa\n", g_baseline_pressure);
                    g_baseline_printed = true;
                }
                // D: format (delta hPa * 1000)
                printf("D:%d\n", packet.delta_x1000);
            }
        }
        
        sleep_us(100);
    }
    
    return 0;
}

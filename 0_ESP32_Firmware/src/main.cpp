/*
 * DiveChecker ESP32-C3 Firmware
 * 
 * USB Serial pressure sensor for freediving equalizing training.
 * Connects to DiveChecker Flutter app via USB Serial (CDC).
 * 
 * Features:
 * - 100Hz high-speed sampling for accurate peak detection
 * - Average filtering with 8Hz USB transmission
 * - Simple text-based protocol for easy debugging
 * 
 * Hardware: ESP32-C3 + BME280 I2C pressure sensor
 * 
 * Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
 * Licensed under the Apache License, Version 2.0
 */

#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_BME280.h>

// ============== Configuration ==============

// ESP32-C3 I2C Pins
#define I2C_SDA  8    // GPIO8
#define I2C_SCL  9    // GPIO9

// ============== Sampling Configuration ==============
// High-speed internal sampling (100Hz) for accurate peak detection
// Output rate to app is fixed at 8Hz (0.125s interval)

#define INTERNAL_SAMPLE_RATE  100   // Hz (10ms interval) - internal sampling
#define OUTPUT_RATE           8     // Hz (125ms interval) - USB transmission
#define SAMPLES_PER_OUTPUT    (INTERNAL_SAMPLE_RATE / OUTPUT_RATE)  // 12.5 samples

// Oversampling (configurable via Serial)
uint8_t currentOversampling = 16; // 1, 2, 4, 8, 16

// LED (ESP32-C3 built-in, varies by board)
#define LED_PIN  3  // GPIO3

// Serial Protocol Commands
#define CMD_SET_OVERSAMPLING  'O'  // O16 -> Set oversampling X16
#define CMD_RESET_BASELINE    'R'  // R -> Reset baseline
#define CMD_GET_CONFIG        'C'  // C -> Get config
#define CMD_PING              'P'  // P -> Ping (connection check)

// Serial Protocol Prefixes
#define PREFIX_PRESSURE       "D:"    // D:1234 -> Pressure data (x1000)
#define PREFIX_CONFIG         "CFG:"  // CFG:16,8 -> Config (oversampling, rate)
#define PREFIX_PONG           "PONG"  // PONG -> Ping response
#define PREFIX_INFO           "INFO:" // INFO:message -> Info message
#define PREFIX_ERROR          "ERR:"  // ERR:message -> Error message

// ============== Global Variables ==============

Adafruit_BME280 bme;
bool sensorInitialized = false;

// High-speed sampling variables
unsigned long lastInternalSampleTime = 0;
const unsigned long internalSampleInterval = 1000 / INTERNAL_SAMPLE_RATE;  // 10ms

// Output timing (8Hz to app)
unsigned long lastOutputTime = 0;
const unsigned long outputInterval = 1000 / OUTPUT_RATE;  // 125ms

// Sample buffer for average calculation
float sampleBuffer[SAMPLES_PER_OUTPUT];
int sampleCount = 0;

float baselinePressure = 0;
bool baselineSet = false;

// Connection check
unsigned long lastPingTime = 0;
bool isConnected = false;
#define CONNECTION_TIMEOUT_MS  3000  // 3초 동안 핑 없으면 연결 끊김

// ============== Function Prototypes ==============

void initSensor();
void scanI2C();
void collectHighSpeedSample();
void processAndSendData();
float readPressure();
float getAverageFromBuffer();
void processSerialCommand();
void applyBmeSampling();
void sendConfigResponse();

// ============== Setup ==============

void setup() {
    Serial.begin(115200);
    
    unsigned long startWait = millis();
    while (!Serial && (millis() - startWait < 3000)) {
        delay(10);
    }
    delay(500);
    
    // LED 설정
    pinMode(LED_PIN, OUTPUT);
    digitalWrite(LED_PIN, LOW);
    
    Serial.println();
    Serial.println("╔════════════════════════════════════╗");
    Serial.println("║  DiveChecker ESP32-C3 Firmware     ║");
    Serial.println("║  v3.0.0 (USB Serial Only)          ║");
    Serial.println("╚════════════════════════════════════╝");
    Serial.println();
    
    Wire.begin(I2C_SDA, I2C_SCL);
    Wire.setClock(400000);
    Serial.printf("INFO:I2C SDA=GPIO%d SCL=GPIO%d 400kHz\n", I2C_SDA, I2C_SCL);
    
    scanI2C();
    initSensor();
    
    Serial.println();
    Serial.println("════════════════════════════════════");
    Serial.printf("INFO:Sampling %dHz internal -> %dHz output\n", INTERNAL_SAMPLE_RATE, OUTPUT_RATE);
    Serial.println("INFO:Average filter for noise reduction");
    Serial.println("INFO:Ready! Connect via USB Serial");
    Serial.println("════════════════════════════════════");
}

void scanI2C() {
    Serial.println("INFO:Scanning I2C bus...");
    int found = 0;
    
    for (byte addr = 1; addr < 127; addr++) {
        Wire.beginTransmission(addr);
        if (Wire.endTransmission() == 0) {
            Serial.printf("INFO:Found device at 0x%02X", addr);
            
            if (addr == 0x76 || addr == 0x77) {
                Wire.beginTransmission(addr);
                Wire.write(0xD0);
                Wire.endTransmission();
                Wire.requestFrom(addr, (uint8_t)1);
                if (Wire.available()) {
                    uint8_t chipId = Wire.read();
                    Serial.printf(" (Chip ID: 0x%02X", chipId);
                    if (chipId == 0x58) Serial.print(" = BMP280");
                    else if (chipId == 0x60) Serial.print(" = BME280");
                    Serial.print(")");
                }
            }
            Serial.println();
            found++;
        }
    }
    
    if (found == 0) {
        Serial.println("ERR:No I2C devices found!");
    }
}

void initSensor() {
    Serial.print("INFO:Initializing BME280... ");
    
    delay(100);
    
    for (int attempt = 0; attempt < 3; attempt++) {
        if (bme.begin(0x76)) {
            sensorInitialized = true;
            Serial.println("OK (0x76)");
            break;
        }
        if (bme.begin(0x77)) {
            sensorInitialized = true;
            Serial.println("OK (0x77)");
            break;
        }
        delay(100);
    }
    
    if (!sensorInitialized) {
        Serial.println("FAILED");
        return;
    }
    
    // Configure for high-speed pressure reading (100Hz capable)
    bme.setSampling(
        Adafruit_BME280::MODE_NORMAL,
        Adafruit_BME280::SAMPLING_X1,    // Temperature (min)
        Adafruit_BME280::SAMPLING_X16,   // Pressure (max resolution)
        Adafruit_BME280::SAMPLING_NONE,  // Humidity disabled
        Adafruit_BME280::FILTER_X2,      // Lower IIR for faster response
        Adafruit_BME280::STANDBY_MS_0_5  // Min standby
    );
    
    float testPressure = bme.readPressure() / 100.0f;
    float testTemp = bme.readTemperature();
    Serial.printf("INFO:Initial %.2f hPa %.1f C\n", testPressure, testTemp);
    Serial.printf("INFO:Config OS=X%d\n", currentOversampling);
}

// ============== Main Loop ==============

void loop() {
    unsigned long now = millis();
    
    // Serial 명령 처리
    processSerialCommand();
    
    // 연결 타임아웃 체크
    if (isConnected && (now - lastPingTime > CONNECTION_TIMEOUT_MS)) {
        isConnected = false;
        digitalWrite(LED_PIN, LOW);
        Serial.println("INFO:Connection timeout");
    }
    
    if (sensorInitialized) {
        // 100Hz 고속 샘플링
        if (now - lastInternalSampleTime >= internalSampleInterval) {
            lastInternalSampleTime = now;
            collectHighSpeedSample();
        }
        
        // 8Hz로 앱에 전송 (연결되었을 때만)
        if (isConnected && (now - lastOutputTime >= outputInterval)) {
            lastOutputTime = now;
            processAndSendData();
        }
    }
    
    delayMicroseconds(100);
}

// Serial 명령 처리
void processSerialCommand() {
    if (Serial.available() == 0) return;
    
    String cmd = Serial.readStringUntil('\n');
    cmd.trim();
    
    if (cmd.length() == 0) return;
    
    char cmdType = cmd.charAt(0);
    
    switch (cmdType) {
        case CMD_PING:
            lastPingTime = millis();
            if (!isConnected) {
                isConnected = true;
                digitalWrite(LED_PIN, HIGH);
                baselineSet = false;  // 새 연결 시 베이스라인 리셋
                sampleCount = 0;
                Serial.println("INFO:Connected");
            }
            Serial.println(PREFIX_PONG);
            break;
            
        case CMD_SET_OVERSAMPLING:
            if (cmd.length() > 1) {
                int value = cmd.substring(1).toInt();
                if (value == 1 || value == 2 || value == 4 || value == 8 || value == 16) {
                    currentOversampling = value;
                    applyBmeSampling();
                    Serial.printf("INFO:Oversampling set to X%d\n", value);
                } else {
                    Serial.println("ERR:Invalid oversampling (1,2,4,8,16)");
                }
            }
            break;
            
        case CMD_RESET_BASELINE:
            baselineSet = false;
            sampleCount = 0;
            Serial.println("INFO:Baseline reset");
            break;
            
        case CMD_GET_CONFIG:
            sendConfigResponse();
            break;
            
        default:
            // 알 수 없는 명령은 무시 (디버그 메시지도 생략)
            break;
    }
}

// 100Hz 고속 샘플링 - 버퍼에 저장
void collectHighSpeedSample() {
    if (sampleCount < SAMPLES_PER_OUTPUT) {
        sampleBuffer[sampleCount] = readPressure();
        sampleCount++;
    }
}

// 8Hz로 처리 후 앱에 전송
void processAndSendData() {
    if (sampleCount == 0) return;
    
    // 샘플 평균값 사용 (노이즈 감소)
    float outputPressure = getAverageFromBuffer();
    
    sampleCount = 0;
    
    // 베이스라인 설정
    if (!baselineSet) {
        baselinePressure = outputPressure;
        baselineSet = true;
        Serial.printf("INFO:Baseline %.3f hPa\n", baselinePressure);
    }
    
    float relativePressure = outputPressure - baselinePressure;
    
    // x1000 정수로 변환하여 전송
    int32_t pressureInt = (int32_t)(relativePressure * 1000);
    
    // 0에 가까운 값은 0으로 처리
    if (pressureInt > -1 && pressureInt < 1) {
        pressureInt = 0;
    }
    
    // 텍스트 형식으로 전송: D:1234 (압력 x1000)
    Serial.printf("%s%d\n", PREFIX_PRESSURE, pressureInt);
}

float getAverageFromBuffer() {
    if (sampleCount == 0) return 0;
    
    float sum = 0;
    for (int i = 0; i < sampleCount; i++) {
        sum += sampleBuffer[i];
    }
    return sum / sampleCount;
}

float readPressure() {
    if (!sensorInitialized) return 0.0f;
    return bme.readPressure() / 100.0f;
}

// ============== BME Sampling ==========================

void applyBmeSampling() {
    if (!sensorInitialized) return;
    
    Adafruit_BME280::sensor_sampling sampling;
    switch (currentOversampling) {
        case 1:  sampling = Adafruit_BME280::SAMPLING_X1;  break;
        case 2:  sampling = Adafruit_BME280::SAMPLING_X2;  break;
        case 4:  sampling = Adafruit_BME280::SAMPLING_X4;  break;
        case 8:  sampling = Adafruit_BME280::SAMPLING_X8;  break;
        case 16: sampling = Adafruit_BME280::SAMPLING_X16; break;
        default: sampling = Adafruit_BME280::SAMPLING_X16; break;
    }
    
    bme.setSampling(
        Adafruit_BME280::MODE_NORMAL,
        Adafruit_BME280::SAMPLING_X1,
        sampling,
        Adafruit_BME280::SAMPLING_NONE,
        Adafruit_BME280::FILTER_X2,
        Adafruit_BME280::STANDBY_MS_0_5
    );
}

void sendConfigResponse() {
    // CFG:oversampling,rate
    Serial.printf("%s%d,%d\n", PREFIX_CONFIG, currentOversampling, OUTPUT_RATE);
}

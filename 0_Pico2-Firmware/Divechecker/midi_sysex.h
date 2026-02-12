/**
 * @file midi_sysex.h
 * @brief MIDI SysEx Protocol for DiveChecker
 * 
 * SysEx format: F0 [manufacturer_id] [device_id] [command] [data...] F7
 * Manufacturer ID: 0x7D (educational/development use)
 * Device ID: 0x01 (DiveChecker)
 */

#ifndef MIDI_SYSEX_H
#define MIDI_SYSEX_H

#include <stdint.h>
#include <stdbool.h>

// SysEx Protocol Constants
#define SYSEX_START             0xF0
#define SYSEX_END               0xF7
#define SYSEX_MANUFACTURER_ID   0x7D    // Educational/development
#define SYSEX_DEVICE_ID         0x01    // DiveChecker

// Command bytes (Device -> App)
#define CMD_PRESSURE            0x01    // Pressure data (5 bytes: 7-bit encoded int32)
#define CMD_DEVICE_INFO         0x02    // Device info response
#define CMD_CONFIG              0x03    // Config response (legacy: output rate only)
#define CMD_AUTH_RESPONSE       0x04    // Auth response
#define CMD_SENSOR_STATUS       0x05    // Sensor status
#define CMD_OVERRANGE_ALERT     0x06    // Sensor over-range warning
#define CMD_TEMPERATURE         0x07    // Temperature data (int16 x100)
#define CMD_DIAGNOSTICS         0x08    // Runtime diagnostics
#define CMD_FULL_CONFIG         0x09    // Full config dump
#define CMD_ACK                 0x0A    // Generic acknowledgment (cmd + status)

// Command bytes (Bidirectional)
#define CMD_PING                0x10    // Ping request
#define CMD_PONG                0x11    // Pong response

// Command bytes (App -> Device)
#define CMD_REQUEST_INFO        0x20    // Request device info
#define CMD_SET_NAME            0x21    // Set device name (PIN required)
#define CMD_SET_OUTPUT_RATE     0x22    // Set output rate (1 byte: 4-50 Hz)
#define CMD_RESET_BASELINE      0x23    // Reset baseline
#define CMD_GET_CONFIG          0x24    // Request full config dump
#define CMD_SET_LED             0x25    // Set LED brightness (1 byte: 0-100)
#define CMD_RESET_SENSOR        0x26    // Manual sensor re-init
#define CMD_FACTORY_RESET       0x27    // Factory reset (PIN required)
#define CMD_SET_NOISE_FLOOR     0x28    // Set noise floor (1 byte: 0-50)
#define CMD_GET_TEMPERATURE     0x29    // Request current temperature
#define CMD_ENTER_BOOTLOADER    0x2A    // Enter BOOTSEL mode (PIN required)
#define CMD_GET_DIAGNOSTICS     0x2B    // Request runtime diagnostics
#define CMD_SET_OVERSAMPLING    0x2C    // Set pressure oversampling (1 byte: 0-5)
#define CMD_SET_IIR_FILTER      0x2D    // Set IIR filter coefficient (1 byte: 0-4)
#define CMD_AUTH_CHALLENGE      0x30    // Auth challenge (32 bytes nonce)
#define CMD_SET_PIN             0x31    // Set PIN (old PIN + new PIN)

// SysEx buffer size (needs 150+ bytes for auth signature)
#define SYSEX_MAX_SIZE          256

/**
 * @brief SysEx message structure
 */
typedef struct {
    uint8_t command;
    uint8_t data[SYSEX_MAX_SIZE - 5];  // Exclude F0, mfr, dev, cmd, F7
    uint8_t data_len;
} sysex_message_t;

/**
 * @brief Initialize MIDI SysEx handler
 */
void midi_sysex_init(void);

/**
 * @brief Process incoming MIDI data
 * @param byte Single byte from MIDI stream
 * @return true if a complete SysEx message was received
 */
bool midi_sysex_receive_byte(uint8_t byte);

/**
 * @brief Get the last received SysEx message
 * @return Pointer to message structure, or NULL if no message
 */
sysex_message_t* midi_sysex_get_message(void);

/**
 * @brief Send pressure data via SysEx
 * @param pressure_mpa Pressure in milli-Pascal (int32)
 */
void midi_sysex_send_pressure(int32_t pressure_mpa);

/**
 * @brief Send device info via SysEx
 * @param serial Serial number string
 * @param name Device name string
 * @param fw_version Firmware version string
 * @param sensor_ok Sensor status
 */
void midi_sysex_send_device_info(const char* serial, const char* name, 
                                  const char* fw_version, bool sensor_ok);

/**
 * @brief Send config response via SysEx
 * @param output_rate Current output rate in Hz
 */
void midi_sysex_send_config(uint8_t output_rate);

/**
 * @brief Send auth response (signature) via SysEx
 * @param signature DER-encoded ECDSA signature
 * @param sig_len Signature length
 */
void midi_sysex_send_auth_response(const uint8_t* signature, uint8_t sig_len);

/**
 * @brief Send sensor status via SysEx
 * @param connected true if sensor is connected
 */
void midi_sysex_send_sensor_status(bool connected);

/**
 * @brief Send over-range alert via SysEx
 * @details Notifies the app that sensor exceeded measurement range
 */
void midi_sysex_send_overrange_alert(void);

/**
 * @brief Send pong response
 */
void midi_sysex_send_pong(void);

/**
 * @brief Send full config dump via SysEx
 * @param output_rate Output rate in Hz
 * @param led_brightness LED brightness 0-100
 * @param noise_floor Noise floor threshold x1000
 * @param oversampling BMP280 oversampling control value (0-5)
 * @param iir_filter BMP280 IIR filter coefficient (0-4)
 */
void midi_sysex_send_full_config(uint8_t output_rate, uint8_t led_brightness,
                                  uint8_t noise_floor, uint8_t oversampling,
                                  uint8_t iir_filter);

/**
 * @brief Send temperature data via SysEx
 * @param temp_x100 Temperature in Celsius x100 (int16)
 */
void midi_sysex_send_temperature(int16_t temp_x100);

/**
 * @brief Send runtime diagnostics via SysEx
 * @param uptime_sec Uptime in seconds
 * @param sensor_errors Cumulative sensor error count
 * @param overrange_count Cumulative over-range event count
 * @param i2c_recovery_count I2C bus recovery count
 * @param cpu_temp_x100 RP2350 internal temp x100 (if available, else 0)
 */
void midi_sysex_send_diagnostics(uint32_t uptime_sec, uint16_t sensor_errors,
                                  uint16_t overrange_count, uint16_t i2c_recovery_count,
                                  int16_t cpu_temp_x100);

/**
 * @brief Send generic acknowledgment via SysEx
 * @param cmd_id The command being acknowledged
 * @param status 0=success, 1=invalid param, 2=auth required, 3=error
 */
void midi_sysex_send_ack(uint8_t cmd_id, uint8_t status);

#endif // MIDI_SYSEX_H

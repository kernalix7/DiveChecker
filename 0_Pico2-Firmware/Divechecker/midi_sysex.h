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
#define CMD_PRESSURE            0x01    // Pressure data (4 bytes: int32 mPa, big-endian)
#define CMD_DEVICE_INFO         0x02    // Device info response
#define CMD_CONFIG              0x03    // Config response
#define CMD_AUTH_RESPONSE       0x04    // Auth response
#define CMD_SENSOR_STATUS       0x05    // Sensor status

// Command bytes (Bidirectional)
#define CMD_PING                0x10    // Ping request
#define CMD_PONG                0x11    // Pong response

// Command bytes (App -> Device)
#define CMD_REQUEST_INFO        0x20    // Request device info
#define CMD_SET_NAME            0x21    // Set device name (PIN required)
#define CMD_SET_OUTPUT_RATE     0x22    // Set output rate
#define CMD_RESET_BASELINE      0x23    // Reset baseline
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
 * @brief Send SysEx message
 * @param command Command byte
 * @param data Payload data (can be NULL if len is 0)
 * @param len Payload length
 */
void midi_sysex_send(uint8_t command, const uint8_t* data, uint8_t len);

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
 * @brief Send pong response
 */
void midi_sysex_send_pong(void);

#endif // MIDI_SYSEX_H

/**
 * @file midi_sysex.c
 * @brief MIDI SysEx Protocol Implementation for DiveChecker
 *
 * @author Createch (legal@createch.kr)
 * @copyright Copyright (C) 2025-2026 Createch
 * @license Apache License 2.0
 */

#include "midi_sysex.h"
#include "tusb.h"
#include "pico/stdlib.h"
#include <string.h>
#include <stdio.h>

// SysEx receive state machine
typedef enum {
    SYSEX_STATE_IDLE,
    SYSEX_STATE_MANUFACTURER,
    SYSEX_STATE_DEVICE,
    SYSEX_STATE_COMMAND,
    SYSEX_STATE_DATA,
} sysex_state_t;

static sysex_state_t g_rx_state = SYSEX_STATE_IDLE;
static sysex_message_t g_rx_message;
static bool g_message_ready = false;
static uint64_t g_sysex_start_us = 0;  // SysEx receive timeout tracking
#define SYSEX_RECEIVE_TIMEOUT_US  500000  // 500ms timeout for SysEx assembly

void midi_sysex_init(void) {
    g_rx_state = SYSEX_STATE_IDLE;
    g_message_ready = false;
    memset(&g_rx_message, 0, sizeof(g_rx_message));
    g_rx_message.overflow = false;
}

bool midi_sysex_receive_byte(uint8_t byte) {
    // Real-time messages can appear anywhere, ignore them
    if (byte >= 0xF8) {
        return false;
    }
    
    // Timeout any in-progress SysEx assembly (all states except IDLE)
    if (g_rx_state != SYSEX_STATE_IDLE &&
        time_us_64() - g_sysex_start_us > SYSEX_RECEIVE_TIMEOUT_US) {
        g_rx_state = SYSEX_STATE_IDLE;
        g_rx_message.data_len = 0;
        g_rx_message.overflow = false;
    }
    
    // Any status byte (except real-time) resets SysEx
    if (byte >= 0x80 && byte != SYSEX_START && byte != SYSEX_END) {
        g_rx_state = SYSEX_STATE_IDLE;
        return false;
    }
    
    switch (g_rx_state) {
        case SYSEX_STATE_IDLE:
            if (byte == SYSEX_START) {
                g_rx_state = SYSEX_STATE_MANUFACTURER;
                g_message_ready = false;
                g_rx_message.data_len = 0;
                g_rx_message.overflow = false;
                g_sysex_start_us = time_us_64();
            }
            break;
            
        case SYSEX_STATE_MANUFACTURER:
            if (byte == SYSEX_MANUFACTURER_ID) {
                g_rx_state = SYSEX_STATE_DEVICE;
            } else {
                g_rx_state = SYSEX_STATE_IDLE;  // Not our message
            }
            break;
            
        case SYSEX_STATE_DEVICE:
            if (byte == SYSEX_DEVICE_ID) {
                g_rx_state = SYSEX_STATE_COMMAND;
            } else {
                g_rx_state = SYSEX_STATE_IDLE;  // Not our device
            }
            break;
            
        case SYSEX_STATE_COMMAND:
            g_rx_message.command = byte;
            g_rx_state = SYSEX_STATE_DATA;
            break;
            
        case SYSEX_STATE_DATA:
            // Check receive timeout
            if (time_us_64() - g_sysex_start_us > SYSEX_RECEIVE_TIMEOUT_US) {
                g_rx_state = SYSEX_STATE_IDLE;
                g_rx_message.data_len = 0;
                return false;
            }
            if (byte == SYSEX_END) {
                // Discard entire message if buffer overflowed
                if (g_rx_message.overflow) {
                    g_rx_state = SYSEX_STATE_IDLE;
                    g_rx_message.data_len = 0;
                    g_rx_message.overflow = false;
                    return false;
                }
                g_message_ready = true;
                g_rx_state = SYSEX_STATE_IDLE;
                return true;
            } else if (g_rx_message.data_len < sizeof(g_rx_message.data)) {
                g_rx_message.data[g_rx_message.data_len++] = byte;
            } else {
                // Buffer full: set overflow flag, discard on SYSEX_END
                g_rx_message.overflow = true;
            }
            break;
    }
    
    return false;
}

sysex_message_t* midi_sysex_get_message(void) {
    if (g_message_ready) {
        g_message_ready = false;
        return &g_rx_message;
    }
    return NULL;
}

// Send raw SysEx — single-threaded (Core 0 only), no lock needed.
// Retries aggressively to avoid silent data loss.
static void midi_sysex_send_raw(uint8_t command, const uint8_t* data, uint16_t len) {
    if (!tud_midi_mounted()) return;

    uint8_t buffer[SYSEX_MAX_SIZE];
    uint16_t idx = 0;

    buffer[idx++] = SYSEX_START;
    buffer[idx++] = SYSEX_MANUFACTURER_ID;
    buffer[idx++] = SYSEX_DEVICE_ID;
    buffer[idx++] = command;

    for (uint16_t i = 0; i < len && idx < SYSEX_MAX_SIZE - 1; i++) {
        buffer[idx++] = data[i] & 0x7F;  // Mask to 7-bit (MIDI spec compliance)
    }

    buffer[idx++] = SYSEX_END;

    // Send with generous retry to survive transient USB host delays.
    // USB Full-Speed bulk transfers can stall for several ms during
    // host-side scheduling.  200 × 100us = 20ms max wait — enough to
    // span multiple USB frames (1ms each) without dropping data.
    uint16_t sent = 0;
    int retry_count = 0;
    while (sent < idx && retry_count < 200) {
        uint32_t written = tud_midi_stream_write(0, buffer + sent, idx - sent);
        if (written > 0) {
            sent += written;
            retry_count = 0;  // Reset on progress
        } else {
            tud_task();       // Process USB to free buffer space
            sleep_us(100);    // Wait ~1/10 USB frame for host to poll
            retry_count++;
        }
    }

    // Flush: ensure data reaches the USB endpoint
    tud_task();
}

void midi_sysex_send_pressure(int32_t pressure_mhpa) {
    // Encode as 5 bytes of 7-bit data (35 bits, enough for int32)
    // Big-endian, 7 bits per byte
    // Use absolute value + sign bit for proper encoding
    uint8_t data[5];
    bool negative = (pressure_mhpa < 0);
    uint32_t val = negative ? (~(uint32_t)pressure_mhpa + 1u) : (uint32_t)pressure_mhpa;
    
    data[0] = (val >> 28) & 0x0F;  // Top 4 bits
    if (negative) {
        data[0] |= 0x40;  // Sign bit in bit 6
    }
    data[1] = (val >> 21) & 0x7F;
    data[2] = (val >> 14) & 0x7F;
    data[3] = (val >> 7) & 0x7F;
    data[4] = val & 0x7F;
    
    midi_sysex_send_raw(CMD_PRESSURE, data, 5);
}

void midi_sysex_send_device_info(const char* serial, const char* name, 
                                  const char* fw_version, bool sensor_ok) {
    uint8_t data[96];
    uint8_t idx = 0;
    
    // Format: [serial_len][serial...][name_len][name...][fw_len][fw...][sensor_ok]
    
    // Serial (max 24 chars)
    uint8_t serial_len = strlen(serial);
    if (serial_len > 24) serial_len = 24;
    if (idx + 1 + serial_len > sizeof(data)) return;
    data[idx++] = serial_len;
    memcpy(&data[idx], serial, serial_len);
    idx += serial_len;
    
    // Name (max 24 chars)
    uint8_t name_len = strlen(name);
    if (name_len > 24) name_len = 24;
    if (idx + 1 + name_len > sizeof(data)) return;
    data[idx++] = name_len;
    memcpy(&data[idx], name, name_len);
    idx += name_len;
    
    // Firmware version (max 16 chars)
    uint8_t fw_len = strlen(fw_version);
    if (fw_len > 16) fw_len = 16;
    if (idx + 1 + fw_len + 1 > sizeof(data)) return;  // +1 for sensor_ok
    data[idx++] = fw_len;
    memcpy(&data[idx], fw_version, fw_len);
    idx += fw_len;
    
    // Sensor status
    data[idx++] = sensor_ok ? 0x01 : 0x00;
    
    midi_sysex_send_raw(CMD_DEVICE_INFO, data, idx);
}

void midi_sysex_send_config(uint8_t output_rate) {
    uint8_t data[1] = { output_rate };
    midi_sysex_send_raw(CMD_CONFIG, data, 1);
}

void midi_sysex_send_auth_response(const uint8_t* signature, uint8_t sig_len) {
    // Encode signature bytes to 7-bit (each byte becomes 2 nibbles)
    // ECDSA P-256 DER signature can be up to 72 bytes -> 144 nibbles
    uint8_t encoded[160];  // Extra margin for safety
    uint16_t idx = 0;
    
    for (uint8_t i = 0; i < sig_len && idx < sizeof(encoded) - 2; i++) {
        encoded[idx++] = (signature[i] >> 4) & 0x0F;  // High nibble
        encoded[idx++] = signature[i] & 0x0F;         // Low nibble
    }
    
    // midi_sysex_send_raw already handles locking and flushing
    midi_sysex_send_raw(CMD_AUTH_RESPONSE, encoded, idx);
}

void midi_sysex_send_overrange_alert(void) {
    midi_sysex_send_raw(CMD_OVERRANGE_ALERT, NULL, 0);
}

void midi_sysex_send_pong(void) {
    midi_sysex_send_raw(CMD_PONG, NULL, 0);
}

void midi_sysex_send_full_config(uint8_t output_rate, uint8_t led_brightness,
                                  uint8_t noise_floor, uint8_t oversampling,
                                  uint8_t iir_filter) {
    uint8_t data[5] = { output_rate, led_brightness, noise_floor, oversampling, iir_filter };
    midi_sysex_send_raw(CMD_FULL_CONFIG, data, 5);
}

void midi_sysex_send_temperature(int16_t temp_x100) {
    // 7-bit encode: sign byte + 2 data bytes
    uint8_t data[3];
    uint16_t abs_val;
    if (temp_x100 < 0) {
        data[0] = 0x01;  // negative
        abs_val = (uint16_t)(-temp_x100);
    } else {
        data[0] = 0x00;  // positive
        abs_val = (uint16_t)temp_x100;
    }
    data[1] = (abs_val >> 7) & 0x7F;
    data[2] = abs_val & 0x7F;
    midi_sysex_send_raw(CMD_TEMPERATURE, data, 3);
}

void midi_sysex_send_diagnostics(uint32_t uptime_sec, uint16_t sensor_errors,
                                  uint16_t overrange_count, uint16_t i2c_recovery_count,
                                  int16_t cpu_temp_x100) {
    // Pack into 7-bit safe bytes
    uint8_t data[16];
    uint8_t idx = 0;
    
    // Uptime: 5 bytes (32-bit, 7-bit encoded)
    data[idx++] = (uptime_sec >> 28) & 0x0F;
    data[idx++] = (uptime_sec >> 21) & 0x7F;
    data[idx++] = (uptime_sec >> 14) & 0x7F;
    data[idx++] = (uptime_sec >> 7) & 0x7F;
    data[idx++] = uptime_sec & 0x7F;
    
    // Sensor errors: 2 bytes (14-bit)
    data[idx++] = (sensor_errors >> 7) & 0x7F;
    data[idx++] = sensor_errors & 0x7F;
    
    // Over-range count: 2 bytes (14-bit)
    data[idx++] = (overrange_count >> 7) & 0x7F;
    data[idx++] = overrange_count & 0x7F;
    
    // I2C recovery count: 2 bytes (14-bit)
    data[idx++] = (i2c_recovery_count >> 7) & 0x7F;
    data[idx++] = i2c_recovery_count & 0x7F;
    
    // CPU temp x100: sign + 2 bytes (14-bit)
    uint16_t abs_temp;
    if (cpu_temp_x100 < 0) {
        data[idx++] = 0x01;
        abs_temp = (uint16_t)(-cpu_temp_x100);
    } else {
        data[idx++] = 0x00;
        abs_temp = (uint16_t)cpu_temp_x100;
    }
    data[idx++] = (abs_temp >> 7) & 0x7F;
    data[idx++] = abs_temp & 0x7F;
    
    midi_sysex_send_raw(CMD_DIAGNOSTICS, data, idx);
}

void midi_sysex_send_ack(uint8_t cmd_id, uint8_t status) {
    uint8_t data[2] = { cmd_id & 0x7F, status & 0x7F };
    midi_sysex_send_raw(CMD_ACK, data, 2);
}

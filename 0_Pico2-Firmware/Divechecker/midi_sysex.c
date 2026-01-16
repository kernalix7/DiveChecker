/**
 * @file midi_sysex.c
 * @brief MIDI SysEx Protocol Implementation for DiveChecker
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

void midi_sysex_init(void) {
    g_rx_state = SYSEX_STATE_IDLE;
    g_message_ready = false;
    memset(&g_rx_message, 0, sizeof(g_rx_message));
}

bool midi_sysex_receive_byte(uint8_t byte) {
    // Real-time messages can appear anywhere, ignore them
    if (byte >= 0xF8) {
        return false;
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
            if (byte == SYSEX_END) {
                g_message_ready = true;
                g_rx_state = SYSEX_STATE_IDLE;
                return true;
            } else if (g_rx_message.data_len < sizeof(g_rx_message.data)) {
                g_rx_message.data[g_rx_message.data_len++] = byte;
            }
            // If buffer full, keep receiving but discard extra data
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

void midi_sysex_send(uint8_t command, const uint8_t* data, uint8_t len) {
    uint8_t buffer[SYSEX_MAX_SIZE];
    uint8_t idx = 0;
    
    buffer[idx++] = SYSEX_START;
    buffer[idx++] = SYSEX_MANUFACTURER_ID;
    buffer[idx++] = SYSEX_DEVICE_ID;
    buffer[idx++] = command;
    
    // Copy data, ensuring no bytes >= 0x80 (MIDI data bytes are 7-bit)
    for (uint8_t i = 0; i < len && idx < SYSEX_MAX_SIZE - 1; i++) {
        // For binary data, we need to encode bytes >= 0x80
        // Use simple encoding: split into two 7-bit values if needed
        buffer[idx++] = data[i] & 0x7F;
        if (data[i] & 0x80) {
            // High bit was set, send an extra byte
            if (idx < SYSEX_MAX_SIZE - 1) {
                buffer[idx++] = 0x01;  // Flag: previous byte had high bit
            }
        }
    }
    
    buffer[idx++] = SYSEX_END;
    
    // Send via TinyUSB MIDI
    tud_midi_stream_write(0, buffer, idx);
}

// SysEx send lock to prevent interleaving
static volatile bool g_sysex_sending = false;

// Wait for USB send to complete and release lock
static void midi_sysex_flush_and_unlock(void) {
    // Wait for USB buffer to flush
    for (int i = 0; i < 100; i++) {
        tud_task();
        sleep_us(100);
    }
    g_sysex_sending = false;
}

// Acquire send lock (blocking)
static void midi_sysex_lock(void) {
    while (g_sysex_sending) {
        tud_task();
        sleep_us(50);
    }
    g_sysex_sending = true;
}

// Send raw SysEx with retry for full transmission
static void midi_sysex_send_raw(uint8_t command, const uint8_t* data, uint16_t len) {
    midi_sysex_lock();
    
    uint8_t buffer[SYSEX_MAX_SIZE];
    uint16_t idx = 0;
    
    buffer[idx++] = SYSEX_START;
    buffer[idx++] = SYSEX_MANUFACTURER_ID;
    buffer[idx++] = SYSEX_DEVICE_ID;
    buffer[idx++] = command;
    
    for (uint16_t i = 0; i < len && idx < SYSEX_MAX_SIZE - 1; i++) {
        buffer[idx++] = data[i];
    }
    
    buffer[idx++] = SYSEX_END;
    
    // Send with retry to handle buffer full conditions
    uint16_t sent = 0;
    int retry_count = 0;
    while (sent < idx && retry_count < 1000) {
        uint32_t written = tud_midi_stream_write(0, buffer + sent, idx - sent);
        if (written > 0) {
            sent += written;
            retry_count = 0;  // Reset retry on successful write
        } else {
            // Buffer full, process USB and retry
            tud_task();
            sleep_us(100);
            retry_count++;
        }
    }
    
    midi_sysex_flush_and_unlock();
}

void midi_sysex_send_pressure(int32_t pressure_mpa) {
    // Encode as 5 bytes of 7-bit data (35 bits, enough for int32)
    // Big-endian, 7 bits per byte
    // Use absolute value + sign bit for proper encoding
    uint8_t data[5];
    bool negative = pressure_mpa < 0;
    uint32_t val = negative ? (uint32_t)(-pressure_mpa) : (uint32_t)pressure_mpa;
    
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
    data[idx++] = serial_len;
    memcpy(&data[idx], serial, serial_len);
    idx += serial_len;
    
    // Name (max 24 chars)
    uint8_t name_len = strlen(name);
    if (name_len > 24) name_len = 24;
    data[idx++] = name_len;
    memcpy(&data[idx], name, name_len);
    idx += name_len;
    
    // Firmware version (max 16 chars)
    uint8_t fw_len = strlen(fw_version);
    if (fw_len > 16) fw_len = 16;
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

void midi_sysex_send_sensor_status(bool connected) {
    uint8_t data[1] = { connected ? 0x01 : 0x00 };
    midi_sysex_send_raw(CMD_SENSOR_STATUS, data, 1);
}

void midi_sysex_send_pong(void) {
    midi_sysex_send_raw(CMD_PONG, NULL, 0);
}

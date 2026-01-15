/**
 * OTP Key Management for DiveChecker
 * 
 * RP2350 OTP Memory Layout for DiveChecker:
 * - OTP is 8KB (8192 bytes) organized as 4096 x 16-bit words
 * - Once written, cannot be changed (One-Time Programmable)
 * 
 * Key Storage Strategy:
 * - Development: Keys in flash (ecdsa_private_keys.h)
 * - Production: Keys in OTP with read protection
 * 
 * OTP Row Allocation (custom, after system reserved):
 * - Row 0x700-0x70F (16 rows): ECDSA Private Key (32 bytes)
 * - Row 0x710-0x730 (33 rows): ECDSA Public Key (65 bytes)
 * - Row 0x740: Key programmed flag (0xDC01 = programmed)
 * 
 * ⚠️ WARNING: OTP write is PERMANENT and IRREVERSIBLE!
 */

#ifndef OTP_KEYS_H
#define OTP_KEYS_H

#include <stdint.h>
#include <stdbool.h>
#include "pico/stdlib.h"

// RP2350 OTP configuration
#if PICO_RP2350
    #define HAS_OTP 1
    // OTP_DATA_BASE is defined in RP2350 hardware headers
    // Address: 0x40130000
    #ifndef OTP_DATA_BASE
        #define OTP_DATA_BASE 0x40130000
    #endif
#else
    #define HAS_OTP 0
#endif

// OTP Row allocation for DiveChecker keys
// RP2350 OTP: Rows 0x000-0xFFF, user area starts at 0x700
#define OTP_KEY_BASE_ROW        0x700   // Start of key storage
#define OTP_PRIVATE_KEY_ROW     0x700   // 16 rows for 32 bytes (2 bytes per row)
#define OTP_PUBLIC_KEY_ROW      0x710   // 33 rows for 65 bytes  
#define OTP_KEY_FLAG_ROW        0x740   // Flag to indicate keys are programmed

// Magic value to indicate keys are programmed
#define OTP_KEY_PROGRAMMED_MAGIC    0xDC01  // "DC" for DiveChecker

#if defined(USE_OTP_KEYS) && HAS_OTP

/**
 * @brief Read a single OTP row (16-bit value)
 * @param row Row number (0x000-0xFFF)
 * @return 16-bit value from OTP
 * 
 * RP2350 OTP Memory:
 * - Total 8KB (4096 x 24-bit words, but we use lower 16 bits)
 * - OTP_DATA_BASE: 0x40130000 (read interface)
 * - Each row is 32-bit aligned (4 bytes), lower 16 bits are data
 * 
 * IMPORTANT: Row indexing must match picotool
 * - picotool otp set 0x700 0xABCD  -> OTP row 0x700
 * - Read: otp_data[0x700] & 0xFFFF = 0xABCD
 */
static inline uint16_t otp_read_row(uint16_t row) {
    // RP2350 OTP: each row at OTP_DATA_BASE + row*4 (32-bit aligned)
    volatile uint32_t *otp_data = (volatile uint32_t *)(OTP_DATA_BASE);
    return (uint16_t)(otp_data[row] & 0xFFFF);
}

/**
 * @brief Check if OTP keys are programmed
 * @return true if keys exist in OTP
 */
static inline bool otp_keys_programmed(void) {
    uint16_t flag = otp_read_row(OTP_KEY_FLAG_ROW);
    return (flag == OTP_KEY_PROGRAMMED_MAGIC);
}

/**
 * @brief Read ECDSA private key from OTP
 * @param key_out Buffer to receive 32-byte private key
 * @return true if successful
 */
static inline bool otp_read_private_key(uint8_t key_out[32]) {
    if (!otp_keys_programmed()) {
        return false;
    }
    
    // Read 32 bytes (16 x 16-bit words)
    // Each word stores 2 bytes: high byte first, low byte second
    for (int i = 0; i < 16; i++) {
        uint16_t word = otp_read_row(OTP_PRIVATE_KEY_ROW + i);
        key_out[i * 2] = (word >> 8) & 0xFF;
        key_out[i * 2 + 1] = word & 0xFF;
    }
    
    return true;
}

/**
 * @brief Read ECDSA public key from OTP
 * @param key_out Buffer to receive 65-byte public key
 * @return true if successful
 */
static inline bool otp_read_public_key(uint8_t key_out[65]) {
    if (!otp_keys_programmed()) {
        return false;
    }
    
    // Read 65 bytes (33 x 16-bit words, last word only uses high byte)
    for (int i = 0; i < 33; i++) {
        uint16_t word = otp_read_row(OTP_PUBLIC_KEY_ROW + i);
        key_out[i * 2] = (word >> 8) & 0xFF;
        if (i * 2 + 1 < 65) {
            key_out[i * 2 + 1] = word & 0xFF;
        }
    }
    
    return true;
}

/**
 * @brief Initialize keys from OTP
 * @param priv_key Buffer for 32-byte private key
 * @param pub_key Buffer for 65-byte public key
 * @return true if keys loaded successfully
 */
static inline bool otp_init_keys(uint8_t priv_key[32], uint8_t pub_key[65]) {
    if (!otp_read_private_key(priv_key)) {
        return false;
    }
    if (!otp_read_public_key(pub_key)) {
        return false;
    }
    return true;
}

#else // !USE_OTP_KEYS || !HAS_OTP

// Stub functions when OTP not used
static inline bool otp_keys_programmed(void) { return false; }
static inline bool otp_init_keys(uint8_t priv_key[32], uint8_t pub_key[65]) { 
    (void)priv_key; (void)pub_key;
    return false; 
}

#endif // USE_OTP_KEYS && HAS_OTP

#endif // OTP_KEYS_H

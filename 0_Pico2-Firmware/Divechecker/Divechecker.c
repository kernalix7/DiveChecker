/**
 * @file Divechecker.c
 * @brief DiveChecker RP2350 (Pico 2) Firmware v6.0.0
 * 
 * @details
 * Dual-core architecture for high-precision pressure monitoring:
 *   - Core 0: USB MIDI communication, command processing
 *   - Core 1: 160Hz BMP280 sensor sampling
 * 
 * Features:
 *   - USB MIDI SysEx protocol for cross-platform support
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
#include "pico/multicore.h"
#include "pico/util/queue.h"
#include "pico/unique_id.h"
#include "pico/bootrom.h"  // For BOOTSEL reboot

#include "hardware/i2c.h"
#include "hardware/gpio.h"
#include "hardware/pio.h"
#include "hardware/flash.h"
#include "hardware/sync.h"
#include "hardware/watchdog.h"
#include "hardware/clocks.h"
#include "pico/mutex.h"

// TinyUSB for USB MIDI
#include "tusb.h"
#include "midi_sysex.h"

// mbedtls for ECDSA authentication
#include "mbedtls/ecdsa.h"
#include "mbedtls/sha256.h"
#include "mbedtls/ctr_drbg.h"
#include "mbedtls/ecp.h"

#include "pico/rand.h"
#include <stdlib.h>  // for strtol
#include <math.h>    // for isnan, NAN

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
#define FW_VERSION_MAJOR    6
#define FW_VERSION_MINOR    0
#define FW_VERSION_PATCH    0
#define FW_VERSION_STRING   "6.0.0"

// I2C Configuration
#define I2C_PORT            i2c0
#define I2C_SDA_PIN         8
#define I2C_SCL_PIN         9
#define I2C_BAUDRATE        400000      // 400kHz (BMP280 max spec)

// BMP280 Sensor
#define BMP280_I2C_ADDR     0x76
#define BMP280_CHIP_ID      0x58
#define BME280_CHIP_ID      0x60

// Sampling Configuration
#define INTERNAL_SAMPLE_RATE_HZ  100     // Fixed internal sampling rate
#define DEFAULT_OUTPUT_RATE_HZ   8       // Default output rate
#define MIN_OUTPUT_RATE_HZ       4       // Minimum (most stable)
#define MAX_OUTPUT_RATE_HZ       50      // Maximum (less averaging)
#define MAX_SAMPLES_PER_OUTPUT   (INTERNAL_SAMPLE_RATE_HZ / MIN_OUTPUT_RATE_HZ)  // 25 max
#define SAMPLE_INTERVAL_US       (1000000 / INTERNAL_SAMPLE_RATE_HZ)  // 10ms

// Connection Timeout
#define CONNECTION_TIMEOUT_MS   10000

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
 * @note CRC32 at end covers bytes 0..(size-5), using polynomial 0xEDB88320
 */
typedef struct __attribute__((packed)) {
    uint32_t magic;
    char pin[DEVICE_PIN_LEN + 1];
    char name[DEVICE_NAME_MAX_LEN + 1];
    // Runtime-configurable parameters (persisted across reboots)
    uint8_t led_brightness;      // 0-100
    uint8_t noise_floor;         // 0-50
    uint8_t oversampling_ctrl;   // 0-5
    uint8_t iir_config;          // 0-4
    uint8_t output_rate;         // 4-50 Hz
    uint8_t pin_fail_count;      // Persisted PIN failure count
    uint8_t _config_reserved[2]; // Future use
    uint8_t _reserved[FLASH_PAGE_SIZE - sizeof(uint32_t) - (DEVICE_PIN_LEN + 1) - (DEVICE_NAME_MAX_LEN + 1) - 8 - sizeof(uint32_t)];
    uint32_t crc32;              // CRC32 of bytes 0..(size-5)
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

// BMP280 valid measurement range (extended beyond datasheet 300-1100 hPa spec)
#define BMP280_PRESSURE_MIN_HPA     300.0f
#define BMP280_PRESSURE_MAX_HPA     1250.0f

// Over-range recovery: discard initial samples after sensor reset
// to let IIR filter stabilize with clean values
#define OVERRANGE_RECOVERY_SAMPLES  30   // ~300ms at 100Hz
#define OVERRANGE_CONSEC_THRESHOLD  10   // consecutive bad readings before reset

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
static bool g_led_initialized = false;

// Over-range alert flag (set by Core 1, consumed by Core 0)
static volatile bool g_overrange_alert = false;

// I2C grace period after multicore lockout (flash save).
// Core 1's I2C transaction may be interrupted by lockout, causing transient
// NaN readings on resume. These should not count toward over-range detection.
static volatile uint8_t g_lockout_grace = 0;
#define LOCKOUT_GRACE_SAMPLES  5  // ~50ms at 100Hz internal rate

// Runtime-configurable parameters (via SysEx) — Core 0 only
static uint8_t g_led_brightness = LED_BRIGHTNESS;    // 0-100
static volatile uint8_t g_noise_floor = 1;           // x1000 threshold (Core 1 reads)
static uint8_t g_oversampling_ctrl = 5;              // 0=skip,1=x1,2=x2,3=x4,4=x8,5=x16
static uint8_t g_iir_config = 1;                     // 0=off,1=x2,2=x4,3=x8,4=x16

// Diagnostics counters (saturating increment helper)
static inline void sat_inc_u16(volatile uint16_t *val) {
    if (*val < UINT16_MAX) (*val)++;
}

/// CRC32 (polynomial 0xEDB88320, same as zlib/PNG)
static uint32_t crc32_compute(const uint8_t *data, size_t len) {
    uint32_t crc = 0xFFFFFFFF;
    for (size_t i = 0; i < len; i++) {
        crc ^= data[i];
        for (int j = 0; j < 8; j++) {
            crc = (crc >> 1) ^ ((crc & 1) ? 0xEDB88320 : 0);
        }
    }
    return ~crc;
}

static volatile uint16_t g_sensor_error_count = 0;
static volatile uint16_t g_overrange_event_count = 0;
static volatile uint16_t g_i2c_recovery_count = 0;
static volatile int16_t g_last_temperature_x100 = 0;  // From BMP280 t_fine
static uint64_t g_boot_time_ms = 0;

// I2C cross-core protection (Core 0 commands + Core 1 sensor reads)
static mutex_t g_i2c_mutex;
static volatile bool g_sensor_reconfiguring = false;

static inline void set_sensor_reconfiguring(bool value) {
    g_sensor_reconfiguring = value;
    __dmb();  // Memory barrier for cross-core visibility
}

// PIN brute-force protection
static int g_pin_fail_count = 0;
static absolute_time_t g_pin_lockout_until;
#define PIN_MAX_FAILURES    5
#define PIN_LOCKOUT_MAX_SEC 60

// Flash write debounce: avoid excessive writes from rapid slider changes
static volatile bool g_settings_dirty = false;
static uint64_t g_settings_dirty_since_ms = 0;
#define FLASH_SAVE_DEBOUNCE_MS  3000  // Save 3s after last change

/// Mark settings as needing to be saved (debounced)
static void mark_settings_dirty(void) {
    g_settings_dirty = true;
    g_settings_dirty_since_ms = time_us_64() / 1000;
}

/* ============================================================================
 * WS2812 LED Functions
 * ========================================================================== */

static inline uint32_t rgb_to_grb(uint8_t r, uint8_t g, uint8_t b) {
    return ((uint32_t)g << 16) | ((uint32_t)r << 8) | (uint32_t)b;
}

static inline void led_set_color(uint8_t r, uint8_t g, uint8_t b) {
    if (!g_led_initialized) return;
    pio_sm_put_blocking(g_ws2812_pio, g_ws2812_sm, rgb_to_grb(r, g, b) << 8u);
}

static void led_init(void) {
    // Check PIO program space availability before adding
    if (!pio_can_add_program(g_ws2812_pio, &ws2812_program)) {
        // Try PIO1 as fallback
        g_ws2812_pio = pio1;
        if (!pio_can_add_program(g_ws2812_pio, &ws2812_program)) {
            // No PIO available — LED won't work but device continues
            return;
        }
    }
    int sm = pio_claim_unused_sm(g_ws2812_pio, false);
    if (sm < 0) return;  // No free state machine
    g_ws2812_sm = (uint)sm;
    uint offset = pio_add_program(g_ws2812_pio, &ws2812_program);
    ws2812_program_init(g_ws2812_pio, g_ws2812_sm, offset, WS2812_PIN, 800000, WS2812_IS_RGBW);
    
    // EMC: Reduce drive strength and slew rate for LED data pin
    gpio_set_drive_strength(WS2812_PIN, GPIO_DRIVE_STRENGTH_2MA);
    gpio_set_slew_rate(WS2812_PIN, GPIO_SLEW_RATE_SLOW);
    g_led_initialized = true;
}

static void led_set_state(led_state_t state) {
    uint8_t br = g_led_brightness;
    switch (state) {
        case LED_STATE_OFF:          led_set_color(0, 0, 0);                           break;
        case LED_STATE_BOOT:         led_set_color(br, 0, 0);                           break;
        case LED_STATE_USB_WAIT:     led_set_color(br * 60 / 100, br * 25 / 100, 0);    break;
        case LED_STATE_USB_READY:    led_set_color(0, 0, br);                           break;
        case LED_STATE_APP_CONNECTED:led_set_color(0, br, 0);                           break;
        default:                     led_set_color(0, 0, 0);                           break;
    }
}

// Forward declarations
static bool pin_is_valid_format(const char *pin);
static bool bmp280_apply_config(void);

// Wear leveling: use 16 slots within the 4KB sector (256 bytes each)
#define WEAR_LEVEL_SLOTS  (FLASH_SECTOR_SIZE / FLASH_PAGE_SIZE)  // 16
static int g_wear_slot = 0;  // Current active slot index

/* ============================================================================
 * Flash Storage Functions
 * ========================================================================== */

static const device_settings_t* flash_get_settings_ptr(void) {
    return (const device_settings_t*)(XIP_BASE + FLASH_SETTINGS_OFFSET);
}

/// Verify CRC32 of settings (legacy 0xFFFFFFFF accepted only if magic matches)
static bool flash_verify_crc(const device_settings_t *settings) {
    if (settings->crc32 == 0xFFFFFFFF) {
        return settings->magic == SETTINGS_MAGIC;
    }
    uint32_t computed = crc32_compute((const uint8_t*)settings, 
                                       sizeof(device_settings_t) - sizeof(uint32_t));
    return computed == settings->crc32;
}

/// Find the latest valid settings slot (wear leveling + CRC verification)
static int flash_find_active_slot(void) {
    const device_settings_t *base = flash_get_settings_ptr();
    // Scan all slots, find the last valid one (highest index)
    int active = -1;
    for (int i = 0; i < WEAR_LEVEL_SLOTS; i++) {
        if (base[i].magic == SETTINGS_MAGIC && flash_verify_crc(&base[i])) {
            active = i;
        }
    }
    return active;
}

/// Build settings struct from current global state (for flash storage)
static device_settings_t flash_build_settings(void) {
    device_settings_t s = { .magic = SETTINGS_MAGIC };
    strncpy(s.pin, g_device_pin, DEVICE_PIN_LEN);
    s.pin[DEVICE_PIN_LEN] = '\0';
    strncpy(s.name, g_device_name, DEVICE_NAME_MAX_LEN);
    s.name[DEVICE_NAME_MAX_LEN] = '\0';
    s.led_brightness = g_led_brightness;
    s.noise_floor = g_noise_floor;
    s.oversampling_ctrl = g_oversampling_ctrl;
    s.iir_config = g_iir_config;
    s.output_rate = g_output_rate;
    s.pin_fail_count = (g_pin_fail_count <= 20) ? g_pin_fail_count : 20;
    memset(s._config_reserved, 0xFF, sizeof(s._config_reserved));
    memset(s._reserved, 0xFF, sizeof(s._reserved));
    s.crc32 = crc32_compute((const uint8_t*)&s,
                             sizeof(device_settings_t) - sizeof(uint32_t));
    return s;
}

static void flash_load_settings(void) {
    int slot = flash_find_active_slot();
    g_wear_slot = (slot >= 0) ? slot : 0;
    
    if (slot >= 0) {
        const device_settings_t *settings = &flash_get_settings_ptr()[slot];
        strncpy(g_device_name, settings->name, DEVICE_NAME_MAX_LEN);
        g_device_name[DEVICE_NAME_MAX_LEN] = '\0';
        strncpy(g_device_pin, settings->pin, DEVICE_PIN_LEN);
        g_device_pin[DEVICE_PIN_LEN] = '\0';
        // Guard against corrupted PIN in flash
        if (!pin_is_valid_format(g_device_pin)) {
            strcpy(g_device_pin, "0000");
        }
        // Load runtime config (validate each field)
        g_led_brightness = (settings->led_brightness <= 100) ? settings->led_brightness : LED_BRIGHTNESS;
        g_noise_floor = (settings->noise_floor <= 50) ? settings->noise_floor : 1;
        g_oversampling_ctrl = (settings->oversampling_ctrl <= 5) ? settings->oversampling_ctrl : 5;
        g_iir_config = (settings->iir_config <= 4) ? settings->iir_config : 1;
        if (settings->output_rate >= MIN_OUTPUT_RATE_HZ && settings->output_rate <= MAX_OUTPUT_RATE_HZ) {
            g_output_rate = settings->output_rate;
            g_output_interval_ms = 1000 / g_output_rate;
            g_samples_per_output = INTERNAL_SAMPLE_RATE_HZ / g_output_rate;
        }
        // Restore PIN lockout state
        g_pin_fail_count = (settings->pin_fail_count <= 20) ? settings->pin_fail_count : 0;
        if (g_pin_fail_count >= PIN_MAX_FAILURES) {
            // Recalculate lockout time based on fail count
            int shift = g_pin_fail_count - PIN_MAX_FAILURES;
            if (shift > 6) shift = 6;
            int delay_sec = 1 << shift;
            if (delay_sec > PIN_LOCKOUT_MAX_SEC) delay_sec = PIN_LOCKOUT_MAX_SEC;
            g_pin_lockout_until = make_timeout_time_ms(delay_sec * 1000);
        }
    } else {
        strcpy(g_device_name, "DiveChecker");
        strcpy(g_device_pin, "0000");
    }
    
    // Boot-time sector compaction: if the next save would require a sector
    // erase (~100-400ms blocking both cores), do it NOW before Core 1 starts.
    // At this point no sensor data is flowing, so the erase cost is invisible.
    // This guarantees all runtime saves are write-only (~1ms, no data gaps).
    if (g_wear_slot == WEAR_LEVEL_SLOTS - 1) {
        device_settings_t compact = flash_build_settings();
        uint32_t irq = save_and_disable_interrupts();
        flash_range_erase(FLASH_SETTINGS_OFFSET, FLASH_SECTOR_SIZE);
        flash_range_program(FLASH_SETTINGS_OFFSET,
                            (const uint8_t*)&compact, FLASH_PAGE_SIZE);
        restore_interrupts(irq);
        g_wear_slot = 0;
    }
}

static void flash_save_settings(void) {
    device_settings_t new_settings = flash_build_settings();
    
    int next_slot = (g_wear_slot + 1) % WEAR_LEVEL_SLOTS;
    bool need_erase = (next_slot == 0);
    
    // Core 1 executes from flash (XIP) — must pause it during flash ops.
    // Thanks to boot-time compaction, need_erase is false for the first
    // 15 saves per boot cycle, keeping lockout to ~1ms (write-only).
    multicore_lockout_start_blocking();
    uint32_t irq_state = save_and_disable_interrupts();
    if (need_erase) {
        flash_range_erase(FLASH_SETTINGS_OFFSET, FLASH_SECTOR_SIZE);
    }
    flash_range_program(FLASH_SETTINGS_OFFSET + next_slot * FLASH_PAGE_SIZE,
                        (const uint8_t*)&new_settings, FLASH_PAGE_SIZE);
    restore_interrupts(irq_state);
    multicore_lockout_end_blocking();
    
    __dmb();  // Ensure Core 1 sees the grace counter before processing resumes
    g_lockout_grace = LOCKOUT_GRACE_SAMPLES;
    g_wear_slot = next_slot;
}

/* ============================================================================
 * Device Settings API
 * ========================================================================== */

static bool pin_verify(const char *pin) {
    // Constant-time comparison to prevent timing side-channel attacks
    volatile uint8_t result = 0;
    for (int i = 0; i < DEVICE_PIN_LEN; i++) {
        result |= pin[i] ^ g_device_pin[i];
    }
    return result == 0;
}

static bool pin_check_rate_limit(void) {
    if (g_pin_fail_count >= PIN_MAX_FAILURES) {
        if (!time_reached(g_pin_lockout_until)) {
            return false;  // Still locked out
        }
        // Lockout expired — don't reset count so escalation continues
    }
    return true;
}

static void pin_record_failure(void) {
    g_pin_fail_count++;
    if (g_pin_fail_count >= PIN_MAX_FAILURES) {
        int shift = g_pin_fail_count - PIN_MAX_FAILURES;
        if (shift > 6) shift = 6;  // Cap at 64 seconds
        int delay_sec = 1 << shift;
        if (delay_sec > PIN_LOCKOUT_MAX_SEC) delay_sec = PIN_LOCKOUT_MAX_SEC;
        g_pin_lockout_until = make_timeout_time_ms(delay_sec * 1000);
    }
    // Persist failure count to survive reboot (debounced via dirty flag)
    mark_settings_dirty();
}

static void pin_record_success(void) {
    if (g_pin_fail_count > 0) {
        g_pin_fail_count = 0;
        mark_settings_dirty();  // Clear persisted lockout
    }
}

static bool pin_is_valid_format(const char *pin) {
    for (int i = 0; i < DEVICE_PIN_LEN; i++) {
        if (pin[i] < '0' || pin[i] > '9') return false;
    }
    return true;
}

/**
 * @brief Sanitize device name by replacing control characters
 */
static void sanitize_device_name(char *name) {
    for (int i = 0; name[i] != '\0'; i++) {
        unsigned char c = (unsigned char)name[i];
        if (c < 0x20 || c == 0x7F) {
            name[i] = '_';  // Replace control chars and DEL
        }
    }
}

static void device_set_name(const char *name) {
    strncpy(g_device_name, name, DEVICE_NAME_MAX_LEN);
    g_device_name[DEVICE_NAME_MAX_LEN] = '\0';
    sanitize_device_name(g_device_name);
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
            #if CFG_TUD_CDC
            printf("WARN:OTP keys not programmed\n");
            #endif
            return false;
        }
        if (!otp_init_keys(ECDSA_PRIVATE_KEY, ECDSA_PUBLIC_KEY)) {
            #if CFG_TUD_CDC
            printf("ERR:Failed to load OTP keys\n");
            #endif
            return false;
        }
        g_otp_keys_loaded = true;
        #if CFG_TUD_CDC
        printf("INFO:Keys loaded from OTP\n");
        #endif
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
        #if CFG_TUD_CDC
        printf("WARN:ECDSA keys not configured\n");
        #endif
        return false;
    }
    
    // Clean up any previous partial init to prevent memory leaks
    mbedtls_ecdsa_free(&g_ecdsa_ctx);
    mbedtls_ctr_drbg_free(&g_ctr_drbg);
    
    // Initialize contexts
    mbedtls_ecdsa_init(&g_ecdsa_ctx);
    mbedtls_ctr_drbg_init(&g_ctr_drbg);
    
    // Seed DRBG with hardware RNG
    const char *pers = "divechecker_ecdsa";
    int ret = mbedtls_ctr_drbg_seed(&g_ctr_drbg, rp2350_entropy_func, NULL,
                                     (const unsigned char *)pers, strlen(pers));
    if (ret != 0) {
        #if CFG_TUD_CDC
        printf("ERR:DRBG seed failed: %d\n", ret);
        #endif
        return false;
    }
    
    // Load private key (mbedtls 3.x API - also sets up the curve)
    ret = mbedtls_ecp_read_key(MBEDTLS_ECP_DP_SECP256R1, &g_ecdsa_ctx,
                                ECDSA_PRIVATE_KEY, 32);
    if (ret != 0) {
        #if CFG_TUD_CDC
        printf("ERR:Private key load failed: %d\n", ret);
        #endif
        return false;
    }
    
    // Compute public key from private key (mbedtls 3.x API)
    ret = mbedtls_ecp_keypair_calc_public(&g_ecdsa_ctx,
                                           mbedtls_ctr_drbg_random, &g_ctr_drbg);
    if (ret != 0) {
        #if CFG_TUD_CDC
        printf("ERR:Public key compute failed: %d\n", ret);
        #endif
        return false;
    }
    
    g_ecdsa_initialized = true;
    
    // Zero the raw private key from RAM after loading into mbedtls context
    // Reduces exposure window for cold-boot attacks or debug probe extraction
#if defined(USE_OTP_KEYS)
    mbedtls_platform_zeroize(ECDSA_PRIVATE_KEY, sizeof(ECDSA_PRIVATE_KEY));
#endif
    
    return true;
}

/* ============================================================================
 * I2C Helper Functions (with timeout and bus recovery for EMC)
 * ========================================================================== */

// I2C timeout in microseconds (50ms should be plenty for 400kHz)
#define I2C_TIMEOUT_US      50000

/**
 * @brief Recover I2C bus from stuck state (SDA held low)
 * @details Generates clock pulses to release stuck slave devices
 */
static void i2c_bus_recover(void) {
    // Temporarily disable I2C function on pins
    gpio_set_function(I2C_SDA_PIN, GPIO_FUNC_SIO);
    gpio_set_function(I2C_SCL_PIN, GPIO_FUNC_SIO);
    
    gpio_set_dir(I2C_SDA_PIN, GPIO_IN);
    gpio_set_dir(I2C_SCL_PIN, GPIO_OUT);
    gpio_pull_up(I2C_SDA_PIN);
    
    // Generate 9 clock pulses to release any stuck slave
    for (int i = 0; i < 9; i++) {
        gpio_put(I2C_SCL_PIN, 0);
        sleep_us(5);
        gpio_put(I2C_SCL_PIN, 1);
        sleep_us(5);
        
        // Check if SDA is released
        if (gpio_get(I2C_SDA_PIN)) {
            break;
        }
    }
    
    // Generate STOP condition
    gpio_set_dir(I2C_SDA_PIN, GPIO_OUT);
    gpio_put(I2C_SDA_PIN, 0);
    sleep_us(5);
    gpio_put(I2C_SCL_PIN, 1);
    sleep_us(5);
    gpio_put(I2C_SDA_PIN, 1);
    sleep_us(5);
    
    // Restore I2C function
    gpio_set_function(I2C_SDA_PIN, GPIO_FUNC_I2C);
    gpio_set_function(I2C_SCL_PIN, GPIO_FUNC_I2C);
    gpio_pull_up(I2C_SDA_PIN);
    gpio_pull_up(I2C_SCL_PIN);
}

static bool i2c_write_register(uint8_t reg, uint8_t value) {
    mutex_enter_blocking(&g_i2c_mutex);
    uint8_t buf[2] = {reg, value};
    int ret = i2c_write_timeout_us(I2C_PORT, BMP280_I2C_ADDR, buf, 2, false, I2C_TIMEOUT_US);
    if (ret < 0) {
        i2c_bus_recover();
        sat_inc_u16(&g_i2c_recovery_count);
        mutex_exit(&g_i2c_mutex);
        return false;
    }
    mutex_exit(&g_i2c_mutex);
    return true;
}

static bool i2c_read_registers(uint8_t start_reg, uint8_t *buffer, size_t len) {
    mutex_enter_blocking(&g_i2c_mutex);
    int ret = i2c_write_timeout_us(I2C_PORT, BMP280_I2C_ADDR, &start_reg, 1, true, I2C_TIMEOUT_US);
    if (ret < 0) {
        i2c_bus_recover();
        sat_inc_u16(&g_i2c_recovery_count);
        mutex_exit(&g_i2c_mutex);
        return false;
    }
    ret = i2c_read_timeout_us(I2C_PORT, BMP280_I2C_ADDR, buffer, len, false, I2C_TIMEOUT_US);
    if (ret < 0) {
        i2c_bus_recover();
        sat_inc_u16(&g_i2c_recovery_count);
        mutex_exit(&g_i2c_mutex);
        return false;
    }
    mutex_exit(&g_i2c_mutex);
    return true;
}

/* ============================================================================
 * BMP280 Sensor Functions
 * ========================================================================== */

static bool bmp280_init(void) {
    uint8_t chip_id;
    if (!i2c_read_registers(BMP280_REG_ID, &chip_id, 1)) {
        #if CFG_TUD_CDC
        printf("ERR:I2C read chip ID failed\n");
        #endif
        return false;
    }
    
    #if CFG_TUD_CDC
    printf("INFO:ChipID=0x%02X", chip_id);
    if (chip_id == BMP280_CHIP_ID) {
        printf(" (BMP280)\n");
    } else if (chip_id == BME280_CHIP_ID) {
        printf(" (BME280)\n");
    } else {
        printf(" (Unknown)\n");
    }
    #endif
    if (chip_id != BMP280_CHIP_ID && chip_id != BME280_CHIP_ID) {
        return false;
    }
    
    // Soft reset
    if (!i2c_write_register(BMP280_REG_RESET, BMP280_RESET_VALUE)) {
        return false;
    }
    sleep_ms(10);
    
    // Read calibration data
    uint8_t calib_raw[BMP280_CALIB_LEN];
    if (!i2c_read_registers(BMP280_REG_CALIB_START, calib_raw, BMP280_CALIB_LEN)) {
        #if CFG_TUD_CDC
        printf("ERR:Failed to read calibration data\n");
        #endif
        return false;
    }
    
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
    if (!i2c_write_register(BMP280_REG_CTRL_MEAS, 0x00)) return false;
    sleep_ms(5);
    
    // Step 2: Write config register (IIR filter) while in sleep mode
    if (!i2c_write_register(BMP280_REG_CONFIG, BMP280_CONFIG_FILTERED)) return false;
    sleep_ms(5);
    
    // Step 3: Write ctrl_meas to enable measurements and start normal mode
    // Stable: osrs_t=001 (x1), osrs_p=101 (x16), mode=11 (normal) = 0x57
    if (!i2c_write_register(BMP280_REG_CTRL_MEAS, BMP280_CTRL_STABLE)) return false;
    sleep_ms(50);  // Wait for first measurement
    
    // Verify registers were written correctly
    uint8_t ctrl_meas_read = 0, config_read = 0;
    i2c_read_registers(BMP280_REG_CTRL_MEAS, &ctrl_meas_read, 1);
    i2c_read_registers(BMP280_REG_CONFIG, &config_read, 1);
    #if CFG_TUD_CDC
    printf("INFO:CTRL_MEAS=0x%02X CONFIG=0x%02X (X16+IIR2)\n", ctrl_meas_read, config_read);
    #endif
    
    return true;
}

/**
 * @brief Reinitialize BMP280 config (clears IIR filter state)
 * @details Called after over-range recovery to flush saturated values
 *          from the sensor's internal IIR filter
 */
static bool bmp280_reinit_config(void) {
    // Prevent concurrent reconfiguration from both cores
    if (g_sensor_reconfiguring) return false;
    set_sensor_reconfiguring(true);  // Signal Core 1 to skip reads
    
    // Soft reset clears all internal registers including IIR filter
    if (!i2c_write_register(BMP280_REG_RESET, BMP280_RESET_VALUE)) {
        set_sensor_reconfiguring(false);
        return false;
    }
    sleep_ms(10);
    
    // Re-apply configuration (must be done in sleep mode)
    if (!i2c_write_register(BMP280_REG_CTRL_MEAS, 0x00)) {
        set_sensor_reconfiguring(false);
        return false;
    }
    sleep_ms(2);
    if (!i2c_write_register(BMP280_REG_CONFIG, BMP280_CONFIG_FILTERED)) {
        set_sensor_reconfiguring(false);
        return false;
    }
    sleep_ms(2);
    if (!i2c_write_register(BMP280_REG_CTRL_MEAS, BMP280_CTRL_STABLE)) {
        set_sensor_reconfiguring(false);
        return false;
    }
    sleep_ms(50);  // Wait for first clean measurement
    
    set_sensor_reconfiguring(false);
    
    // Re-apply user-configured oversampling and IIR settings
    return bmp280_apply_config();
}

/**
 * @brief Apply dynamic BMP280 configuration (oversampling + IIR filter)
 * @details Uses g_oversampling_ctrl and g_iir_config global variables
 *          Must put sensor in sleep mode before changing config registers
 */
static bool bmp280_apply_config(void) {
    set_sensor_reconfiguring(true);  // Signal Core 1 to skip reads
    
    uint8_t osrs = g_oversampling_ctrl;
    uint8_t iir = g_iir_config;
    if (osrs > 5) osrs = 5;
    if (iir > 4) iir = 4;
    
    // ctrl_meas: osrs_t[7:5]=x2(0b010), osrs_p[4:2]=variable, mode[1:0]=normal(0b11)
    uint8_t ctrl_meas = (0x02 << 5) | (osrs << 2) | 0x03;
    // config: t_sb[7:5]=0.5ms(0b000), filter[4:2]=variable, spi3w_en=0
    uint8_t config_reg = (iir << 2);
    
    // Enter sleep mode first
    if (!i2c_write_register(BMP280_REG_CTRL_MEAS, 0x00)) {
        set_sensor_reconfiguring(false);
        return false;
    }
    sleep_ms(2);
    
    // Apply config (only writable in sleep mode)
    if (!i2c_write_register(BMP280_REG_CONFIG, config_reg)) {
        set_sensor_reconfiguring(false);
        return false;
    }
    sleep_ms(2);
    
    // Back to normal mode with new oversampling
    if (!i2c_write_register(BMP280_REG_CTRL_MEAS, ctrl_meas)) {
        set_sensor_reconfiguring(false);
        return false;
    }
    sleep_ms(50);  // Wait for first measurement with new config
    
    set_sensor_reconfiguring(false);
    return true;
}

static float bmp280_read_pressure(void) {
    uint8_t data[6] = {0};
    if (!i2c_read_registers(BMP280_REG_PRESS_MSB, data, 6)) {
        return NAN;  // I2C read failed - signal invalid reading
    }
    
    // Parse 20-bit ADC values
    int32_t adc_P = ((int32_t)data[0] << 12) | ((int32_t)data[1] << 4) | (data[2] >> 4);
    int32_t adc_T = ((int32_t)data[3] << 12) | ((int32_t)data[4] << 4) | (data[5] >> 4);
    
    // ADC saturation check: 0x80000 means measurement was skipped/invalid
    if (adc_P == 0x80000 || adc_T == 0x80000) {
        return NAN;
    }
    
    // Temperature compensation (required for accurate pressure)
    int32_t var1 = ((((adc_T >> 3) - ((int32_t)g_calib.dig_T1 << 1))) * 
                    ((int32_t)g_calib.dig_T2)) >> 11;
    int32_t var2 = (((((adc_T >> 4) - ((int32_t)g_calib.dig_T1)) * 
                      ((adc_T >> 4) - ((int32_t)g_calib.dig_T1))) >> 12) * 
                    ((int32_t)g_calib.dig_T3)) >> 14;
    g_calib.t_fine = var1 + var2;
    
    // Store temperature for CMD_GET_TEMPERATURE (in °C x100)
    g_last_temperature_x100 = (int16_t)((g_calib.t_fine * 5 + 128) >> 8);
    
    // Pressure compensation (64-bit arithmetic for precision)
    int64_t p_var1 = ((int64_t)g_calib.t_fine) - 128000;
    int64_t p_var2 = p_var1 * p_var1 * (int64_t)g_calib.dig_P6;
    p_var2 += (p_var1 * (int64_t)g_calib.dig_P5) << 17;
    p_var2 += ((int64_t)g_calib.dig_P4) << 35;
    p_var1 = ((p_var1 * p_var1 * (int64_t)g_calib.dig_P3) >> 8) + 
             ((p_var1 * (int64_t)g_calib.dig_P2) << 12);
    p_var1 = ((((int64_t)1) << 47) + p_var1) * ((int64_t)g_calib.dig_P1) >> 33;
    
    if (p_var1 == 0) return NAN;  // Corrupt calibration data
    
    int64_t p = 1048576 - adc_P;
    p = (((p << 31) - p_var2) * 3125) / p_var1;
    p_var1 = (((int64_t)g_calib.dig_P9) * (p >> 13) * (p >> 13)) >> 25;
    p_var2 = (((int64_t)g_calib.dig_P8) * p) >> 19;
    p = ((p + p_var1 + p_var2) >> 8) + (((int64_t)g_calib.dig_P7) << 4);
    
    float pressure_hpa = (float)p / 25600.0f;  // Convert to hPa
    
    // Range validation: BMP280 only guarantees accuracy within 300-1100 hPa
    if (pressure_hpa < BMP280_PRESSURE_MIN_HPA || pressure_hpa > BMP280_PRESSURE_MAX_HPA) {
        return NAN;  // Out of valid range
    }
    
    return pressure_hpa;
}

/* ============================================================================
 * USB MIDI SysEx Command Processing
 * ========================================================================== */

// Forward declaration for serial number setup
extern void usb_set_serial_number(const char* serial);

/**
 * @brief Process received MIDI SysEx message
 */
static void midi_process_sysex(sysex_message_t* msg) {
    uint64_t now_ms = time_us_64() / 1000;
    
    switch (msg->command) {
        case CMD_PING:
            g_last_ping_ms = now_ms;
            if (!g_app_connected) {
                g_app_connected = true;
                // Baseline persists across reconnections — set once per power cycle.
                // Use CMD_RESET_BASELINE for explicit reset from the app.
                led_set_state(LED_STATE_APP_CONNECTED);
            }
            midi_sysex_send_pong();
            break;
            
        case CMD_REQUEST_INFO:
            midi_sysex_send_device_info(g_serial_number, g_device_name, 
                                         FW_VERSION_STRING, g_sensor_ready);
            break;
            
        case CMD_RESET_BASELINE:
            g_baseline_set = false;
            __dmb();  // Ensure Core 1 sees the reset before resuming
            break;
            
        case CMD_SET_OUTPUT_RATE:
            if (msg->data_len >= 1) {
                int rate = msg->data[0];
                if (rate >= MIN_OUTPUT_RATE_HZ && rate <= MAX_OUTPUT_RATE_HZ) {
                    int new_interval = 1000 / rate;
                    int new_samples = INTERNAL_SAMPLE_RATE_HZ / rate;
                    g_output_rate = rate;
                    __dmb();
                    g_output_interval_ms = new_interval;
                    g_samples_per_output = new_samples;
                    __dmb();
                    flash_save_settings();
                }
                midi_sysex_send_config(g_output_rate);
            }
            break;
            
        case CMD_SET_NAME:
            // Format: [4 bytes PIN][name...]
            if (msg->data_len > DEVICE_PIN_LEN) {
                if (!pin_check_rate_limit()) {
                    midi_sysex_send_ack(CMD_SET_NAME, 0x02);
                    break;
                }
                char pin[DEVICE_PIN_LEN + 1];
                memcpy(pin, msg->data, DEVICE_PIN_LEN);
                pin[DEVICE_PIN_LEN] = '\0';
                
                if (pin_verify(pin)) {
                    pin_record_success();
                    char name[DEVICE_NAME_MAX_LEN + 1];
                    uint8_t name_len = msg->data_len - DEVICE_PIN_LEN;
                    if (name_len > DEVICE_NAME_MAX_LEN) name_len = DEVICE_NAME_MAX_LEN;
                    memcpy(name, &msg->data[DEVICE_PIN_LEN], name_len);
                    name[name_len] = '\0';
                    device_set_name(name);
                    midi_sysex_send_ack(CMD_SET_NAME, 0x00);
                } else {
                    pin_record_failure();
                    midi_sysex_send_ack(CMD_SET_NAME, 0x02);
                }
            } else {
                midi_sysex_send_ack(CMD_SET_NAME, 0x01);
            }
            // Send updated device info
            midi_sysex_send_device_info(g_serial_number, g_device_name,
                                         FW_VERSION_STRING, g_sensor_ready);
            break;
            
        case CMD_SET_PIN:
            // Format: [4 bytes old PIN][4 bytes new PIN]
            if (msg->data_len == DEVICE_PIN_LEN * 2) {
                if (!pin_check_rate_limit()) {
                    midi_sysex_send_ack(CMD_SET_PIN, 0x02);
                    break;
                }
                char old_pin[DEVICE_PIN_LEN + 1];
                char new_pin[DEVICE_PIN_LEN + 1];
                memcpy(old_pin, msg->data, DEVICE_PIN_LEN);
                old_pin[DEVICE_PIN_LEN] = '\0';
                memcpy(new_pin, &msg->data[DEVICE_PIN_LEN], DEVICE_PIN_LEN);
                new_pin[DEVICE_PIN_LEN] = '\0';
                
                if (pin_verify(old_pin) && pin_is_valid_format(new_pin)) {
                    pin_record_success();
                    device_set_pin(new_pin);
                    midi_sysex_send_ack(CMD_SET_PIN, 0x00);
                } else {
                    pin_record_failure();
                    midi_sysex_send_ack(CMD_SET_PIN, 0x02);
                }
            } else {
                midi_sysex_send_ack(CMD_SET_PIN, 0x01);
            }
            break;
            
        case CMD_AUTH_CHALLENGE:
            // Format: [64 bytes = hex string of 32-byte nonce as ASCII]
            if (msg->data_len == 64) {
                // Copy hex string directly (ASCII characters 0-9, a-f)
                char nonce_hex[65];
                memcpy(nonce_hex, msg->data, 64);
                nonce_hex[64] = '\0';
                
                // Validate hex characters (constant-time to prevent timing side-channel)
                volatile bool valid_hex = true;
                for (int i = 0; i < 64; i++) {
                    char c = nonce_hex[i];
                    if (!((c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F'))) {
                        valid_hex = false;
                        // Don't break — continue to avoid timing leak
                    }
                }
                if (!valid_hex) {
                    midi_sysex_send_ack(CMD_AUTH_CHALLENGE, 0x01);
                    break;
                }
                
                // Sign and send response
                if (!g_ecdsa_initialized) {
                    ecdsa_init();
                }
                
                if (g_ecdsa_initialized) {
                    // Convert hex to bytes using inline nibble lookup
                    uint8_t nonce[32];
                    for (int i = 0; i < 32; i++) {
                        uint8_t hi = nonce_hex[i*2];
                        uint8_t lo = nonce_hex[i*2+1];
                        hi = (hi <= '9') ? (hi - '0') : ((hi <= 'F') ? (hi - 'A' + 10) : (hi - 'a' + 10));
                        lo = (lo <= '9') ? (lo - '0') : ((lo <= 'F') ? (lo - 'A' + 10) : (lo - 'a' + 10));
                        nonce[i] = (hi << 4) | lo;
                    }
                    
                    // Hash the nonce
                    uint8_t hash[32];
                    mbedtls_sha256(nonce, 32, hash, 0);
                    
                    // Feed watchdog before potentially long ECDSA signing
                    watchdog_update();
                    
                    // Sign
                    uint8_t sig[MBEDTLS_ECDSA_MAX_LEN];
                    size_t sig_len = 0;
                    int ret = mbedtls_ecdsa_write_signature(&g_ecdsa_ctx, MBEDTLS_MD_SHA256,
                                                            hash, 32, sig, sizeof(sig), &sig_len,
                                                            mbedtls_ctr_drbg_random, &g_ctr_drbg);
                    if (ret == 0) {
                        midi_sysex_send_auth_response(sig, sig_len);
                    } else {
                        midi_sysex_send_ack(CMD_AUTH_CHALLENGE, 0x03);  // Signing failed
                    }
                    // Zero sensitive cryptographic material after use
                    mbedtls_platform_zeroize(nonce, sizeof(nonce));
                    mbedtls_platform_zeroize(hash, sizeof(hash));
                    mbedtls_platform_zeroize(sig, sizeof(sig));
                } else {
                    midi_sysex_send_ack(CMD_AUTH_CHALLENGE, 0x03);  // ECDSA not initialized
                }
            } else {
                midi_sysex_send_ack(CMD_AUTH_CHALLENGE, 0x01);  // Invalid data length
            }
            break;
            
        case CMD_GET_CONFIG:
            midi_sysex_send_full_config(g_output_rate, g_led_brightness,
                                         g_noise_floor, g_oversampling_ctrl,
                                         g_iir_config);
            break;
            
        case CMD_SET_LED:
            if (msg->data_len >= 1) {
                uint8_t brightness = msg->data[0];
                if (brightness > 100) brightness = 100;
                g_led_brightness = brightness;
                // Re-apply current LED state with new brightness
                if (g_app_connected) {
                    led_set_state(LED_STATE_APP_CONNECTED);
                }
                mark_settings_dirty();  // Debounced persist LED brightness
                midi_sysex_send_ack(CMD_SET_LED, 0x00);
            } else {
                midi_sysex_send_ack(CMD_SET_LED, 0x01);
            }
            break;
            
        case CMD_RESET_SENSOR:
            if (bmp280_reinit_config()) {
                g_sensor_ready = true;
                midi_sysex_send_ack(CMD_RESET_SENSOR, 0x00);
            } else {
                g_sensor_ready = false;
                sat_inc_u16(&g_sensor_error_count);
                midi_sysex_send_ack(CMD_RESET_SENSOR, 0x03);
            }
            break;
            
        case CMD_FACTORY_RESET:
            // Format: [4 bytes PIN]
            if (msg->data_len >= DEVICE_PIN_LEN) {
                if (!pin_check_rate_limit()) {
                    midi_sysex_send_ack(CMD_FACTORY_RESET, 0x02);
                    break;
                }
                char pin[DEVICE_PIN_LEN + 1];
                memcpy(pin, msg->data, DEVICE_PIN_LEN);
                pin[DEVICE_PIN_LEN] = '\0';
                
                if (pin_verify(pin)) {
                    pin_record_success();
                    // Reset ALL runtime config to defaults BEFORE saving to flash
                    strncpy(g_device_name, "DiveChecker", DEVICE_NAME_MAX_LEN);
                    g_device_name[DEVICE_NAME_MAX_LEN] = '\0';
                    strncpy(g_device_pin, "0000", DEVICE_PIN_LEN);
                    g_device_pin[DEVICE_PIN_LEN] = '\0';
                    g_led_brightness = LED_BRIGHTNESS;
                    g_noise_floor = 1;
                    g_oversampling_ctrl = 5;
                    g_iir_config = 1;
                    g_output_rate = DEFAULT_OUTPUT_RATE_HZ;
                    g_output_interval_ms = 1000 / DEFAULT_OUTPUT_RATE_HZ;
                    g_samples_per_output = INTERNAL_SAMPLE_RATE_HZ / DEFAULT_OUTPUT_RATE_HZ;
                    flash_save_settings();  // Save with all defaults
                    // Re-apply sensor config
                    bmp280_apply_config();
                    midi_sysex_send_ack(CMD_FACTORY_RESET, 0x00);
                    // Send updated info
                    midi_sysex_send_device_info(g_serial_number, g_device_name,
                                                 FW_VERSION_STRING, g_sensor_ready);
                } else {
                    pin_record_failure();
                    midi_sysex_send_ack(CMD_FACTORY_RESET, 0x02);  // Auth required
                }
            } else {
                midi_sysex_send_ack(CMD_FACTORY_RESET, 0x01);
            }
            break;
            
        case CMD_SET_NOISE_FLOOR:
            if (msg->data_len >= 1) {
                uint8_t nf = msg->data[0];
                if (nf <= 50) {
                    g_noise_floor = nf;
                    mark_settings_dirty();  // Debounced persist noise floor
                    midi_sysex_send_ack(CMD_SET_NOISE_FLOOR, 0x00);
                } else {
                    midi_sysex_send_ack(CMD_SET_NOISE_FLOOR, 0x01);
                }
            } else {
                midi_sysex_send_ack(CMD_SET_NOISE_FLOOR, 0x01);
            }
            break;
            
        case CMD_GET_TEMPERATURE:
            midi_sysex_send_temperature(g_last_temperature_x100);
            break;
            
        case CMD_ENTER_BOOTLOADER:
            // Format: [4 bytes PIN]
            if (msg->data_len >= DEVICE_PIN_LEN) {
                if (!pin_check_rate_limit()) {
                    midi_sysex_send_ack(CMD_ENTER_BOOTLOADER, 0x02);
                    break;
                }
                char pin[DEVICE_PIN_LEN + 1];
                memcpy(pin, msg->data, DEVICE_PIN_LEN);
                pin[DEVICE_PIN_LEN] = '\0';
                
                if (pin_verify(pin)) {
                    pin_record_success();
                    midi_sysex_send_ack(CMD_ENTER_BOOTLOADER, 0x00);
                    sleep_ms(100);  // Let ACK be sent
                    
                    // CRITICAL: Stop Core 1 and disable watchdog before
                    // entering BOOTSEL. Core 1 runs from XIP flash and
                    // accesses I2C — if it's active during ROM bootloader
                    // entry the chip hangs.
                    watchdog_disable();
                    multicore_lockout_start_blocking();
                    uint32_t irq_state = save_and_disable_interrupts();
                    reset_usb_boot(0, 0);
                    __builtin_unreachable();
                } else {
                    pin_record_failure();
                    midi_sysex_send_ack(CMD_ENTER_BOOTLOADER, 0x02);
                }
            } else {
                midi_sysex_send_ack(CMD_ENTER_BOOTLOADER, 0x01);
            }
            break;
            
        case CMD_GET_DIAGNOSTICS: {
            uint32_t uptime = (uint32_t)((time_us_64() / 1000 - (uint64_t)g_boot_time_ms) / 1000);
            midi_sysex_send_diagnostics(uptime, g_sensor_error_count,
                                         g_overrange_event_count,
                                         g_i2c_recovery_count,
                                         g_last_temperature_x100);
            break;
        }
            
        case CMD_SET_OVERSAMPLING:
            if (msg->data_len >= 1) {
                uint8_t osrs = msg->data[0];
                if (osrs <= 5) {
                    g_oversampling_ctrl = osrs;
                    if (bmp280_apply_config()) {
                        mark_settings_dirty();  // Debounced persist oversampling
                        midi_sysex_send_ack(CMD_SET_OVERSAMPLING, 0x00);
                    } else {
                        sat_inc_u16(&g_sensor_error_count);
                        midi_sysex_send_ack(CMD_SET_OVERSAMPLING, 0x03);
                    }
                } else {
                    midi_sysex_send_ack(CMD_SET_OVERSAMPLING, 0x01);
                }
            } else {
                midi_sysex_send_ack(CMD_SET_OVERSAMPLING, 0x01);
            }
            break;
            
        case CMD_SET_IIR_FILTER:
            if (msg->data_len >= 1) {
                uint8_t iir = msg->data[0];
                if (iir <= 4) {
                    g_iir_config = iir;
                    if (bmp280_apply_config()) {
                        mark_settings_dirty();  // Debounced persist IIR filter
                        midi_sysex_send_ack(CMD_SET_IIR_FILTER, 0x00);
                    } else {
                        sat_inc_u16(&g_sensor_error_count);
                        midi_sysex_send_ack(CMD_SET_IIR_FILTER, 0x03);
                    }
                } else {
                    midi_sysex_send_ack(CMD_SET_IIR_FILTER, 0x01);
                }
            } else {
                midi_sysex_send_ack(CMD_SET_IIR_FILTER, 0x01);
            }
            break;
            
        case CMD_SOFT_REBOOT:
            // Soft reboot via watchdog (PIN required for security)
            if (msg->data_len >= DEVICE_PIN_LEN) {
                if (!pin_check_rate_limit()) {
                    midi_sysex_send_ack(CMD_SOFT_REBOOT, 0x02);  // Rate limited
                    break;
                }
                char pin[DEVICE_PIN_LEN + 1];
                memcpy(pin, msg->data, DEVICE_PIN_LEN);
                pin[DEVICE_PIN_LEN] = '\0';
                
                if (pin_verify(pin)) {
                    pin_record_success();
                    midi_sysex_send_ack(CMD_SOFT_REBOOT, 0x00);
                    sleep_ms(100);  // Let ACK be sent
                    watchdog_reboot(0, 0, 0);  // Immediate watchdog reset
                } else {
                    pin_record_failure();
                    midi_sysex_send_ack(CMD_SOFT_REBOOT, 0x02);  // Wrong PIN
                }
            } else {
                midi_sysex_send_ack(CMD_SOFT_REBOOT, 0x01);  // Invalid data
            }
            break;
            
        default:
            // Unknown command — send error ACK
            midi_sysex_send_ack(msg->command, 0x01);
            break;
    }
}

/**
 * @brief Process incoming MIDI data from USB
 */
static void midi_task(void) {
    uint8_t packet[4];
    
    while (tud_midi_available()) {
        if (tud_midi_packet_read(packet)) {
            // MIDI packet format: [cable_num | code_index][midi0][midi1][midi2]
            uint8_t code_index = packet[0] & 0x0F;
            
            // Process bytes based on code index
            // SysEx uses code indexes 4, 5, 6, 7
            switch (code_index) {
                case 4: // SysEx starts or continues
                    midi_sysex_receive_byte(packet[1]);
                    midi_sysex_receive_byte(packet[2]);
                    midi_sysex_receive_byte(packet[3]);
                    break;
                case 5: // Single byte system common or SysEx ends with 1 byte
                    if (midi_sysex_receive_byte(packet[1])) {
                        sysex_message_t* msg = midi_sysex_get_message();
                        if (msg) midi_process_sysex(msg);
                    }
                    break;
                case 6: // SysEx ends with 2 bytes
                    midi_sysex_receive_byte(packet[1]);
                    if (midi_sysex_receive_byte(packet[2])) {
                        sysex_message_t* msg = midi_sysex_get_message();
                        if (msg) midi_process_sysex(msg);
                    }
                    break;
                case 7: // SysEx ends with 3 bytes
                    midi_sysex_receive_byte(packet[1]);
                    midi_sysex_receive_byte(packet[2]);
                    if (midi_sysex_receive_byte(packet[3])) {
                        sysex_message_t* msg = midi_sysex_get_message();
                        if (msg) midi_process_sysex(msg);
                    }
                    break;
                default:
                    // Other MIDI messages — ignored
                    break;
            }
        }
    }
}

/* ============================================================================
 * Core 1: Sensor Sampling Task
 * ========================================================================== */

static void core1_sensor_task(void) {
    // Allow Core 0 to lockout Core 1 during flash operations
    multicore_lockout_victim_init();
    
    // Initialize I2C on Core 1
    i2c_init(I2C_PORT, I2C_BAUDRATE);
    gpio_set_function(I2C_SDA_PIN, GPIO_FUNC_I2C);
    gpio_set_function(I2C_SCL_PIN, GPIO_FUNC_I2C);
    gpio_pull_up(I2C_SDA_PIN);
    gpio_pull_up(I2C_SCL_PIN);
    
    // EMC: Reduce drive strength and slew rate for I2C pins
    gpio_set_drive_strength(I2C_SDA_PIN, GPIO_DRIVE_STRENGTH_2MA);
    gpio_set_drive_strength(I2C_SCL_PIN, GPIO_DRIVE_STRENGTH_2MA);
    gpio_set_slew_rate(I2C_SDA_PIN, GPIO_SLEW_RATE_SLOW);
    gpio_set_slew_rate(I2C_SCL_PIN, GPIO_SLEW_RATE_SLOW);
    
    sleep_ms(100);  // Sensor power-up delay
    
    // Sensor init with retry (exponential backoff)
    // NOTE: Only ONE FIFO message is sent after the loop completes
    //       to prevent Core 0 from reading a stale failure status
    int retry_delay_ms = 1000;  // Start at 1s
    while (!g_sensor_ready) {
        g_sensor_ready = bmp280_init();
        if (g_sensor_ready) break;
        
        // Wait with watchdog feeding before retry
        for (int i = 0; i < retry_delay_ms / 100; i++) {
            watchdog_update();
            sleep_ms(100);
        }
        
        // Exponential backoff: 1s, 2s, 4s, 8s, 16s, 30s max
        retry_delay_ms *= 2;
        if (retry_delay_ms > 30000) retry_delay_ms = 30000;
        
        if (g_sensor_error_count < UINT16_MAX) g_sensor_error_count++;
        #if CFG_TUD_CDC
        printf("WARN:Sensor init retry (delay=%dms)\n", retry_delay_ms);
        #endif
    }
    
    // Single definitive status push — Core 0 reads exactly one value
    multicore_fifo_push_blocking(g_sensor_ready ? 1 : 0);
    
    // Sample buffer for averaging (sized for minimum rate = max samples)
    float sample_buffer[MAX_SAMPLES_PER_OUTPUT + 2];
    int sample_count = 0;
    
    // Timing
    uint64_t last_sample_us = 0;
    uint64_t last_output_ms = 0;
    
    // Over-range recovery state
    int overrange_consec = 0;        // Consecutive out-of-range readings
    bool in_recovery = false;        // Currently recovering from over-range
    int recovery_remaining = 0;      // Samples to discard before trusting data
    
    // Main sampling loop
    // ARCHITECTURE: Sensor runs ALWAYS regardless of app connection state.
    // This keeps the BMP280 IIR filter warm, averaging buffer fresh, and
    // timing stable. Only the queue-to-Core0 step checks g_app_connected.
    // Result: reconnection is seamless — no data gaps, no value spikes.
    while (true) {
        watchdog_update();
        
        if (!g_sensor_ready) {
            // Sensor not ready — auto-retry every 5 seconds
            static uint64_t last_sensor_retry_ms = 0;
            uint64_t now_retry = time_us_64() / 1000;
            if (now_retry - last_sensor_retry_ms > 5000) {
                last_sensor_retry_ms = now_retry;
                g_sensor_ready = bmp280_init();
                if (g_sensor_ready) {
                    bmp280_apply_config();
                    #if CFG_TUD_CDC
                    printf("INFO:Sensor auto-recovered\n");
                    #endif
                }
            }
            sleep_us(100);
            continue;
        }
        
        uint64_t now_us = time_us_64();
        uint64_t now_ms = now_us / 1000;
        
        // 100Hz internal sampling — runs continuously
        if (now_us - last_sample_us >= SAMPLE_INTERVAL_US) {
            last_sample_us = now_us;
            
            float reading;
            if (g_sensor_reconfiguring) {
                reading = NAN;
            } else {
                reading = bmp280_read_pressure();
            }
            
            if (isnan(reading)) {
                if (g_lockout_grace > 0) {
                    g_lockout_grace--;
                } else {
                    overrange_consec++;
                }
                
                if (overrange_consec >= OVERRANGE_CONSEC_THRESHOLD && !in_recovery) {
                    if (g_sensor_reconfiguring) {
                        overrange_consec = 0;
                    } else {
                        #if CFG_TUD_CDC
                        printf("WARN:Sensor over-range, resetting...\n");
                        #endif
                        sat_inc_u16(&g_overrange_event_count);
                        
                        if (bmp280_reinit_config()) {
                            in_recovery = true;
                            recovery_remaining = OVERRANGE_RECOVERY_SAMPLES;
                            sample_count = 0;
                            overrange_consec = 0;
                            g_overrange_alert = true;
                            
                            #if CFG_TUD_CDC
                            printf("INFO:Sensor reset OK, stabilizing (%d samples)\n",
                                   OVERRANGE_RECOVERY_SAMPLES);
                            #endif
                        } else {
                            g_sensor_ready = bmp280_init();
                            sat_inc_u16(&g_sensor_error_count);
                            overrange_consec = 0;
                        }
                    }
                }
            } else {
                overrange_consec = 0;
                
                if (in_recovery) {
                    recovery_remaining--;
                    if (recovery_remaining <= 0) {
                        in_recovery = false;
                        #if CFG_TUD_CDC
                        printf("INFO:Sensor recovered, resuming normal operation\n");
                        #endif
                    }
                } else if (sample_count < g_samples_per_output) {
                    sample_buffer[sample_count++] = reading;
                }
            }
        }
        
        // Output at configured rate — averaging runs continuously
        if (now_ms - last_output_ms >= (uint64_t)g_output_interval_ms) {
            last_output_ms = now_ms;
            
            if (sample_count > 0) {
                float sum = 0;
                for (int i = 0; i < sample_count; i++) {
                    sum += sample_buffer[i];
                }
                float avg_pressure = sum / sample_count;
                sample_count = 0;
                
                if (!g_baseline_set) {
                    g_baseline_pressure = avg_pressure;
                    __dmb();  // Ensure pressure is visible before setting flag
                    g_baseline_set = true;
                }
                
                float delta = avg_pressure - g_baseline_pressure;
                int32_t delta_x1000 = (int32_t)(delta * 1000.0f);
                
                int32_t nf = (int32_t)g_noise_floor;
                if (delta_x1000 > -nf && delta_x1000 < nf) {
                    delta_x1000 = 0;
                }
                
                // Only forward to Core 0 when app is connected
                if (g_app_connected) {
                    pressure_packet_t packet = {
                        .delta_x1000 = delta_x1000
                    };
                    if (!queue_try_add(&g_pressure_queue, &packet)) {
                        pressure_packet_t discard;
                        queue_try_remove(&g_pressure_queue, &discard);
                        queue_try_add(&g_pressure_queue, &packet);
                    }
                }
            }
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
    // Debug output via CDC (if enabled in tusb_config.h)
    #if CFG_TUD_CDC
    printf("\n");
    printf("========================================\n");
    printf("  DiveChecker RP2350 v%s (USB MIDI)\n", FW_VERSION_STRING);
    printf("  Dual-Core %dHz -> %dHz Output\n", INTERNAL_SAMPLE_RATE_HZ, g_output_rate);
    printf("========================================\n\n");
    printf("Device : %s\n", g_device_name);
    printf("Serial : %s\n", g_serial_number);
    printf("I2C    : GP%d/GP%d @ %dkHz\n", I2C_SDA_PIN, I2C_SCL_PIN, I2C_BAUDRATE / 1000);
    printf("Sensor : %s (X16 + IIR X2)\n", g_sensor_ready ? "OK" : "NOT FOUND");
    printf("Mode   : Core0=USB MIDI, Core1=Sensor\n");
    printf("Output : %dHz (%d-%dHz)\n", g_output_rate, MIN_OUTPUT_RATE_HZ, MAX_OUTPUT_RATE_HZ);
    printf("Filter : Average (%d samples)\n", g_samples_per_output);
    printf("\nReady for MIDI connection...\n");
    printf("========================================\n");
    #endif
}

/* ============================================================================
 * TinyUSB Callbacks for Power Management (EMC)
 * ========================================================================== */

/**
 * @brief Called when USB bus is suspended
 * @details Reduce power consumption to minimize EMI during suspend
 */
void tud_suspend_cb(bool remote_wakeup_en) {
    (void) remote_wakeup_en;
    led_set_state(LED_STATE_OFF);
    #if CFG_TUD_CDC
    printf("USB: Suspended\n");
    #endif
}

/**
 * @brief Called when USB bus is resumed
 */
void tud_resume_cb(void) {
    led_set_state(g_app_connected ? LED_STATE_APP_CONNECTED : LED_STATE_USB_READY);
    #if CFG_TUD_CDC
    printf("USB: Resumed\n");
    #endif
}

int main(void) {
    // =========================================================================
    // EMC: Configure unused GPIO pins to prevent floating (reduce EMI)
    // Used GPIOs: GP8 (I2C SDA), GP9 (I2C SCL), GP16 (WS2812 LED)
    // =========================================================================
    static const uint8_t used_gpios[] = {8, 9, 16};
    for (uint gpio = 0; gpio < NUM_BANK0_GPIOS; gpio++) {
        bool in_use = false;
        for (size_t i = 0; i < sizeof(used_gpios); i++) {
            if (gpio == used_gpios[i]) {
                in_use = true;
                break;
            }
        }
        if (!in_use) {
            gpio_init(gpio);
            gpio_set_dir(gpio, GPIO_IN);
            gpio_pull_down(gpio);
        }
    }
    
    init_serial_number();
    flash_load_settings();
    
    usb_set_serial_number(g_serial_number);
    tusb_init();
    
    // Initialize MIDI SysEx handler
    midi_sysex_init();
    
    // Initialize inter-core queue
    queue_init(&g_pressure_queue, sizeof(pressure_packet_t), PRESSURE_QUEUE_SIZE);
    
    // Initialize I2C mutex for cross-core access protection
    mutex_init(&g_i2c_mutex);
    
    // Initialize LED
    led_init();
    led_set_state(LED_STATE_BOOT);
    
    // Launch sensor task on Core 1
    multicore_launch_core1(core1_sensor_task);
    
    // Wait for Core 1 initialization
    uint32_t sensor_status = multicore_fifo_pop_blocking();
    g_sensor_ready = (sensor_status == 1);
    
    // Wait for USB connection with blinking LED
    // Enable watchdog early for self-recovery if USB init hangs
    watchdog_enable(8000, true);  // 8s generous timeout during boot
    uint64_t last_blink_us = 0;
    bool blink = false;
    while (!tud_connected()) {
        tud_task();
        watchdog_update();
        uint64_t now_us = time_us_64();
        if (now_us - last_blink_us > 500000) {
            last_blink_us = now_us;
            blink = !blink;
            led_set_state(blink ? LED_STATE_USB_WAIT : LED_STATE_OFF);
        }
        sleep_ms(10);
    }
    led_set_state(LED_STATE_USB_READY);
    sleep_ms(500);
    
    // Print startup info (to CDC debug port if available)
    print_startup_banner();
    
    // Record boot time for uptime calculation
    g_boot_time_ms = time_us_64() / 1000;
    
    // =========================================================================
    // EMC: Enable watchdog for auto-recovery from ESD-induced hangs
    // Timeout: 2000ms - both cores must feed regularly
    // Tighten from boot timeout (8s) to operational timeout (2s)
    // =========================================================================
    watchdog_enable(2000, true);  // 2 second timeout, pause on debug
    
    // Main loop: USB MIDI communication on Core 0
    while (true) {
        // Feed watchdog at start of each iteration
        watchdog_update();
        
        uint64_t now_ms = time_us_64() / 1000;
        
        // TinyUSB device task - MUST be called frequently
        tud_task();
        
        // Process incoming MIDI messages
        midi_task();
        
        // Check for connection timeout
        if (g_app_connected && (now_ms - g_last_ping_ms > CONNECTION_TIMEOUT_MS)) {
            g_app_connected = false;
            g_baseline_printed = false;  // Reset for next connection
            led_set_state(LED_STATE_USB_READY);
            #if CFG_TUD_CDC
            printf("MIDI: App disconnected (timeout)\n");
            #endif
        }
        
        // Forward pressure data from Core 1 via MIDI SysEx
        pressure_packet_t packet;
        while (queue_try_remove(&g_pressure_queue, &packet)) {
            if (g_app_connected) {
                // Send baseline info once
                if (!g_baseline_printed && g_baseline_set) {
                    #if CFG_TUD_CDC
                    printf("INFO: Baseline %.3f hPa\n", g_baseline_pressure);
                    #endif
                    g_baseline_printed = true;
                }
                // Send pressure via MIDI SysEx
                midi_sysex_send_pressure(packet.delta_x1000);
            }
        }
        
        // Send over-range alert to app (set by Core 1)
        if (g_overrange_alert && g_app_connected) {
            g_overrange_alert = false;
            midi_sysex_send_overrange_alert();
        }
        
        // Debounced flash save: write settings 3s after last change
        // Reduces flash wear from rapid slider adjustments
        if (g_settings_dirty && (now_ms - g_settings_dirty_since_ms > FLASH_SAVE_DEBOUNCE_MS)) {
            flash_save_settings();
            g_settings_dirty = false;
        }
        
        sleep_us(100);
    }
    
    return 0;
}

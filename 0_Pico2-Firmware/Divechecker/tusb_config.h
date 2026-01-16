/**
 * @file tusb_config.h
 * @brief TinyUSB configuration for USB MIDI device
 * 
 * DiveChecker RP2350 USB MIDI Configuration
 */

#ifndef _TUSB_CONFIG_H_
#define _TUSB_CONFIG_H_

#ifdef __cplusplus
extern "C" {
#endif

//--------------------------------------------------------------------
// COMMON CONFIGURATION
//--------------------------------------------------------------------

#define CFG_TUSB_MCU                OPT_MCU_RP2040
#define CFG_TUSB_OS                 OPT_OS_PICO
#define CFG_TUSB_DEBUG              0

// Enable device stack
#define CFG_TUD_ENABLED             1

// RHPort number used for device
#define BOARD_TUD_RHPORT            0

// RHPort max operational speed
#define BOARD_TUD_MAX_SPEED         OPT_MODE_FULL_SPEED

// RHPort mode (required by TinyUSB)
#define CFG_TUSB_RHPORT0_MODE       (OPT_MODE_DEVICE | OPT_MODE_FULL_SPEED)

//--------------------------------------------------------------------
// DEVICE CONFIGURATION
//--------------------------------------------------------------------

#define CFG_TUD_ENDPOINT0_SIZE      64

//------------- CLASS CONFIGURATION -------------//

// MIDI Class
#define CFG_TUD_MIDI                1
#define CFG_TUD_MIDI_RX_BUFSIZE     64
#define CFG_TUD_MIDI_TX_BUFSIZE     64

// CDC Class (for debug output, optional)
#define CFG_TUD_CDC                 1
#define CFG_TUD_CDC_RX_BUFSIZE      256
#define CFG_TUD_CDC_TX_BUFSIZE      256

// Disable unused classes
#define CFG_TUD_MSC                 0
#define CFG_TUD_HID                 0
#define CFG_TUD_VENDOR              0

#ifdef __cplusplus
}
#endif

#endif /* _TUSB_CONFIG_H_ */

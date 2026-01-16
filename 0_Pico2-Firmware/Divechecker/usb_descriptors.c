/**
 * @file usb_descriptors.c
 * @brief USB Descriptors for DiveChecker MIDI Device
 * 
 * Composite device: MIDI + CDC (for debug)
 */

#include "tusb.h"
#include "pico/unique_id.h"

//--------------------------------------------------------------------
// Device Descriptors
//--------------------------------------------------------------------

tusb_desc_device_t const desc_device = {
    .bLength            = sizeof(tusb_desc_device_t),
    .bDescriptorType    = TUSB_DESC_DEVICE,
    .bcdUSB             = 0x0200,
    .bDeviceClass       = 0x00,      // Defined at interface level
    .bDeviceSubClass    = 0x00,
    .bDeviceProtocol    = 0x00,
    .bMaxPacketSize0    = CFG_TUD_ENDPOINT0_SIZE,
    
    .idVendor           = 0x1209,    // pid.codes VID (open source hardware)
    .idProduct          = 0xDC01,    // DiveChecker product ID
    .bcdDevice          = 0x0100,    // Version 1.0
    
    .iManufacturer      = 0x01,
    .iProduct           = 0x02,
    .iSerialNumber      = 0x03,
    
    .bNumConfigurations = 0x01
};

uint8_t const* tud_descriptor_device_cb(void) {
    return (uint8_t const*)&desc_device;
}

//--------------------------------------------------------------------
// Configuration Descriptor
//--------------------------------------------------------------------

enum {
    ITF_NUM_MIDI = 0,
    ITF_NUM_MIDI_STREAMING,
    ITF_NUM_CDC,
    ITF_NUM_CDC_DATA,
    ITF_NUM_TOTAL
};

#define EPNUM_MIDI_OUT   0x01
#define EPNUM_MIDI_IN    0x81
#define EPNUM_CDC_NOTIF  0x82
#define EPNUM_CDC_OUT    0x03
#define EPNUM_CDC_IN     0x83

#define CONFIG_TOTAL_LEN (TUD_CONFIG_DESC_LEN + TUD_MIDI_DESC_LEN + TUD_CDC_DESC_LEN)

uint8_t const desc_configuration[] = {
    // Config descriptor
    TUD_CONFIG_DESCRIPTOR(1, ITF_NUM_TOTAL, 0, CONFIG_TOTAL_LEN, 0x00, 100),
    
    // MIDI descriptor
    TUD_MIDI_DESCRIPTOR(ITF_NUM_MIDI, 0, EPNUM_MIDI_OUT, EPNUM_MIDI_IN, 64),
    
    // CDC descriptor
    TUD_CDC_DESCRIPTOR(ITF_NUM_CDC, 4, EPNUM_CDC_NOTIF, 8, EPNUM_CDC_OUT, EPNUM_CDC_IN, 64),
};

uint8_t const* tud_descriptor_configuration_cb(uint8_t index) {
    (void)index;
    return desc_configuration;
}

//--------------------------------------------------------------------
// String Descriptors
//--------------------------------------------------------------------

// String descriptor index
enum {
    STRID_LANGID = 0,
    STRID_MANUFACTURER,
    STRID_PRODUCT,
    STRID_SERIAL,
    STRID_CDC_INTERFACE,
};

// Supported language
static uint16_t const string_desc_langid[] = { 
    (TUSB_DESC_STRING << 8) | (2 + 2), 
    0x0409  // English
};

// Serial number buffer (filled at runtime from chip ID)
static char serial_str[PICO_UNIQUE_BOARD_ID_SIZE_BYTES * 2 + 1] = "000000000000";

void usb_set_serial_number(const char* serial) {
    strncpy(serial_str, serial, sizeof(serial_str) - 1);
    serial_str[sizeof(serial_str) - 1] = '\0';
}

// Convert ASCII string to UTF-16
static uint16_t desc_string_buffer[32 + 1];

uint16_t const* tud_descriptor_string_cb(uint8_t index, uint16_t langid) {
    (void)langid;
    
    const char* str;
    uint8_t chr_count;
    
    switch (index) {
        case STRID_LANGID:
            return string_desc_langid;
            
        case STRID_MANUFACTURER:
            str = "kodenet.io";
            break;
            
        case STRID_PRODUCT:
            str = "DiveChecker V1";
            break;
            
        case STRID_SERIAL:
            str = serial_str;
            break;
            
        case STRID_CDC_INTERFACE:
            str = "DiveChecker Debug";
            break;
            
        default:
            return NULL;
    }
    
    chr_count = strlen(str);
    if (chr_count > 31) chr_count = 31;
    
    // Convert ASCII to UTF-16
    for (uint8_t i = 0; i < chr_count; i++) {
        desc_string_buffer[1 + i] = str[i];
    }
    
    // First byte is length (in bytes), second byte is string type
    desc_string_buffer[0] = (TUSB_DESC_STRING << 8) | (2 * chr_count + 2);
    
    return desc_string_buffer;
}

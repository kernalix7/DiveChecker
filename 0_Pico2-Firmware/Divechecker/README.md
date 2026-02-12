# DiveChecker Pico RP2350 Firmware

Pressure monitoring firmware for Raspberry Pi Pico 2 (RP2350).

## Features

- 100Hz internal sampling with BMP280 sensor
- Dual-core architecture for stable performance
- IIR + Averaging filter for smooth data
- USB MIDI SysEx protocol for cross-platform compatibility
- ECDSA device authentication
- Configurable output rate (4-50 Hz)

## Requirements

- Raspberry Pi Pico 2 (RP2350)
- BMP280 pressure sensor (I2C)
- Pico SDK

## Build

```bash
# Clone Pico SDK if not already installed
git clone https://github.com/raspberrypi/pico-sdk.git
cd pico-sdk
git submodule update --init

# Build firmware
cd 0_Pico2-Firmware/Divechecker
mkdir -p build && cd build
cmake -DPICO_SDK_PATH=/path/to/pico-sdk ..
make -j4
```

Output: `Divechecker.uf2`

## Flash

1. Hold BOOTSEL button while connecting Pico to USB
2. `RPI-RP2` drive will appear
3. Copy `Divechecker.uf2` to the drive
4. Pico will reboot automatically

## Circuit

```
Pico RP2350         BMP280 (I2C)
────────────        ────────────
3.3V         ────── VCC
GND          ────── GND
GP8 (SDA)    ────── SDA
GP9 (SCL)    ────── SCL
GP16         ────── WS2812 LED (status indicator)
```

## Communication Protocol

USB MIDI SysEx-based protocol for cross-platform compatibility.

SysEx format: `F0 7D 01 [cmd] [data...] F7`
- Manufacturer ID: `0x7D` (educational/development)
- Device ID: `0x01` (DiveChecker)

### Device → App
| Command | Hex | Description |
|---------|-----|-------------|
| Pressure | 0x01 | Delta pressure (7-bit encoded int32, hPa×1000) |
| Device Info | 0x02 | Serial, name, FW version, sensor status |
| Config | 0x03 | Output rate response |
| Auth Response | 0x04 | ECDSA signature (nibble-encoded) |
| Sensor Status | 0x05 | Sensor connection status |
| Over-range Alert | 0x06 | Sensor exceeded measurement range |
| Temperature | 0x07 | BMP280 temperature (int16×100) |
| Diagnostics | 0x08 | Uptime, error counts, I2C recovery |
| Full Config | 0x09 | All configurable parameters |
| ACK | 0x0A | Command acknowledgment (cmd + status) |

### App → Device
| Command | Hex | Description |
|---------|-----|-------------|
| Ping | 0x10 | Connection keepalive |
| Request Info | 0x20 | Request device info |
| Set Name | 0x21 | Set device name (PIN required) |
| Set Output Rate | 0x22 | Set output rate (4-50 Hz) |
| Reset Baseline | 0x23 | Reset pressure baseline |
| Get Config | 0x24 | Request full config dump |
| Set LED | 0x25 | Set LED brightness (0-100) |
| Reset Sensor | 0x26 | Manual sensor re-init |
| Factory Reset | 0x27 | Factory reset (PIN required) |
| Set Noise Floor | 0x28 | Set noise threshold (0-50) |
| Get Temperature | 0x29 | Request temperature |
| Enter Bootloader | 0x2A | Enter BOOTSEL mode (PIN required) |
| Get Diagnostics | 0x2B | Request runtime diagnostics |
| Set Oversampling | 0x2C | Set pressure oversampling (0-5) |
| Set IIR Filter | 0x2D | Set IIR filter coefficient (0-4) |
| Auth Challenge | 0x30 | ECDSA auth (64-char hex nonce) |
| Set PIN | 0x31 | Change PIN (old PIN + new PIN) |

## Key Generation

For ECDSA device authentication:

```bash
./generate_keys.sh
```

See [PRODUCTION_GUIDE.md](PRODUCTION_GUIDE.md) for production deployment.

## License

Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)

Licensed under Apache License 2.0 (Software) and CERN-OHL-S v2 (Hardware).

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
GP4 (SDA)    ────── SDA
GP5 (SCL)    ────── SCL
```

## Communication Protocol

USB MIDI SysEx-based protocol for cross-platform compatibility.

### MCU → App
| Message | Description |
|---------|-------------|
| SysEx Data | Pressure value (0.001 hPa resolution) |
| CFG:os,hz | Config response (oversampling, output rate) |
| PONG | Ping response |
| AUTH:OK/FAIL | Authentication result |

### App → MCU
| Command | Description |
|---------|-------------|
| P | Ping (connection check) |
| A:nonce | ECDSA authentication (hex nonce for signing) |
| R | Baseline reset |
| Oxx | Oversampling setting (1/2/4/8/16) |
| Fxx | Output rate setting (4-50 Hz) |
| C | Config request |
| B | BOOTSEL reboot (for firmware update) |

## Key Generation

For ECDSA device authentication:

```bash
./generate_keys.sh
```

See [PRODUCTION_GUIDE.md](PRODUCTION_GUIDE.md) for production deployment.

## License

Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)

Licensed under Apache License 2.0 (Software) and CERN-OHL-S v2 (Hardware).

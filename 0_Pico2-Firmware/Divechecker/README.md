# DiveChecker Pico RP2350 Firmware

Pressure monitoring firmware for Raspberry Pi Pico 2 (RP2350).

[🇰🇷 한국어](README.ko.md)

## Features

- 100Hz internal sampling with BMP280 sensor
- Extended measurement range: 300-1250 hPa
- Dual-core architecture for stable performance
- IIR + Averaging filter for smooth data
- Connection-decoupled sensor pipeline (sampling always on)
- Safe BOOTSEL entry (multicore lockout + interrupt disable)
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
| Soft Reboot | 0x2E | Soft reboot (PIN required) |
| Auth Challenge | 0x30 | ECDSA auth (64-char hex nonce) |
| Set PIN | 0x31 | Change PIN (old PIN + new PIN) |

## Key Generation

For ECDSA device authentication:

```bash
./generate_keys.sh
```

See [PRODUCTION_GUIDE.md](PRODUCTION_GUIDE.md) for production deployment.

---

## Security & Reliability Features

### Security

| Feature | Implementation |
|---------|----------------|
| **ECDSA P-256 Auth** | Challenge-response with 32-byte nonce |
| **Private Key in OTP** | Non-extractable one-time programmable storage |
| **Constant-Time Compare** | PIN verification prevents timing attacks |
| **Crypto Buffer Zeroing** | `mbedtls_platform_zeroize()` after use |
| **PIN Rate Limiting** | Exponential backoff (1s → 60s max) |
| **Persistent Lockout** | PIN failure count survives reboot |

### Reliability

| Feature | Implementation |
|---------|----------------|
| **Watchdog Timer** | 8s during boot, 2s during operation |
| **Sensor Auto-Recovery** | 5-second periodic retry on failure |
| **BOOTSEL Safe Shutdown** | Multicore lockout + interrupt disable before reset |
| **Flash CRC32** | Data integrity verification on load |
| **Wear Leveling** | 16-slot rotation in 4KB sector |
| **Flash Write Debounce** | 3-second delay prevents rapid writes |
| **Boot-Time Flash Compaction** | Erase-heavy wrap-around writes are moved to boot |
| **Lockout I2C Grace Window** | Transient NaN samples after flash lockout are ignored |
| **Continuous Sensor Pipeline** | Core 1 sampling/filtering runs even when app disconnects |
| **Connection Timeout Margin** | Keepalive timeout increased to 10s to tolerate UI jitter |
| **SysEx Timeout** | 500ms parser reset (all states) |
| **PIO Fallback** | Auto-switch to PIO1 if PIO0 unavailable |

### Performance

| Metric | Value |
|--------|-------|
| **Internal Sampling** | 100Hz (BMP280) |
| **Measurement Range** | 300-1250 hPa (extended beyond 1100 hPa datasheet spec) |
| **Output Rate** | 4-50Hz (configurable) |
| **Sensor-to-App Latency** | ~10ms |
| **Core 0** | USB MIDI + Command processing |
| **Core 1** | Sensor sampling + IIR filtering |
| **Inter-Core** | Lock-free FIFO queue |

### Memory Layout

```
Flash (4MB total)
├── 0x000000-0x3FEFFF: Application code + data
└── 0x3FF000-0x3FFFFF: Settings sector (4KB)
    └── 16 × 256-byte slots (wear leveling)
        ├── magic (4B)
        ├── PIN (5B)
        ├── name (25B)
        ├── config (8B)
        ├── reserved (210B)
        └── CRC32 (4B)
```

## License

Copyright (C) 2025-2026 Kim DaeHyun (kernalix7@kodenet.io)

Licensed under Apache License 2.0 (Software) and CERN-OHL-S v2 (Hardware).

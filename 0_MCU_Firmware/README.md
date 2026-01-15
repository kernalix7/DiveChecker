# DiveChecker MCU Firmware

MCU firmware for freediving equalization pressure measurement.

[🇰🇷 한국어](README.ko.md)

> **Currently Supported MCU**: ESP32-C3  
> **Planned Support**: RP2350

## Architecture (v4.0.0)

**Design Philosophy: Simple MCU + Smart App**

| Component | Role |
|-----------|------|
| **MCU** | Sensor reading + Raw data transmission (simple, stable) |
| **App** | All processing: filtering, analysis, display (flexible, updatable) |

### Key Features

- **160Hz raw output** - True sensor data, no MCU processing
- **IIR OFF** - No hardware filtering, preserves peak signal
- **~6ms latency** - Minimal delay for real-time response
- **Raw data preserved** - Can re-analyze with different algorithms

### Performance Specs

| Spec | Value |
|------|-------|
| Output Rate | 160 Hz |
| Latency | ~6 ms |
| Peak Timing Accuracy | ±3 ms |
| Raw Noise | ~1.3 Pa RMS |
| Data Rate | ~1.6 KB/s |
| Resolution | 0.001 hPa |

## Hardware (ESP32-C3)

- **ESP32-C3** development board
- **BMP280** I2C pressure sensor module

### Wiring (ESP32-C3)

```
ESP32-C3        BMP280
--------        ------
3.3V     ────── VCC
GND      ────── GND
GPIO8    ────── SDA
GPIO9    ────── SCL
```

## Serial Protocol

### Commands (App → MCU)

| Command | Description |
|---------|-------------|
| `P` | Ping - Connection check, returns `PONG` |
| `R` | Reset baseline to current pressure |
| `C` | Get config, returns `CFG:160` |

### Output (MCU → App)

| Prefix | Format | Description |
|--------|--------|-------------|
| `D:` | `D:1234` | Pressure delta (value × 0.001 hPa) |
| `CFG:` | `CFG:160` | Config response (sample rate) |
| `PONG` | `PONG` | Ping response |
| `INFO:` | `INFO:msg` | Info message |
| `ERR:` | `ERR:msg` | Error message |

### Data Flow

```
[BMP280] → 160Hz → [ESP32-C3] → USB Serial → [App]
   │                    │                       │
   └── Raw pressure     └── D:value            └── Filter/Display
```

## PlatformIO Setup (VS Code)

### 1. Install PlatformIO Extension

1. Open VS Code
2. Extensions tab (Ctrl+Shift+X)
3. Search "PlatformIO IDE" → Install
4. Restart VS Code

### 2. Open Project

```bash
# Open folder in VS Code
code 0_MCU_Firmware
```

Or **File > Open Folder** → Select `0_MCU_Firmware`

### 3. Build & Upload

PlatformIO toolbar (bottom status bar):

| Button | Function |
|--------|----------|
| ✓ | Build (compile) |
| → | Upload |
| 🔌 | Serial Monitor |
| 🧹 | Clean |

**Or shortcuts:**
- `Ctrl+Alt+B` - Build
- `Ctrl+Alt+U` - Upload
- `Ctrl+Alt+S` - Serial Monitor

### 4. Serial Monitor

After uploading, open Serial Monitor (🔌 button or `Ctrl+Alt+S`):

```
================================
  DiveChecker Firmware v4.0.0
  160Hz Raw Output Mode
================================

INFO:I2C GPIO8/9 @1MHz
INFO:I2C scan... 0x76 (BMP280)
INFO:Sensor init... OK
INFO:Test 1013.25 hPa 25.3 C

INFO:Output 160Hz raw data
INFO:IIR OFF (true raw signal)
INFO:Ready
================================
```

## Project Structure

```
0_MCU_Firmware/
├── platformio.ini      # PlatformIO configuration
├── src/
│   └── main.cpp        # Main firmware code
├── include/            # Header files (if needed)
├── lib/                # Custom libraries (if needed)
└── README.md
```

## Troubleshooting

### Upload Failed (ESP32-C3)

**Enter ESP32-C3 bootloader mode:**
1. Hold **BOOT** button
2. Press and release **RST** button
3. Release **BOOT** button
4. Retry upload

### I2C Not Detected

```
Scanning I2C bus...
  ⚠ No I2C devices found!
```

**Check:**
- VCC → 3.3V (not 5V!)
- GND → GND
- SDA → GPIO8
- SCL → GPIO9
- Jumper wire connections

### Using Different Pins

In `src/main.cpp`:

```cpp
// Default
#define I2C_SDA  8
#define I2C_SCL  9

// Alternative pins
#define I2C_SDA  4
#define I2C_SCL  5
```

## App Connection

1. Connect ESP32-C3 via USB
2. In app: **Settings > USB Serial**
3. Select device
4. App sends `P` (ping), MCU responds `PONG`
5. 160Hz data streaming begins!

## License

Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)

This firmware is dual-licensed:

| Component | License |
|-----------|---------|
| Software (firmware code) | [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) |
| Hardware (circuit design) | [CERN-OHL-S v2](https://ohwr.org/cern_ohl_s_v2.txt) |

See the project root [LICENSE](../LICENSE) file for details.

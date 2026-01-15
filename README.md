<div align="center">

# 🌊 DiveChecker

### Freediving Equalizing Pressure Monitor

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.10.4+-02569B?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Linux%20%7C%20Windows%20%7C%20macOS%20%7C%20Web-lightgrey)]()

**Real-time pressure monitoring system for freediving equalization training**

[Features](#-features) • [Quick Start](#-quick-start) • [Architecture](#-architecture) • [Hardware](#-hardware) • [Contributing](#-contributing)

[🇰🇷 한국어](README.ko.md)

</div>

---

## 🎯 Overview

DiveChecker is a professional monitoring system that helps freedivers effectively practice **equalization (ear pressure equalization)** training.

Using a pressure sensor connected to a mouthpiece, it precisely measures subtle pressure changes (-10 to +25 hPa) when blowing or sucking through the mouth with **100Hz internal sampling + configurable output rate (4-50Hz)**, and visualizes them in real-time graphs.

### Architecture (v4.5.0)

**Smart MCU + Intelligent App**

```
[BME280/BMP280] → 100Hz → [MCU] → USB Serial → [Flutter App]
        │                   │                        │
        └── Raw sensor      └── IIR + Averaging     └── All logic:
            data               Firmware filtering       - Display
                               Output: 4-50Hz           - Analysis
                                                        - Storage
```

| Component | Role |
|-----------|------|
| **MCU** | Sensor reading + IIR/Averaging filter + Configurable output rate |
| **App** | Display, analysis, storage (flexible, OTA updatable) |

### Supported Hardware

| MCU | Sensor | Status |
|-----|--------|--------|
| **ESP32-C3** | BME280 | ✅ Fully supported |
| **Pico RP2350** | BMP280 | ✅ Fully supported |

### Why DiveChecker?

| Problem | DiveChecker Solution |
|---------|---------------------|
| Cannot verify if equalization is correct | Instant feedback with real-time pressure graphs |
| Difficult to measure training effectiveness | Objective evaluation with session recording + peak analysis |
| Difficult to practice consistent technique | Advanced analysis with rhythm score, fatigue index, etc. |

---

## ✨ Features

### 📊 Real-time Pressure Monitoring

<table>
<tr>
<td width="50%">

**Sensor Specs**
- **Sampling**: 100Hz internal → 4-50Hz output (configurable)
- **Firmware Filtering**: IIR x2 + Averaging
- **Latency**: ~10ms (sensor to app)
- **Pressure Range**: -10 to +25 hPa (negative/positive)
- **Resolution**: 0.001 hPa (0.0016 hPa sensor resolution)

</td>
<td width="50%">

**Visualization**
- Real-time line chart (fl_chart)
- Pinch zoom / drag pan gestures
- 30-second sliding window
- Max/Avg pressure real-time display

</td>
</tr>
</table>

### 🔬 Advanced Peak Analysis

Detailed equalization quality analysis after measurement:

| Metric | Description |
|--------|-------------|
| **Rhythm Score** | Peak interval consistency (CV-based) |
| **Pressure Score** | Peak intensity uniformity |
| **Technique Score** | Rise/fall time, peak width analysis |
| **Fatigue Index** | Pressure decrease trend during session |
| **Overall Grade** | S~F grade overall evaluation |

**Peak Classification**: Weak / Moderate / Strong intensity classification

### 💾 Data Management

- **SQLite / IndexedDB**: Platform-specific auto-selection (Native/Web)
- **Session Recording**: Date, time, max/avg pressure, sample rate, notes
- **Graph Notes**: Add notes at specific points (numbered markers)
- **Backup/Restore**: JSON-based data export/import
- **Cursor Indicator**: Touch position with time/pressure display

### 🌐 Multi-language Support

- 🇺🇸 English
- 🇰🇷 Korean

### ⚙️ Calibration & Configuration

- **Atmospheric Calibration**: 3-second sample collection then baseline setting
- **Output Rate Control**: 4-50Hz via F command
- **Oversampling Adjustment**: 1x ~ 16x (MCU command)

---

## 📱 Screens

| Screen | Description |
|--------|-------------|
| 🏠 **Home** | Device connection, real-time pressure display, calibration |
| 📈 **Measurement** | Live graph, Start/Stop/Pause, session recording |
| 📋 **History** | Session list → Graph detail → Peak analysis |
| ⚙️ **Settings** | Language, backup/restore, device settings, firmware update |

---

## 🚀 Quick Start

### Prerequisites

| Component | Version | Notes |
|-----------|---------|-------|
| Flutter SDK | 3.10.4+ | `flutter --version` |
| PlatformIO | Latest | Install VSCode extension (for ESP32) |
| Pico SDK | Latest | For RP2350 firmware |
| USB Cable | - | Data transfer capable cable |

### 1. Install and Run App

```bash
git clone https://github.com/kernalix7/divechecker.git
cd divechecker/_0_DiveChecker-APP

flutter pub get
flutter gen-l10n
flutter run -d linux    # or android, windows, macos
```

### 2. Upload Firmware

**For ESP32-C3:**
```bash
# Open 0_ESP32_Firmware folder in VSCode
# PlatformIO: Click Upload or Ctrl+Alt+U
```

**For Pico RP2350:**
```bash
# Build with Pico SDK
cd 0_Pico2-Firmware
mkdir build && cd build
cmake .. && make
# Copy .uf2 to Pico in BOOTSEL mode
```

### 3. Connect and Measure

1. Connect MCU to PC/Android via USB
2. App Home → **CONNECT DEVICE**
3. Select device → Connection complete
4. **Calibrate** (sensor stabilization)
5. Measurement tab → **START**

---

## 🏗️ Architecture

```
00_Divechecker/
│
├── 📱 _0_DiveChecker-APP/          # Flutter cross-platform app
│   ├── lib/
│   │   ├── main.dart               # App entry point
│   │   ├── constants/              # Theme, colors, app config
│   │   ├── core/                   # DB interface
│   │   ├── l10n/                   # Localization (EN/KO)
│   │   ├── models/                 # PressureData, GraphNote
│   │   ├── providers/              # State management (Provider)
│   │   │   ├── serial_provider.dart      # USB Serial connection
│   │   │   ├── measurement_controller.dart # Measurement logic
│   │   │   └── session_repository.dart   # Session cache
│   │   ├── screens/
│   │   │   ├── home_screen.dart          # Connection & status
│   │   │   ├── measurement_screen.dart   # Real-time measurement
│   │   │   ├── history_screen.dart       # Session list
│   │   │   ├── graph_detail_page.dart    # Detailed graph + cursor
│   │   │   ├── peak_analysis_page.dart   # Peak analysis
│   │   │   ├── device_settings_screen.dart   # Device config
│   │   │   └── firmware_update_screen.dart   # OTA update
│   │   ├── services/
│   │   │   ├── unified_database_service.dart  # DB integration
│   │   │   ├── backup_service.dart            # Backup/restore
│   │   │   └── update_service.dart            # Firmware update
│   │   ├── utils/
│   │   │   └── peak_analyzer.dart        # Peak analysis algorithms
│   │   └── widgets/                # UI components
│   └── pubspec.yaml
│
├── 🔧 0_ESP32_Firmware/            # ESP32-C3 PlatformIO project
│   ├── src/main.cpp
│   │   ├── 100Hz internal sampling (BME280)
│   │   ├── IIR x2 + Averaging filter
│   │   ├── 4-50Hz configurable output
│   │   └── Text protocol (D:, CFG:, PONG, A:)
│   └── platformio.ini
│
├── 🔧 0_Pico2-Firmware/            # Pico RP2350 project
│   ├── main.cpp
│   │   ├── 100Hz internal sampling (BMP280)
│   │   ├── Dual-core architecture
│   │   ├── IIR x2 + Averaging filter
│   │   ├── 4-50Hz configurable output
│   │   └── Text protocol (D:, CFG:, PONG, A:)
│   └── CMakeLists.txt
│
├── 📐 0_CAD/                       # Hardware design (FreeCAD)
│
└── 📜 LICENSE                      # Apache 2.0 + CERN-OHL-S v2
```

### Communication Protocol

```
MCU → App (USB Serial 115200bps)
──────────────────────────────────
D:1234     Pressure data (x1000, e.g., 1.234 hPa)
CFG:16,25  Config (oversampling, output rate Hz)
PONG       Ping response
INFO:msg   Info message
ERR:msg    Error message

App → MCU
──────────────────────────────────
P          Ping (connection check)
A:xxxx     Authentication (4-digit code)
R          Baseline reset
O16        Oversampling setting (1/2/4/8/16)
F25        Output rate setting (4-50 Hz)
C          Config request
```

---

## 🔧 Hardware

### Supported MCUs

| MCU | Sensor | Status | Notes |
|-----|--------|--------|-------|
| **ESP32-C3** | BME280 | ✅ Supported | Built-in USB CDC, low power |
| **Pico RP2350** | BMP280 | ✅ Supported | Dual-core, high performance |

### Circuit Configuration

**ESP32-C3 + BME280:**
```
ESP32-C3            BME280 (I2C)
────────────        ────────────
3.3V         ────── VCC
GND          ────── GND
GPIO8 (SDA)  ────── SDA
GPIO9 (SCL)  ────── SCL
```

**Pico RP2350 + BMP280:**
```
Pico RP2350         BMP280 (I2C)
────────────        ────────────
3.3V         ────── VCC
GND          ────── GND
GP4 (SDA)    ────── SDA
GP5 (SCL)    ────── SCL
```

### Sensor Requirements

- **Pressure Sensor**: BME280 (ESP32) or BMP280 (Pico)
- **Sensitivity**: ±0.01 hPa or better recommended
- **Mouthpiece Connection**: Connect to sensor via tube

> 📌 See [0_ESP32_Firmware/README.md](0_ESP32_Firmware/README.md) or [0_Pico2-Firmware/README.md](0_Pico2-Firmware/README.md) for detailed setup

---

## 🔮 Roadmap

### ✅ v1.0.0 Completed
- [x] 🎯 **Real-time pressure monitoring** - 100Hz internal + configurable output
- [x] 📊 **Peak analysis** - Rhythm, pressure, technique scores
- [x] 💾 **Session management** - Record, review, notes
- [x] 🌐 **Multi-language** - English, Korean
- [x] 🔧 **Device settings** - Output rate, oversampling control
- [x] 🔄 **Firmware update** - OTA update support
- [x] 🔐 **Authentication** - 4-digit PIN protection

### 🔜 Next Goals
- [ ] 🫁 **Lung capacity measurement** - Max inhale/exhale volume check
- [ ] 🧘 **CO₂ table trainer** - Carbon dioxide tolerance training
- [ ] 💨 **O₂ table trainer** - Hypoxia adaptation training
- [ ] 📤 **CSV export** - External analysis tool integration
- [ ] 🌐 **Cloud sync** - Firebase-based backup
- [ ] 🎯 **Training programs** - Guided sessions (8-week course, etc.)

---

## 🤝 Contributing

Contributions are welcome!

```bash
# After forking
git clone https://github.com/YOUR_USERNAME/divechecker.git
cd divechecker/_0_DiveChecker-APP
flutter pub get
flutter run
```

See [CONTRIBUTING.md](_0_DiveChecker-APP/CONTRIBUTING.md) for details.

---

## 📄 License

This project is dual-licensed:

| Component | License | Scope |
|-----------|---------|-------|
| **Software** | [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) | App, firmware code |
| **Hardware** | [CERN-OHL-S v2](https://ohwr.org/cern_ohl_s_v2.txt) | Circuits, CAD designs |

See the [LICENSE](LICENSE) file for details.

---

<div align="center">

**Made with ❤️ for the Freediving Community**

[⬆ Back to Top](#-divechecker)

</div>
# DiveChecker Flutter App

Cross-platform pressure monitoring app for freediving equalization training.

[🇰🇷 한국어](README.ko.md)

## Supported Platforms

| Platform | Status | Connection |
|----------|--------|------------|
| Android | ✅ Supported | USB MIDI |
| iOS | ✅ Supported | USB MIDI |
| Linux | ✅ Supported | USB MIDI |
| Windows | ✅ Supported | USB MIDI |
| macOS | ✅ Supported | USB MIDI |
| Web | ⚠️ Limited | Web MIDI API |

## Requirements

- Flutter SDK 3.10.4+
- Dart SDK 3.0+
- DiveChecker V1 device (RP2350 Pico2)

## Getting Started

```bash
# Install dependencies
flutter pub get

# Generate localization
flutter gen-l10n

# Run
flutter run -d linux    # or android, windows, macos, ios
```

## Build

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Linux
flutter build linux --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Web
flutter build web --release
```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── config/                      # Theme configuration
├── constants/                   # Constants definition
├── core/                        # DB interface
│   └── database/
├── l10n/                        # Localization (EN/KO)
├── models/                      # Data models
├── providers/                   # State management (Provider)
│   ├── midi_provider.dart       # USB MIDI connection
│   ├── serial_provider.dart     # Alias for midi_provider
│   ├── measurement_controller.dart # Measurement logic
│   ├── session_repository.dart  # Session cache
│   ├── settings_provider.dart   # App settings
│   └── locale_provider.dart     # Language settings
├── screens/                     # Screens
│   ├── home_screen.dart         # Home (connection status)
│   ├── measurement_screen.dart  # Real-time measurement
│   ├── history_screen.dart      # Session history
│   ├── graph_detail_page.dart   # Detailed graph
│   ├── peak_analysis_page.dart  # Peak analysis
│   ├── settings_screen.dart     # Settings
│   └── serial_device_screen.dart # Device selection
├── services/                    # Services
│   ├── unified_database_service.dart # DB integration
│   └── backup_service.dart      # Backup/restore
├── security/                    # Security
│   └── device_authenticator.dart # ECDSA device auth
├── utils/                       # Utilities
│   ├── chart_utils.dart         # Chart helper functions
│   └── peak_analyzer.dart       # Peak analysis algorithms
└── widgets/                     # UI components
    ├── analysis/                # Analysis widgets
    ├── common/                  # Common widgets
    ├── home/                    # Home widgets
    ├── measurement/             # Measurement widgets
    └── settings/                # Settings widgets
```

## Key Features

### 🔌 USB MIDI Communication
- Cross-platform USB MIDI support
- ECDSA device authentication
- SysEx-based data protocol
- Configurable output rate (4-50 Hz)

### 📊 Real-time Pressure Monitoring
- 100Hz internal sampling, configurable output (default 8Hz)
- Real-time line chart (fl_chart)
- Pinch zoom / drag pan gestures
- Hz-aligned grid lines

### 🔬 Peak Analysis
- Rhythm score (peak interval consistency)
- Pressure score (intensity uniformity)
- Technique score (rise/fall time)
- Fatigue index
- Overall grade (S, A, B, C, D, F)

### 💾 Data Management
- SQLite (Native) / IndexedDB (Web)
- Session recording and graph notes
- JSON backup/restore

### 🌐 Multi-language Support
- 🇺🇸 English
- 🇰🇷 Korean

## Testing

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/
```

## License

Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

See the [LICENSE](../LICENSE) file in the project root for details.

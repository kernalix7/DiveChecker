# Changelog

**English** | [한국어](docs/CHANGELOG.ko.md)

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project aims to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [8.1.0] — 2026-03-19

### Added
- macOS App Store Connect auto-upload in CI/CD pipeline
- macOS ExportOptions.plist for signed distribution

### Changed
- Optimized chart rendering with single-pass min/max calculation
- Replaced Consumer with Selector in measurement screen
- Aligned all docs and app constants with firmware source of truth (100Hz, 300-1250 hPa, 30s keepalive, 256-byte SysEx)
- Protocol table updated to SysEx hex command table
- Firmware tree updated to actual file names
- Moved README.ko.md to docs/ per bilingual convention

### Fixed
- Mounted check and error handling in graph notes loading
- StreamController cleanup in MidiProvider shutdown
- Reset MIDI data listener on device switch to prevent staircase graph
- CAD README: BMP280-5V corrected to BME280-5V
- App README: Dart SDK 3.0+ corrected to 3.10+, removed nonexistent integration_test/
- Graph detail page maxY clamp raised from 100 to 200

### Security
- Hardened .gitignore: added .p12, .p8, .env, provisioning profile rules
- Removed tmp-igbkp/ from git tracking

## [8.0.1] — 2026-03-19

### Fixed
- Reset MIDI data listener on device switch to prevent staircase graph

## [8.0.0] — 2026-03-18 (RTM 8.0)

### Added
- GitHub standard files: SECURITY, CONTRIBUTING, CODE_OF_CONDUCT, CHANGELOG (en+ko)
- GitHub templates: PR template, bug report, feature request issue templates
- Bilingual documentation structure (docs/ directory with Korean translations)

### Fixed
- CONTRIBUTING.md link in root README now points to correct location

## [7.2.0] — 2026-03-12 (RTM 7.2)

### Added
- Multi-language support: Japanese (ja), Simplified Chinese (zh), Traditional Chinese (zh_TW)
- Locale provider enhancement with country code support and SharedPreferences persistence

### Fixed
- Graph note pressure display: fixed timestamp used as array index, now uses nearest-point lookup
- Statistics duration calculation: fixed 10x incorrect value
- Division by zero guards for skewness/kurtosis, trend graph slope, and change rate
- Peak analyzer RangeError when `checkStart` exceeds `lastIdx`
- GraphNote type safety with explicit casts in `fromMap()` factory
- SessionRepository dispose guard to prevent `notifyListeners()` after dispose

### Security
- Firmware `strcpy` → `strncpy`: replaced 3 unsafe calls with bounded copies
- ECDSA error counter increment on signature failure for diagnostics

### Changed
- Replaced remaining hardcoded strings with l10n in measurement, history, and settings screens
- Updated web branding (index.html, manifest.json)

## [7.1.1] — 2026-03-11

### Fixed
- Minor stability improvements and bug fixes

## [7.1.0] — 2026-03-10

### Added
- Session delete button in history screen
- Fullscreen chart view for real-time measurement

## [6.0.0] — 2026-03-03 (RTM 6.0)

### Fixed
- Root cause stabilization: firmware Core 1 sampling no longer depends on app connection state
- Reconnect baseline preservation: removed implicit baseline reset on transient reconnect
- Flash lockout recovery guard with I2C grace window
- Keepalive resilience: increased timeout margins, tolerant to transient MIDI stream errors
- Cross-core memory ordering: added `__dmb()` barriers for baseline and lockout flags

## [4.0.0] — 2026-02-26 (RTM 4.0)

### Security
- Backup integrity verification with checksum validation
- Enhanced flash CRC validation with magic field check
- INT32_MIN safe encoding in MIDI SysEx pressure encoding
- Memory barriers (`__dmb()`) for cross-core output rate changes

### Fixed
- Peak analysis time calculation (was using `*0.25` instead of `/1000.0`)
- GraphNote class collision between models and database layer
- USB serial number correctly set from chip unique ID
- LED initialization guard to prevent infinite PIO blocking

### Changed
- Monitor screen: timer-based UI updates (10Hz) instead of per-sample setState
- Peak analyzer: O(1) set lookup replaces O(n) List.contains
- USB enumeration: reduced wait loop from 500ms to 10ms intervals
- SerialProvider removed; all code uses MidiProvider directly
- Linux binary/app ID unified to `io.kodenet.divechecker`
- macOS bundle ID unified to `io.kodenet.divechecker`

## [3.0.0] — 2026-02-19 (RTM 3.0)

### Security
- Soft reboot PIN protection
- Persistent PIN lockout surviving device reboot
- Flash CRC32 validation on settings load
- Crypto buffer zeroing after authentication
- Constant-time hex validation against timing attacks

### Added
- Auto-reconnect with exponential backoff (2/4/6s, max 3 attempts)
- Sensor auto-recovery: 5-second periodic retry on BMP280 I2C failure
- Early watchdog: 8s boot timeout, 2s operation timeout
- SysEx timeout parser reset from any state after 500ms
- Dynamic Y-axis auto-scaling for measurement and monitor charts
- Extended measurement range: BMP280 max raised to 1250 hPa

### Fixed
- FIFO handshake bug causing stale status reads
- Concurrent sensor reinit race condition
- mbedTLS context leak before re-initialization
- Measurement disconnect crash during save dialog
- BOOTSEL ALSA crash with safe shutdown sequence

## [1.2.0] — 2026-01

### Changed
- Mobile chart performance: reduced LOD points, added RepaintBoundary, disabled animations
- LOD system simplified: consolidated to single `_lodData`
- Removed ESP32 firmware; project now Pico RP2350 only

## [1.1.0] — 2026-01-08

### Added
- USB MIDI SysEx communication protocol
- ECDSA P-256 device authentication
- Viewport-based chart rendering with LTTB-like downsampling
- Pinch-to-zoom and pan gestures
- Incremental statistics (O(1) per update)

## [1.0.0] — 2025-12-17

### Added
- Initial release of DiveChecker
- Real-time pressure monitoring with 100Hz internal sampling
- Interactive pressure graphs with zoom and pan
- SQLite database for local data persistence
- USB MIDI device connection support
- Session history with analytics
- Cross-platform support (Android, iOS, Linux, Windows, macOS)

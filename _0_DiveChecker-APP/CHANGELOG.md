# Changelog

All notable changes to DiveChecker will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

---

## [8.1.0] - 2026-03-19

### Added
- macOS App Store Connect auto-upload in CI/CD pipeline
- macOS ExportOptions.plist for signed distribution

### Changed
- Optimized chart rendering with single-pass min/max calculation
- Replaced Consumer with Selector in measurement screen for reduced rebuilds
- Aligned all docs and app constants with firmware source of truth (100Hz, 300-1250 hPa, 30s timeout, 256-byte SysEx buffer)
- Renamed MeasurementConfig.minPressure/maxPressure to sensorMinPressure/sensorMaxPressure (300/1250 hPa)
- Graph detail page maxY clamp raised from 100 to 200

### Fixed
- Added mounted check and error handling in graph notes loading
- StreamController cleanup in MidiProvider shutdown
- Reset MIDI data listener on device switch to prevent staircase graph

### Security
- Hardened .gitignore: added .p12, .p8, .env, provisioning profile rules
- Removed tmp-igbkp/ from git tracking

---

## [8.0.1] - 2026-03-19

### Fixed
- Reset MIDI data listener on device switch to prevent staircase graph pattern
- Properly disconnect previous device before connecting a new one

---

## [8.0.0] - 2026-03-18 (RTM 8.0)

### Added
- GitHub standard files: SECURITY, CONTRIBUTING, CODE_OF_CONDUCT, CHANGELOG (en+ko)
- GitHub templates: PR template, bug report, feature request issue templates
- Bilingual documentation structure (docs/ directory)

### Fixed
- CONTRIBUTING.md link corrected in root README

---

## [7.2.0] - 2026-03-12 (RTM 7.2)

### Added
- **Multi-language Support (5 Languages)** - Added Japanese (ja), Simplified Chinese (zh), Traditional Chinese (zh_TW) alongside existing English and Korean
- **Locale Provider Enhancement** - Country code support for zh_TW locale with proper SharedPreferences persistence

### Fixed
- **Graph Note Pressure Display** - Fixed critical bug where `note.x` (millisecond timestamp) was incorrectly used as array index; now uses nearest-point lookup
- **Statistics Duration Calculation** - Fixed duration showing 10x incorrect value (divided by 100 instead of 1000)
- **Division by Zero Guards** - Added stdDev > 0 checks for skewness/kurtosis calculations in statistics dashboard
- **Trend Graph Slope** - Fixed division by zero when all X values are identical in linear regression
- **Trend Graph Change Rate** - Fixed division by zero when first trend line Y value is zero
- **Peak Analyzer RangeError** - Fixed `checkStart` exceeding `lastIdx` causing RangeError in peak detection
- **GraphNote Type Safety** - Added explicit type casts (`as int?`, `as num`, `as String`) in `fromMap()` factory
- **SessionRepository Dispose Guard** - Added `_isDisposed` flag to prevent `notifyListeners()` after dispose

### Security
- **Firmware strcpy -> strncpy** - Replaced 3 unsafe `strcpy()` calls with bounded `strncpy()` in device settings
- **ECDSA Error Counter** - Added error counter increment on signature failure for diagnostics

### Changed
- **Hardcoded Strings -> l10n** - Replaced remaining hardcoded strings in measurement, history, and settings screens
- **Web Branding** - Updated web/index.html and web/manifest.json with DiveChecker branding

---

## [7.1.1] - 2026-03-11 (RTM 7.1.1)

### Fixed
- Minor stability improvements and bug fixes

---

## [7.1.0] - 2026-03-10 (RTM 7.1.0)

### Added
- **Session Delete Button** - Added delete functionality to history screen
- **Fullscreen Chart View** - Added fullscreen chart view for real-time measurement

---

## [6.0.0] - 2026-03-03 (RTM 6.0)

### Fixed
- **Root Cause Stabilization (Sensor Pipeline)** - Firmware Core 1 sampling/filtering no longer depends on app connection state; reconnection no longer cold-starts sensor averaging/IIR pipeline.
- **Reconnect Baseline Preservation** - Removed implicit baseline reset on transient reconnect to prevent sudden 0.0-style pressure re-zero events.
- **Flash Lockout Recovery Guard** - Added post-lockout I2C grace window and raised over-range trigger threshold to avoid false sensor reset loops after settings writes.
- **Keepalive Resilience** - Increased firmware/app timeout margins and made MIDI stream errors tolerant to transient bursts before forcing disconnect.
- **Cross-Core Memory Ordering (Firmware)** - Added missing `__dmb()` barriers for baseline flag write ordering (Core 1) and baseline reset visibility (Core 0 -> Core 1); added pre-write barrier for lockout grace counter to guarantee Core 1 sees the updated value immediately after flash lockout ends.

---

## [4.0.0] - 2026-02-26 (RTM 4.0)

### Security
- **Backup Integrity Verification** - Checksum validation prevents tampered backup restoration
- **Enhanced Flash CRC Validation** - Legacy CRC acceptance now requires magic field verification
- **INT32_MIN Safe Encoding** - Fixed undefined behavior in MIDI SysEx pressure encoding
- **Memory Barrier for Cross-Core** - Proper `__dmb()` barriers for output rate changes

### Fixed
- **Peak Analysis Time Calculation** - Fixed incorrect time display (was using `*0.25` instead of `/1000.0`)
- **GraphNote Class Collision** - Resolved duplicate class names between models and database layer
- **USB Serial Number** - Firmware now correctly sets USB descriptor serial from chip ID
- **LED Init Safety** - Added initialization guard to prevent infinite PIO blocking on init failure

### Changed
- **Monitor Screen Optimization** - Timer-based UI updates (10Hz) instead of per-sample setState (up to 50Hz)
- **Peak Analyzer Set Lookup** - O(1) peak index lookup replaces O(n) List.contains
- **USB Enumeration Speed** - Reduced USB wait loop from 500ms to 10ms intervals
- SerialProvider removed; all code uses MidiProvider directly
- Linux binary/app ID unified to `io.kodenet.divechecker`
- macOS bundle ID unified to `io.kodenet.divechecker`

---

## [3.0.0] - 2026-02-19 (RTM 3.0)

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

---

## [1.2.0] - 2026-01-XX

### Changed
- Mobile chart performance: reduced LOD points, added RepaintBoundary, disabled animations
- LOD system simplified: consolidated to single `_lodData`
- Removed ESP32 firmware; project now Pico RP2350 only

---

## [1.1.0] - 2026-01-08

### Added
- USB MIDI SysEx communication protocol
- ECDSA P-256 device authentication
- Viewport-based chart rendering with LTTB-like downsampling
- Pinch-to-zoom and pan gestures
- Incremental statistics (O(1) per update)

---

## [1.0.0] - 2025-12-17

### Added
- Initial release of DiveChecker
- Real-time pressure monitoring with 100Hz internal sampling
- Interactive pressure graphs with zoom and pan controls
- Note-taking system with time-specific annotations
- SQLite database for local data persistence
- USB MIDI device connection support
- Session history with detailed analytics
- Material Design 3 with GitHub color scheme
- Cross-platform support (Android, iOS, Linux, Windows, macOS)

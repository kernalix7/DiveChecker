# Changelog

All notable changes to DiveChecker will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

---

## [8.1.0] - 2026-03-19

### Added
- macOS App Store Connect auto-upload in CI/CD pipeline

### Fixed
- Graph detail page: mounted check and error handling in graph notes loading
- Chart rendering: single-pass min/max calculation in graph detail and fullscreen chart
- Measurement screen: Selector instead of Consumer for reduced rebuild scope
- MidiProvider: stream controller cleanup in shutdown, auth timeout guard

### Security
- `.gitignore`: added `.p12`, `.pfx`, `.p8`, `.mobileprovision`, `.provisionprofile`, `.env` rules

---

## [8.0.0] - 2026-03-18 (RTM 8.0)

### Added
- GitHub standard files: SECURITY, CONTRIBUTING, CODE_OF_CONDUCT, CHANGELOG (en+ko)
- GitHub templates: PR template, bug report, feature request issue templates
- Bilingual documentation structure (docs/ directory)

### Fixed
- Sampling rate documentation corrected from 100Hz to 160Hz across all READMEs
- CONTRIBUTING.md link corrected in root README

---

## [7.2.0] - 2026-03-12 (RTM 7.2)

### Added
- 🌐 **Multi-language Support (5 Languages)** - Added Japanese (ja), Simplified Chinese (zh), Traditional Chinese (zh_TW) alongside existing English and Korean
- 🌐 **Locale Provider Enhancement** - Country code support for zh_TW locale with proper SharedPreferences persistence

### Fixed
- 🐛 **Graph Note Pressure Display** - Fixed critical bug where `note.x` (millisecond timestamp) was incorrectly used as array index; now uses nearest-point lookup
- 🐛 **Statistics Duration Calculation** - Fixed duration showing 10x incorrect value (divided by 100 instead of 1000)
- 🐛 **Division by Zero Guards** - Added stdDev > 0 checks for skewness/kurtosis calculations in statistics dashboard
- 🐛 **Trend Graph Slope** - Fixed division by zero when all X values are identical in linear regression
- 🐛 **Trend Graph Change Rate** - Fixed division by zero when first trend line Y value is zero
- 🐛 **Peak Analyzer RangeError** - Fixed `checkStart` exceeding `lastIdx` causing RangeError in peak detection
- 🐛 **GraphNote Type Safety** - Added explicit type casts (`as int?`, `as num`, `as String`) in `fromMap()` factory
- 🐛 **SessionRepository Dispose Guard** - Added `_isDisposed` flag to prevent `notifyListeners()` after dispose

### Security
- 🔒 **Firmware strcpy → strncpy** - Replaced 3 unsafe `strcpy()` calls with bounded `strncpy()` in device settings
- 🔒 **ECDSA Error Counter** - Added error counter increment on signature failure for diagnostics

### Changed
- 🌐 **Hardcoded Strings → l10n** - Replaced remaining hardcoded strings in measurement, history, and settings screens
- 📱 **Web Branding** - Updated web/index.html and web/manifest.json with DiveChecker branding

---

## [7.1.1] - 2026-03-11 (RTM 7.1.1)

### Fixed
- 🔧 Minor stability improvements and bug fixes

---

## [7.1.0] - 2026-03-10 (RTM 7.1.0)

### Added
- 📊 **Session Delete Button** - Added delete functionality to history screen
- 📈 **Fullscreen Chart View** - Added fullscreen chart view for real-time measurement

---

## [6.0.0] - 2026-03-03 (RTM 6.0)

### Fixed
- 🔧 **Root Cause Stabilization (Sensor Pipeline)** - Firmware Core 1 sampling/filtering no longer depends on app connection state; reconnection no longer cold-starts sensor averaging/IIR pipeline.
- 🔧 **Reconnect Baseline Preservation** - Removed implicit baseline reset on transient reconnect to prevent sudden 0.0-style pressure re-zero events.
- 🔧 **Flash Lockout Recovery Guard** - Added post-lockout I2C grace window and raised over-range trigger threshold to avoid false sensor reset loops after settings writes.
- 🔧 **Keepalive Resilience** - Increased firmware/app timeout margins and made MIDI stream errors tolerant to transient bursts before forcing disconnect.
- 🔧 **Cross-Core Memory Ordering (Firmware)** - Added missing `__dmb()` barriers for baseline flag write ordering (Core 1) and baseline reset visibility (Core 0 → Core 1); added pre-write barrier for lockout grace counter to guarantee Core 1 sees the updated value immediately after flash lockout ends.

### Planned Features (Next Release)
- ⏸️ Monitor tab pause button
- 💾 Monitor specific range save
- ⏱️ Lung volume/capacity measurement
- 🫁 CO2 tolerance trainer
- 💨 O2 optimization exercises
- 📤 Data export (CSV/JSON)
- 📊 Advanced analytics and trends
- 🌐 Cloud sync capability
- 🎯 Guided training programs
- 📱 iOS-specific optimizations
- 🔔 Notification support

---

## [4.0.0] - 2026-02-26 (RTM 4.0)

### Security Enhancements
- 🔐 **Backup Integrity Verification** - Checksum validation prevents tampered backup restoration
- 🛡️ **Enhanced Flash CRC Validation** - Legacy CRC acceptance now requires magic field verification
- 🔒 **INT32_MIN Safe Encoding** - Fixed undefined behavior in MIDI SysEx pressure encoding
- 🔑 **Memory Barrier for Cross-Core** - Proper `__dmb()` barriers for output rate changes

### Bug Fixes (Critical)
- 🐛 **Peak Analysis Time Calculation** - Fixed incorrect time display (was using `*0.25` instead of `/1000.0`)
- 🐛 **GraphNote Class Collision** - Resolved duplicate class names between models and database layer
- 🐛 **USB Serial Number** - Firmware now correctly sets USB descriptor serial from chip ID
- 🐛 **LED Init Safety** - Added initialization guard to prevent infinite PIO blocking on init failure

### Performance Improvements
- ⚡ **Monitor Screen Optimization** - Timer-based UI updates (10Hz) instead of per-sample setState (up to 50Hz)
- ⚡ **Peak Analyzer Set Lookup** - O(1) peak index lookup replaces O(n) List.contains
- ⚡ **Floating-Point Drift Prevention** - Periodic sum recalculation every 100 samples
- ⚡ **USB Enumeration Speed** - Reduced USB wait loop from 500ms to 10ms intervals

### Stability Improvements
- 🔧 **Widget State Isolation** - GraphDetailPage no longer mutates parent widget properties
- 🔧 **Session Save Error Handling** - User-facing error feedback on database save failure
- 🔧 **Graph Note Input Validation** - 500 character limit with trimming on note input
- 🔧 **Dead Code Removal** - Removed unused gradient computation from PeakAnalyzer

### Platform Fixes
- 🖥️ **Linux Binary Name** - Changed from `_0_flutter_app` to `divechecker`
- 🖥️ **Linux Application ID** - Changed from `com.example` to `io.kodenet.divechecker`
- 🍎 **macOS Bundle ID** - Unified to `io.kodenet.divechecker` (was `com.divechecker.app`)
- 🍎 **macOS Copyright** - Updated to match project license

### Code Quality & Refactoring
- 🧹 **SerialProvider Removal** - Eliminated legacy compatibility layer; all code now uses `MidiProvider` directly
- 🧹 **Legacy Naming Cleanup** - Renamed `serial_device_screen.dart` → `device_selection_screen.dart`, updated class and file references
- 🧹 **Variable Naming Consistency** - Renamed all `_serialProvider`/`serial` variables to `_midiProvider`/`midi` across 12+ files
- 🧹 **Dead Parameter Removal** - Removed unused `settingsProvider` parameter from `MeasurementController`
- 🧹 **Dead Code Removal** - Removed empty condition block in `HomeScreen._openDeviceSelection()`
- 📝 **Pressure Unit Consistency** - Fixed hardcoded "hPa" in graph note detail view
- 📝 **Explicit Includes** - Added missing `<string.h>` in USB descriptors

### Firmware v6.0.0 Changes
- USB serial number correctly set from chip unique ID
- LED initialization failure no longer causes infinite PIO blocking
- Memory barriers (`__dmb()`) for cross-core output rate synchronization
- Strengthened flash CRC verification with magic field check
- Safe INT32_MIN handling in pressure encoding
- Faster USB enumeration with 10ms polling intervals
- Removed unused `g_usb_suspended` variable and `midi_sysex_send_sensor_status()` dead code
- Removed unused `CMD_SENSOR_STATUS` protocol command
- Consistent `#if CFG_TUD_CDC` guards on all printf calls (`bmp280_init`, `ecdsa_init`)
- Fixed `pressure_mpa` parameter naming to `pressure_mhpa` (milli-hPa) to match actual units
- Removed identity lookup tables in `bmp280_apply_config()`
- Cleaned up stale comments and replaced unreachable code with `__builtin_unreachable()`

---

## [3.0.0] - 2026-02-19 (RTM 3.0)

### Security Enhancements
- 🔐 **Soft Reboot PIN Protection** - CMD_SOFT_REBOOT now requires PIN authentication
- 🔒 **Persistent PIN Lockout** - Brute-force protection survives device reboot
- 🛡️ **Flash CRC32 Validation** - Data integrity check on settings load
- 🔑 **Crypto Buffer Zeroing** - Secure memory cleanup after authentication
- ⏱️ **Constant-Time Hex Validation** - Prevents timing side-channel attacks

### Reliability Improvements
- 🔄 **Auto-Reconnect** - Exponential backoff (2/4/6s) on USB disconnect, max 3 attempts
- 🩺 **Sensor Auto-Recovery** - 5-second periodic retry on BMP280 I2C failure
- ⏰ **Early Watchdog** - 8s timeout during boot, 2s during operation
- 🔧 **PIO Fallback** - Automatic switch to PIO1 if PIO0 unavailable
- 📝 **SysEx Timeout All States** - Parser resets from any state after 500ms

### Data Integrity
- 💾 **Flash Write Debounce** - 3-second delay prevents wear from rapid slider changes
- 📊 **Saturating Counters** - Diagnostics counters never overflow (uint16 max)
- 🕐 **64-bit Uptime** - Overflow-safe uptime tracking (584 years)

### Flutter App Improvements
- ✅ **hexToBytes Validation** - Throws FormatException on odd-length hex
- 📏 **Firmware Size Check** - 16MB limit before loading file into memory
- 🔢 **Config Value Clamping** - All settings values range-validated
- 🔤 **Serial UTF-8 Decode** - Proper unicode handling for device serial
- ⏱️ **Soft Reboot Timer Cancellation** - Prevents orphan timer on disconnect
- 🔒 **Double-Pop Guard** - Prevents duplicate Navigator.pop on disconnect
- 🌐 **Web MIDI Dispose Guard** - Prevents use-after-dispose errors

### Sensor & Chart Improvements
- 📏 **Extended Measurement Range** - BMP280 max pressure raised from 1100 to 1250 hPa
- 📈 **Dynamic Y-axis (Measurement)** - Chart Y-axis auto-scales to visible data range
- 📈 **Dynamic Y-axis (Monitor)** - Monitor chart Y-axis auto-scales to visible data
- 〰️ **Curved Measurement Chart** - Smooth bezier curves instead of polylines
- 🔄 **X-axis Auto-Scroll** - Measurement chart scrolls and filters to visible range
- 📊 **Chart Max Extended** - Y-axis max extended to 200 hPa (from 100 hPa)

### Stability & Crash Fixes
- 🛡️ **BOOTSEL Safe Shutdown** - Multicore lockout + interrupt disable before reset_usb_boot
- 🐛 **Measurement Disconnect Crash** - Fixed crash when save dialog appears during disconnect
- 🐛 **BOOTSEL ALSA Crash** - Fixed ALSA assertion failure after BOOTSEL reboot
- 🐛 **Auto-Reconnect Suppression** - Prevents reconnect loop after intentional BOOTSEL/soft reboot
- 🚫 **Non-DiveChecker Device Block** - Shows warning dialog instead of crashing on unsupported devices
- 🛡️ **MIDI Data Handler Guard** - Try-catch wrapper prevents crash from malformed MIDI data

### Bug Fixes
- 🐛 **FIFO Handshake Bug** - Fixed dual-push causing stale status reads
- 🐛 **Concurrent Reinit Race** - Guard against simultaneous sensor reconfig
- 🐛 **mbedTLS Context Leak** - Free contexts before re-initialization
- 🐛 **ecdsa_public_key.dart** - Fixed literal `\n` in byte array

---

## [1.2.0] - 2026-01-XX

### Performance Improvements
- 🚀 **Mobile Chart Performance Optimization**
  - Reduced LOD points from 800 to 400 for smoother scrolling
  - Added `RepaintBoundary` to all chart widgets
  - Disabled chart animations (`duration: Duration.zero`)
  - Disabled touch interactions on analysis charts
  - Disabled gradient fills on real-time chart
  - Throttled `notifyListeners()` during measurement

### Refactoring
- 🔧 **LOD System Simplification**
  - Consolidated `_lodFull` and `_lodMedium` into single `_lodData`
  - Removed unused `_getViewportFilteredData()` wrapper function
  - ChartPoint model exported in models.dart

### Project Structure
- 🗑️ **Removed ESP32 Firmware** - Project now focuses on Pico RP2350 only
- 📝 **Documentation Updates** - Updated all READMEs to reflect Pico-only support
- 📄 **Added Firmware README** - Created 0_Pico2-Firmware/Divechecker/README.md

---

## [1.1.0] - 2026-01-08

### Added
- 🔊 **USB MIDI Communication** - Switched from USB Serial to USB MIDI SysEx protocol
- 🔐 **ECDSA Device Authentication** - Hardware device verification using ECDSA signatures
- 🌐 Extended i18n keys (scanningForDevices, deviceConnectedSuccessfully, etc.)
- 🎨 `StatInfo`, `InfoRow` common widgets (stat_info.dart)
- 📊 `ScoreColors.gradeLabel()` utility method
- 📈 `recalculateWithSelectedPeaks()` peak analysis function
- 📊 `chart_utils.dart` - Shared chart utility functions

### Performance Improvements
- 🚀 **Graph Detail Page Optimization**
  - Viewport-based rendering: Only visible data points are rendered
  - LTTB-like downsampling with peak preservation
  - Reduced memory usage and faster rendering on mobile

### Gesture Improvements
- 📱 **Pinch-to-Zoom & Pan Gestures**
  - Added `onScaleEnd` handler for proper gesture completion
  - Improved pan gesture with minimum movement threshold
  - Smoother gesture response on Android devices

### Refactoring Improvements
- ⚡ Incremental statistics (O(1) instead of O(n) per update)
- ♻️ Consolidated duplicate widgets/functions into common modules
- 📉 graph_detail_page.dart reduced by ~110 lines
- 📉 peak_analysis_page.dart reduced by ~150 lines
- 📉 settings_screen.dart reduced by ~230 lines
- 🧹 Removed debug print statements from production code
- 🎨 Added centralized TextStyle, Opacity, Spacing, Color constants
- 🌐 Replaced hardcoded Korean strings with AppLocalizations

---

## [1.0.0] - 2025-12-17

### Added
- 🎉 Initial release of DiveChecker
- 📱 Real-time pressure monitoring with 100Hz internal sampling
- 📊 Interactive pressure graphs with zoom and pan controls
- 📝 Note-taking system with time-specific annotations
- 💾 SQLite database for local data persistence
- 🔗 USB MIDI device connection support
- 📈 Session history with detailed analytics
- 🎨 Material Design 3 with GitHub color scheme
- 🖥️ Cross-platform support (Android, iOS, Linux, Windows, macOS)

### Features
#### Home Screen
- Sensor device connection management
- Real-time pressure display
- Connection status indicators
- Device scanning and selection interface

#### Measurement Screen
- Live pressure graph visualization
- Start/Stop/Pause controls
- Session recording with metadata
- Max/Avg pressure statistics
- Connection status monitoring

#### History Screen
- Session list with preview charts
- Detailed session view with full graphs
- Note management interface
- Session deletion support

#### Graph Detail Page
- Full-screen graph analysis
- Zoom In/Out controls
- Pan Left/Right navigation
- Time-specific note placement
- Numbered note markers (#1, #2, #3...)
- Note detail view with pressure info
- Interactive tooltips

---

## Version History

### Version Numbering
- **Major.Minor.Patch+Build**
- Example: 1.0.0+1
  - Major: Breaking changes
  - Minor: New features (backwards compatible)
  - Patch: Bug fixes
  - Build: Build number

### Release Notes Format
- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Now removed features
- **Fixed**: Bug fixes
- **Security**: Vulnerability fixes

---

**Note**: This changelog will be updated with each release to track all changes and improvements.

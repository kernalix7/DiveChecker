# Changelog

All notable changes to DiveChecker will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned Features
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

## [1.2.0] - 2025-01-XX

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

## [1.1.0] - 2025-01-08

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

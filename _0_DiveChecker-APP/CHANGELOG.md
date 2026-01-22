# Changelog

All notable changes to DiveChecker will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - Build 5 - 2025-01-XX

### Performance Improvements
- 🚀 **Graph Detail Page Performance Optimization**
  - Viewport-based rendering: Only visible data points are rendered
  - LTTB-like downsampling: Max 1000 points rendered for smooth scrolling
  - Peak preservation: Important peaks are kept during downsampling
  - Reduced memory usage and faster rendering on mobile devices

### Gesture Improvements
- 📱 **Pinch-to-Zoom & Pan Gestures**
  - Added `onScaleEnd` handler for proper gesture completion
  - Improved pan gesture with minimum movement threshold
  - Separated pinch zoom and pan gesture handling
  - Smoother gesture response on Android devices

### Refactoring Improvements

#### l10n (Localization) Enhancements
- Added new l10n keys for atmospheric calibration:
  - `atmosphericCalibrating`, `atmosphericRecalibrate`, `atmosphericKeepSensorStill`
  - `secondsRemaining` (with placeholder parameter)
- Added firmware update l10n keys:
  - `selectFile`, `backToFileList`, `readyToInstall`, `verificationFailed`
- Replaced all hardcoded Korean strings with l10n keys in:
  - `home_widgets.dart` - Calibration overlay and button texts
  - `firmware_update_screen.dart` - File selection and status texts
  - `graph_detail_page.dart` - Title edit dialog
  - `analysis_widgets.dart` - Score suffix

#### Color Constants Migration
- Added new color constants in `app_constants.dart`:
  - `StatusColors.secondaryText` (grey 600 equivalent)
  - `StatusColors.tertiaryText` (grey 500 equivalent)
  - `OverlayColors.darkOverlay` (black for overlays)
  - `OverlayColors.whiteContent` (white for overlay content)
- Replaced `Colors.grey.shade500/600` → `StatusColors.secondaryText/tertiaryText`
- Replaced `Colors.black` → `OverlayColors.darkOverlay` for overlays
- Replaced `Colors.white` → `OverlayColors.whiteContent` for overlay texts/icons

#### Files Updated
- `lib/l10n/app_en.arb` - Added 8 new l10n keys
- `lib/l10n/app_ko.arb` - Added 8 new Korean translations
- `lib/l10n/app_localizations.dart` - Abstract getters for new keys
- `lib/l10n/app_localizations_en.dart` - English implementations
- `lib/l10n/app_localizations_ko.dart` - Korean implementations
- `lib/widgets/home/home_widgets.dart` - l10n & color constant migration
- `lib/screens/firmware_update_screen.dart` - l10n TODO items resolved
- `lib/utils/ui_helpers.dart` - Color constants for LoadingOverlay
- `lib/widgets/icon_container.dart` - Color constants
- `lib/widgets/settings/license_page.dart` - Color constants
- `lib/screens/serial_device_screen.dart` - Color constants
- `lib/widgets/common/styled_container.dart` - Shadow color constants

## [1.0.0] - 2025-12-17

### Added
- 🎉 Initial release of DiveChecker
- 📱 Real-time pressure monitoring with 10ms sampling rate
- 📊 Interactive pressure graphs with zoom and pan controls
- 📝 Note-taking system with time-specific annotations
- 💾 SQLite database for local data persistence
- 🔗 USB Serial device connection support
- 📈 Session history with detailed analytics
- 🎨 Material Design 3 with GitHub color scheme
- 🖥️ Cross-platform support (Android, iOS, Linux, Windows, macOS)

### Features
#### Home Screen
- Sensor device connection management
- Real-time pressure display
- Connection status indicators
- Scanning and pairing interface

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

### Technical Implementation
- Singleton pattern for Bluetooth service
- Stream-based state management
- Efficient data structures (3000 samples for 30s)
- Automatic note sorting by time
- Real-time synchronization

### Database Schema v2
- `sessions` table with full metadata
- `pressure_data` table with 10ms precision
- `graph_notes` table for annotations
- Automatic migration support

---

## [1.1.0] - 2025-01-08

### Added
- 🔊 **USB MIDI Communication** - Switched from USB Serial to USB MIDI SysEx protocol
- 🔐 **ECDSA Device Authentication** - Hardware device verification using ECDSA signatures
- 🌐 Extended i18n keys (scanningForDevices, deviceConnectedSuccessfully, etc.)
- 🎨 `StatInfo`, `InfoRow` common widgets (stat_info.dart)
- 📊 `ScoreColors.gradeLabel()` utility method
- 📈 `recalculateWithSelectedPeaks()` peak analysis function
- 📊 `chart_utils.dart` - Shared chart utility functions for consistent grid/label calculation

### Changed
- ⚡ **Performance Optimization** - Incremental statistics (O(1) instead of O(n) per update)
- ♻️ Code refactoring: Consolidated duplicate widgets/functions into common modules
- 📝 Applied l10n to serial_device_screen.dart
- 🔧 Fixed styled_container.dart `_Paddings` class
- ⏱️ **Chart Time Calculation** - Fixed duration and X-axis to use sample-based calculation
  - Duration = samples / Hz (not DateTime.now().difference())
  - X = index × (1000/Hz) milliseconds
- 📐 **Grid Alignment** - Vertical grid now aligns with sample rate intervals

### Improved
- 📉 graph_detail_page.dart reduced by ~110 lines (using common widgets)
- 📉 peak_analysis_page.dart reduced by ~150 lines (function extraction)
- 📉 settings_screen.dart reduced by ~230 lines (removed unused dialog functions)
- 🧹 Removed duplicate `_getScoreColor`, `_getGradeLabel` methods
- 🧹 Removed debug print statements from production code
- 🧹 Cleaned up Linux MIDI package debug prints
- 🎨 **AppTextStyles** - Added centralized TextStyle constants (semiBold, bold, monospace, appBarTitle)
- 🎨 **Opacity Constants** - Replaced all hardcoded opacity values with Opacities constants
- 🎨 **Spacing Constants** - Replaced hardcoded SizedBox values with Spacing constants
- 🎨 **AppDivider & SectionSpacing** - Extracted common divider and section spacing widgets
- 🎨 **Color Constants** - Replaced Colors.orange/green/red with ScoreColors.warning/excellent/poor
- 🛠️ **ui_helpers.dart** - Added common SnackBar utilities and BuildContext extensions
- 🛠️ **CompactLoadingIndicator** - Extracted common loading indicator widget
- 🛠️ **SnackBar Refactoring** - Unified ScaffoldMessenger.of(context).showSnackBar() to context.showSnackBar() extension
- 🌐 **l10n Migration** - Replaced hardcoded Korean strings with AppLocalizations (editTitle, points)
- 🔧 **BorderRadius Constants** - Replaced BorderRadius.circular(BorderRadii.xx) with BorderRadii.xxAll pattern
- 🔧 **firmware_update_screen.dart** - Added l10n parameters to internal methods for localization support

### Documentation
- 📚 README.md complete rewrite (Flutter template → project documentation)
- 📖 Created 0_CAD/README.md
- 📝 Enhanced 0_MCU_Firmware/README.md license section
- 📄 Separated all docs into EN/KO versions
- 📝 Updated README for USB MIDI communication details

---

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
- 🌍 Multi-language support

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

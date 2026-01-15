# Changelog

All notable changes to DiveChecker will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

## [1.1.0] - 2026-01-08

### Added
- 🌐 Extended i18n keys (scanningForDevices, deviceConnectedSuccessfully, etc.)
- 🎨 `StatInfo`, `InfoRow` common widgets (stat_info.dart)
- 📊 `ScoreColors.gradeLabel()` utility method
- 📈 `recalculateWithSelectedPeaks()` peak analysis function

### Changed
- ♻️ Code refactoring: Consolidated duplicate widgets/functions into common modules
- 📝 Applied l10n to serial_device_screen.dart
- 🔧 Fixed styled_container.dart `_Paddings` class

### Improved
- 📉 graph_detail_page.dart reduced by ~110 lines (using common widgets)
- 📉 peak_analysis_page.dart reduced by ~150 lines (function extraction)
- 🧹 Removed duplicate `_getScoreColor`, `_getGradeLabel` methods

### Documentation
- 📚 README.md complete rewrite (Flutter template → project documentation)
- 📖 Created 0_CAD/README.md
- 📝 Enhanced 0_MCU_Firmware/README.md license section
- 📄 Separated all docs into EN/KO versions

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

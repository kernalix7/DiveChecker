# Changelog

**English** | [한국어](docs/CHANGELOG.ko.md)

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project aims to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Session delete button in history screen
- Fullscreen chart view for real-time measurement
- Code quality improvements for release readiness

### Fixed
- Decoupled pressure data flow from ping/pong connection state
- Cross-core memory ordering with `__dmb()` barriers in firmware

## [6.0.0] — RTM

### Added
- USB MIDI SysEx protocol for cross-platform device communication
- Dual-core firmware architecture (Core0: USB/commands, Core1: 160Hz sensor sampling)
- ECDSA P-256 device authentication with OTP key storage support
- Configurable sensor output rate (4-50Hz)
- IIR 2-stage + averaging filter pipeline in firmware
- PIN-protected device configuration
- WS2812 RGB LED status indication
- Multi-language support (English, Korean, Japanese, Chinese)

### Changed
- Migrated app stack to MIDI-first communication flow
- Improved runtime stability and reconnect behavior

## [5.0.0]

### Added
- Multi-platform build metadata and release documentation
- Stabilized firmware sampling behavior

## [4.0.0] — RTM

### Added
- Initial MIDI-based communication architecture
- Cross-platform Flutter app (Android, iOS, Linux, Windows, macOS, Web)
- BMP280 pressure sensor integration with RP2350

## [3.0.0] — RTM

### Added
- Core measurement and visualization features
- Session recording and history

## [2.0.0]

### Added
- Peak detection sensitivity and accuracy improvements
- Old firmware backward compatibility support

## [1.1.0]

### Added
- Initial public release
- Basic pressure monitoring and real-time charting
- GitHub Actions CI/CD pipeline for all platforms

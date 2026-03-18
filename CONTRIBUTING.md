# Contributing to DiveChecker

**English** | [한국어](docs/CONTRIBUTING.ko.md)

Thanks for your interest in contributing to DiveChecker.

## Development Setup

### Prerequisites
- Flutter SDK 3.10.4+
- Dart SDK 3.10+
- Pico SDK 2.2.0 (for firmware development)
- CMake 3.13+ (for firmware build)
- Android Studio / Xcode (for mobile builds)

### Build
```bash
git clone https://github.com/kernalix7/DiveChecker.git
cd DiveChecker/_0_DiveChecker-APP
flutter pub get
flutter gen-l10n
flutter run
```

### Test
```bash
cd _0_DiveChecker-APP
flutter test
flutter analyze --no-fatal-infos
```

## Workflow

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-change`
3. Commit with Conventional Commits style
4. Push and open a Pull Request

## Pull Request Checklist

- [ ] The change has a clear scope and rationale
- [ ] Tests are added/updated where applicable
- [ ] `flutter analyze --no-fatal-infos` passes
- [ ] `flutter test` passes
- [ ] README / docs are updated when behavior changes

## Commit Message Convention

Use [Conventional Commits](https://www.conventionalcommits.org/):
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `refactor:` for internal improvements without behavior changes
- `test:` for test updates
- `chore:` for maintenance tasks

## Security

For security issues, follow the process in [SECURITY.md](SECURITY.md).

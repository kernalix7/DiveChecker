# Contributing to DiveChecker

Thank you for your interest in contributing to DiveChecker! This document provides guidelines for contributing to the project.

## 🌟 How to Contribute

### Reporting Bugs
If you find a bug, please create an issue with:
- Clear description of the bug
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable
- Device/OS information
- App version

### Suggesting Features
Feature requests are welcome! Please include:
- Clear description of the feature
- Use case and benefits
- Mockups or examples if possible
- Implementation ideas (optional)

### Pull Requests
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Make your changes
4. Test thoroughly
5. Commit with clear messages (`git commit -m 'Add AmazingFeature'`)
6. Push to your branch (`git push origin feature/AmazingFeature`)
7. Open a Pull Request

## 📝 Code Style

### Dart/Flutter Guidelines
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide
- Use meaningful variable and function names
- Add comments for complex logic
- Document public APIs with dartdoc comments
- Keep functions small and focused
- Use const constructors where possible

### Code Organization
```dart
// Copyright header
// Package imports
// Relative imports
// Constants
// Class definition
// Private members first
// Public members after
```

### Naming Conventions
- **Classes**: PascalCase (`MyClass`)
- **Variables/Functions**: camelCase (`myVariable`, `myFunction`)
- **Constants**: lowerCamelCase with const (`kDefaultValue`)
- **Private**: underscore prefix (`_privateMethod`)
- **Files**: snake_case (`my_screen.dart`)

## 🧪 Testing

### Before Submitting
- [ ] Code builds without errors
- [ ] All features work as expected
- [ ] No new warnings introduced
- [ ] Tested on target platforms
- [ ] Database migrations work correctly
- [ ] USB MIDI connection stable

### Test Areas
- UI responsiveness
- Data persistence
- USB MIDI connectivity
- Graph interactions
- Note management
- Session recording

## 📚 Documentation

### Required Documentation
- Update README.md if adding features
- Update CHANGELOG.md with changes
- Add dartdoc comments for public APIs
- Update inline comments as needed

### Documentation Style
```dart
/// Brief description of the function.
///
/// Detailed explanation if needed.
///
/// Parameters:
/// - [param1]: Description
/// - [param2]: Description
///
/// Returns: Description of return value
///
/// Example:
/// ```dart
/// final result = myFunction('test');
/// ```
void myFunction(String param1) {
  // Implementation
}
```

## 🔧 Development Setup

### Prerequisites
```bash
# Install Flutter
flutter --version  # Should be 3.10.4 or higher

# Get dependencies
flutter pub get

# Run the app
flutter run
```

### Project Structure
```
lib/
├── main.dart              # Entry point
├── models/                # Data models
├── screens/               # UI screens
└── services/              # Business logic
```

## 🎯 Priority Areas

### High Priority
- Hardware MCU integration
- iOS platform support
- Performance optimization
- Error handling improvements

### Medium Priority
- Data export functionality
- Cloud synchronization
- Advanced analytics
- UI/UX refinements

### Low Priority
- Multi-language support
- Theme customization
- Additional chart types
- Social features

## 💬 Communication

### Getting Help
- Check existing issues first
- Ask questions in issue comments
- Be respectful and patient
- Provide context and details

### Review Process
- All PRs require review
- Address feedback promptly
- Keep discussions professional
- Be open to suggestions

## 📋 Commit Message Guidelines

### Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting)
- **refactor**: Code refactoring
- **test**: Adding tests
- **chore**: Maintenance tasks

### Examples
```
feat(measurement): add pause functionality

Added ability to pause measurements without stopping the session.
This allows users to temporarily halt recording while maintaining
the current session data.

Closes #123
```

```
fix(midi): resolve connection stability issue

Fixed issue where connection would drop after 30 seconds.
Updated timeout handling and added automatic reconnection.

Fixes #456
```

## 🎨 Design Guidelines

### UI/UX Principles
- Keep it simple and intuitive
- Maintain consistency across screens
- Use Material Design 3 components
- Follow GitHub color scheme
- Ensure accessibility
- Optimize for performance

### Color Palette
- Primary: #0969DA (Light), #58A6FF (Dark)
- Success: Green
- Warning: Orange
- Error: Red
- Surface: Default Material colors

## 🚀 Release Process

### Version Updates
1. Update version in `pubspec.yaml`
2. Update CHANGELOG.md
3. Create git tag
4. Build release
5. Test thoroughly
6. Publish release notes

## 📄 License

By contributing, you agree that your contributions will be licensed under the Apache License 2.0.

## 🙏 Thank You!

Your contributions make DiveChecker better for everyone. We appreciate your time and effort!

---

For questions or clarifications, please open an issue or reach out to the maintainers.

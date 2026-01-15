// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  system,
  light,
  dark,
}

enum PressureUnit {
  hPa,    // hectopascal (default, same as mbar)
  mbar,   // millibar (same as hPa, just different name)
  cmH2O,  // centimeters of water
  mmHg,   // millimeters of mercury
  Pa,     // pascal
}

/// Firmware output rate (sent to device via F command)
/// This is the single source of truth for sampling/display/storage rate
enum OutputRate {
  hz4(4),
  hz8(8),
  hz16(16),
  hz32(32),
  hz50(50);

  final int value;
  const OutputRate(this.value);

  String get displayName => '$value Hz';
  
  /// Get interval in milliseconds
  int get intervalMs => 1000 ~/ value;
  
  String get description {
    switch (this) {
      case OutputRate.hz4:
        return 'Power saving';
      case OutputRate.hz8:
        return 'Balanced (default)';
      case OutputRate.hz16:
        return 'High precision';
      case OutputRate.hz32:
        return 'Very high precision';
      case OutputRate.hz50:
        return 'Maximum precision';
    }
  }
  
  /// Get OutputRate from Hz value
  static OutputRate fromHz(int hz) {
    return OutputRate.values.firstWhere(
      (r) => r.value == hz,
      orElse: () => OutputRate.hz8,
    );
  }
}

extension PressureUnitExtension on PressureUnit {
  String get symbol {
    switch (this) {
      case PressureUnit.hPa:
        return 'hPa';
      case PressureUnit.mbar:
        return 'mbar';
      case PressureUnit.cmH2O:
        return 'cmH₂O';
      case PressureUnit.mmHg:
        return 'mmHg';
      case PressureUnit.Pa:
        return 'Pa';
    }
  }

  String get displayName {
    switch (this) {
      case PressureUnit.hPa:
        return 'Hectopascal (hPa)';
      case PressureUnit.mbar:
        return 'Millibar (mbar)';
      case PressureUnit.cmH2O:
        return 'Centimeters H₂O (cmH₂O)';
      case PressureUnit.mmHg:
        return 'Millimeters Hg (mmHg)';
      case PressureUnit.Pa:
        return 'Pascal (Pa)';
    }
  }

  /// Convert from hPa (base unit) to this unit
  double fromHPa(double hPa) {
    switch (this) {
      case PressureUnit.hPa:
        return hPa;
      case PressureUnit.mbar:
        return hPa; // 1 hPa = 1 mbar
      case PressureUnit.cmH2O:
        return hPa * 1.01972; // 1 hPa ≈ 1.01972 cmH2O
      case PressureUnit.mmHg:
        return hPa * 0.750062; // 1 hPa ≈ 0.750062 mmHg
      case PressureUnit.Pa:
        return hPa * 100; // 1 hPa = 100 Pa
    }
  }

  /// Convert from this unit to hPa (base unit)
  double toHPa(double value) {
    switch (this) {
      case PressureUnit.hPa:
        return value;
      case PressureUnit.mbar:
        return value; // 1 mbar = 1 hPa
      case PressureUnit.cmH2O:
        return value / 1.01972;
      case PressureUnit.mmHg:
        return value / 0.750062;
      case PressureUnit.Pa:
        return value / 100;
    }
  }
}

class SettingsProvider extends ChangeNotifier {
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _hapticFeedbackKey = 'haptic_feedback';
  static const String _themeModeKey = 'theme_mode';
  static const String _pressureUnitKey = 'pressure_unit';

  bool _notificationsEnabled = true;
  bool _hapticFeedbackEnabled = true;
  AppThemeMode _themeMode = AppThemeMode.system;
  PressureUnit _pressureUnit = PressureUnit.hPa;

  bool get notificationsEnabled => _notificationsEnabled;
  bool get hapticFeedbackEnabled => _hapticFeedbackEnabled;
  AppThemeMode get themeMode => _themeMode;
  PressureUnit get pressureUnit => _pressureUnit;
  
  /// Get pressure unit symbol for display
  String get pressureUnitSymbol => _pressureUnit.symbol;
  
  /// Convert pressure from hPa to current display unit
  double convertPressure(double hPa) => _pressureUnit.fromHPa(hPa);
  
  /// Format pressure with current unit
  String formatPressure(double hPa, {int decimals = 2}) {
    final converted = convertPressure(hPa);
    return '${converted.toStringAsFixed(decimals)} ${_pressureUnit.symbol}';
  }
  
  ThemeMode get flutterThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool(_notificationsEnabledKey) ?? true;
    _hapticFeedbackEnabled = prefs.getBool(_hapticFeedbackKey) ?? true;
    
    final themeModeIndex = prefs.getInt(_themeModeKey) ?? 0;
    _themeMode = AppThemeMode.values[themeModeIndex.clamp(0, AppThemeMode.values.length - 1)];
    
    final pressureUnitIndex = prefs.getInt(_pressureUnitKey) ?? 0;
    _pressureUnit = PressureUnit.values[pressureUnitIndex.clamp(0, PressureUnit.values.length - 1)];
    
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    if (_notificationsEnabled == enabled) return;

    _notificationsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
    notifyListeners();
  }

  Future<void> setHapticFeedbackEnabled(bool enabled) async {
    if (_hapticFeedbackEnabled == enabled) return;

    _hapticFeedbackEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticFeedbackKey, enabled);
    notifyListeners();
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
    notifyListeners();
  }

  Future<void> setPressureUnit(PressureUnit unit) async {
    if (_pressureUnit == unit) return;

    _pressureUnit = unit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pressureUnitKey, unit.index);
    notifyListeners();
  }
}

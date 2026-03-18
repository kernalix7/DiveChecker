// Copyright (C) 2025-2026 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'locale';
  Locale _locale = const Locale('ko');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeTag = prefs.getString(_localeKey) ?? 'ko';
    _locale = _parseLocaleTag(localeTag);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, _toLocaleTag(locale));
    notifyListeners();
  }

  static String _toLocaleTag(Locale locale) {
    if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
      return '${locale.languageCode}_${locale.countryCode}';
    }
    return locale.languageCode;
  }

  static Locale _parseLocaleTag(String tag) {
    final parts = tag.split('_');
    if (parts.length >= 2) {
      return Locale(parts[0], parts[1]);
    }
    return Locale(parts[0]);
  }

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ko'),
    Locale('ja'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  static String getDisplayName(Locale locale) {
    if (locale.languageCode == 'zh' && locale.countryCode == 'TW') {
      return '繁體中文';
    }
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ko':
        return '한국어';
      case 'ja':
        return '日本語';
      case 'zh':
        return '简体中文';
      default:
        return locale.languageCode;
    }
  }
}

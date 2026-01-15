// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

import '../l10n/app_localizations.dart';

String formatDuration(int seconds, [AppLocalizations? l10n]) {
  final minutes = seconds ~/ 60;
  final remainingSeconds = seconds % 60;
  
  if (l10n != null) {
    if (minutes > 0) {
      return l10n.minutesSeconds(minutes, remainingSeconds);
    }
    return l10n.secondsOnly(seconds);
  }
  
  // Fallback when l10n not available
  if (minutes > 0) {
    return '$minutes분 ${remainingSeconds}초';
  }
  return '${seconds}초';
}

String formatShortDate(DateTime date) {
  return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
}

String formatTime(DateTime date) {
  return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}

String formatPressure(double value, [int decimals = 1]) {
  if (value.abs() < 0.05 / (decimals == 0 ? 1 : 10)) {
    return decimals == 0 ? '0' : '0.${'0' * decimals}';
  }
  return value.toStringAsFixed(decimals);
}

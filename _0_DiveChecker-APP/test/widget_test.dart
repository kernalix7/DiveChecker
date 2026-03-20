// Copyright (C) 2025-2026 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:divechecker/main.dart';
import 'package:divechecker/providers/providers.dart';

void main() {
  setUpAll(() {
    // Initialize sqflite FFI for desktop/CI test environment
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('DiveChecker app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ChangeNotifierProvider(create: (_) => MidiProvider()),
          ChangeNotifierProvider(create: (_) => SessionRepository()..loadSessions()),
        ],
        child: const DiveCheckerApp(),
      ),
    );

    // Use pump() instead of pumpAndSettle() — the app has persistent timers
    // (MIDI ping, calibration) that prevent settling
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(DiveCheckerApp), findsOneWidget);
  });
}

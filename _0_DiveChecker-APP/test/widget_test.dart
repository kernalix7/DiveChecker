// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:divechecker/main.dart';
import 'package:divechecker/providers/providers.dart';

void main() {
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
    await tester.pumpAndSettle();

    expect(find.byType(DiveCheckerApp), findsOneWidget);
  });
}

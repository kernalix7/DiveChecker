// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root.

import 'package:flutter_test/flutter_test.dart';

import 'package:divechecker/main.dart';

void main() {
  testWidgets('DiveChecker app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DiveCheckerApp());

    expect(find.byType(DiveCheckerApp), findsOneWidget);
  });
}

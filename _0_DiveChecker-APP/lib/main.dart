// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'config/theme_config.dart';
import 'screens/main_screen.dart';
import 'providers/providers.dart';
import 'utils/platform_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDesktopDatabase();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => SerialProvider()),
        ChangeNotifierProvider(create: (_) => SessionRepository()..loadSessions()),
      ],
      child: const DiveCheckerApp(),
    ),
  );
}

class DiveCheckerApp extends StatefulWidget {
  const DiveCheckerApp({super.key});

  @override
  State<DiveCheckerApp> createState() => _DiveCheckerAppState();
}

class _DiveCheckerAppState extends State<DiveCheckerApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final serial = context.read<SerialProvider>();
    
    if (state == AppLifecycleState.detached || state == AppLifecycleState.paused) {
      debugPrint('[Lifecycle] App state: $state - disconnecting Serial');
      serial.disconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocaleProvider, SettingsProvider>(
      builder: (context, localeProvider, settingsProvider, child) {
        return MaterialApp(
          title: 'DiveChecker',
          theme: createLightTheme(),
          darkTheme: createDarkTheme(),
          themeMode: settingsProvider.flutterThemeMode,
          locale: localeProvider.locale,
          supportedLocales: LocaleProvider.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const MainScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

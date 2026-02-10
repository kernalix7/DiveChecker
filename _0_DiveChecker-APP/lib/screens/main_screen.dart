// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// Main Navigation Screen
/// 
/// Bottom navigation bar with screen routing.
/// Separated from main.dart for better organization.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../constants/app_constants.dart';
import '../providers/serial_provider.dart';
import '../widgets/common/disclaimer_dialog.dart';
import 'home_screen.dart';
import 'monitor_screen.dart';
import 'measurement_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

/// Navigation destinations
enum AppDestination {
  home(Icons.home_outlined, Icons.home),
  monitor(Icons.monitor_heart_outlined, Icons.monitor_heart),
  measurement(Icons.speed_outlined, Icons.speed),
  history(Icons.history_outlined, Icons.history),
  settings(Icons.settings_outlined, Icons.settings);

  final IconData icon;
  final IconData selectedIcon;
  const AppDestination(this.icon, this.selectedIcon);

  String getLabel(AppLocalizations l10n) {
    return switch (this) {
      AppDestination.home => l10n.home,
      AppDestination.monitor => l10n.monitor,
      AppDestination.measurement => l10n.measurement,
      AppDestination.history => l10n.history,
      AppDestination.settings => l10n.settings,
    };
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _disclaimerChecked = false;
  StreamSubscription? _overrangeSubscription;

  // Lazy-loaded screens
  static const List<Widget> _screens = [
    HomeScreen(),
    MonitorScreen(),
    MeasurementScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkDisclaimer();
    _listenOverrange();
  }

  void _listenOverrange() {
    if (_overrangeSubscription != null) return;
    final serial = context.read<SerialProvider>();
    _overrangeSubscription = serial.overrangeStream.listen((_) {
      if (mounted) _showOverrangeWarning();
    });
  }

  void _showOverrangeWarning() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.overrangeWarningTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: FontSizes.body,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.overrangeWarningMessage,
                      style: const TextStyle(
                        fontSize: FontSizes.bodySm,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.deepOrange,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(Spacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  Future<void> _checkDisclaimer() async {
    if (_disclaimerChecked) return;
    _disclaimerChecked = true;
    
    // Show disclaimer after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showDisclaimerIfNeeded(context);
      }
    });
  }

  void _onDestinationSelected(int index) {
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  void dispose() {
    _overrangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: AppDestination.values.map((dest) {
          return NavigationDestination(
            icon: Icon(dest.icon),
            selectedIcon: Icon(dest.selectedIcon),
            label: dest.getLabel(l10n),
          );
        }).toList(),
      ),
    );
  }
}

// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// Main Navigation Screen
/// 
/// Bottom navigation bar with screen routing.
/// Separated from main.dart for better organization.
library;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../widgets/common/disclaimer_dialog.dart';
import 'home_screen.dart';
import 'measurement_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

/// Navigation destinations
enum AppDestination {
  home(Icons.home_outlined, Icons.home),
  measurement(Icons.speed_outlined, Icons.speed),
  history(Icons.history_outlined, Icons.history),
  settings(Icons.settings_outlined, Icons.settings);

  final IconData icon;
  final IconData selectedIcon;
  const AppDestination(this.icon, this.selectedIcon);

  String getLabel(AppLocalizations l10n) {
    return switch (this) {
      AppDestination.home => l10n.home,
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

  // Lazy-loaded screens
  static const List<Widget> _screens = [
    HomeScreen(),
    MeasurementScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkDisclaimer();
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

// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// HomeScreen - Device Connection & Status Overview
///
/// Displays USB Serial connection status and current pressure reading.
/// Uses SerialProvider for state management.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../constants/app_constants.dart';
import '../providers/serial_provider.dart';
import '../widgets/home/home_widgets.dart';
import 'serial_device_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _sensorErrorShown = false; // Track if sensor error dialog was shown
  bool _authWarningShown = false; // Track if authentication warning was shown

  @override
  void initState() {
    super.initState();
    // Listen for sensor status changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final serial = context.read<SerialProvider>();
      serial.addListener(_checkDeviceStatus);
    });
  }

  @override
  void dispose() {
    // Remove listener when widget is disposed
    final serial = context.read<SerialProvider>();
    serial.removeListener(_checkDeviceStatus);
    super.dispose();
  }

  void _checkDeviceStatus() {
    final serial = context.read<SerialProvider>();

    // Show sensor error dialog when connected and sensor is not OK
    if (serial.isConnected && !serial.isSensorConnected && !_sensorErrorShown) {
      _sensorErrorShown = true;
      _showSensorErrorDialog();
    }

    // Show authentication warning when connected but not authenticated
    // Only show AFTER authentication attempt has completed
    if (serial.isConnected &&
        serial.isAuthenticationComplete &&
        !serial.isDeviceAuthenticated &&
        !_authWarningShown) {
      _authWarningShown = true;
      _showCounterfeitWarningDialog();
    }

    // Reset flags when disconnected
    if (!serial.isConnected) {
      _sensorErrorShown = false;
      _authWarningShown = false;
    }
  }

  void _showSensorErrorDialog() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Container(
          padding: const EdgeInsets.all(Spacing.lg),
          decoration: BoxDecoration(
            color: theme.colorScheme.errorContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.warning_amber_rounded,
            size: IconSizes.xxl,
            color: theme.colorScheme.error,
          ),
        ),
        title: Text(l10n.sensorError, textAlign: TextAlign.center),
        content: Text(l10n.sensorErrorDescription, textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showCounterfeitWarningDialog() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Container(
          padding: const EdgeInsets.all(Spacing.lg),
          decoration: BoxDecoration(
            color: ScoreColors.warning.withOpacity(Opacities.medium),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.gpp_bad_outlined,
            size: IconSizes.xxl,
            color: ScoreColors.warning,
          ),
        ),
        title: Text(
          l10n.counterfeitWarningTitle,
          textAlign: TextAlign.center,
          style: TextStyle(color: theme.colorScheme.error),
        ),
        content: Text(
          l10n.counterfeitWarningMessage,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.continueAnyway),
          ),
        ],
      ),
    );
  }

  void _toggleConnection(SerialProvider provider) {
    if (provider.isConnected) {
      _disconnectDevice(provider);
    } else {
      _openDeviceSelection();
    }
  }

  void _disconnectDevice(SerialProvider provider) {
    provider.disconnect();
  }

  void _recalibrateAtmospheric(SerialProvider provider) {
    provider.startAtmosphericCalibration();
  }

  Future<void> _openDeviceSelection() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const SerialDeviceScreen()),
    );

    if (result == true && mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.deviceConnectedSuccessfully)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = Responsive.padding(context);
    final maxWidth = Responsive.maxContentWidth(context);

    return Consumer<SerialProvider>(
      builder: (context, serial, child) {
        return Scaffold(
          body: Stack(
            children: [
              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Padding(
                      padding: screenPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          HomeHeader(
                            isConnected: serial.isConnected,
                            isScanning: serial.isScanning,
                            isAuthenticated: serial.isDeviceAuthenticated,
                            isAuthenticationComplete:
                                serial.isAuthenticationComplete,
                          ),

                          const SizedBox(height: Spacing.section + Spacing.sm),

                          // Main Content
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Connection Status Panel
                                  ConnectionStatusPanel(
                                    isConnected: serial.isConnected,
                                    isScanning: serial.isScanning,
                                  ),

                                  // Authentication Warning Banner (only after auth complete and failed)
                                  if (serial.isConnected &&
                                      serial.isAuthenticationComplete &&
                                      !serial.isDeviceAuthenticated) ...[
                                    Spacing.verticalMd,
                                    const AuthenticationWarningBanner(),
                                  ],

                                  // Pressure Display (when connected)
                                  if (serial.isConnected) ...[
                                    Spacing.verticalXxl,
                                    CurrentPressurePanel(
                                      pressure: serial.currentPressure,
                                    ),
                                    Spacing.verticalLg,
                                    // Atmospheric Pressure Recalibration Button (only when sensor OK)
                                    if (serial.isSensorConnected)
                                      RecalibrateAtmosphericButton(
                                        isCalibrating: serial.isCalibrating,
                                        onPressed: () =>
                                            _recalibrateAtmospheric(serial),
                                      ),
                                    Spacing.verticalXl,
                                    const LiveMonitoringIndicator(),
                                  ],

                                  const SizedBox(
                                    height: Spacing.section + Spacing.sm,
                                  ),

                                  // Connection Button
                                  ConnectionButton(
                                    isConnected: serial.isConnected,
                                    isScanning: serial.isScanning,
                                    onPressed: () => _toggleConnection(serial),
                                  ),

                                  // Help Text
                                  if (!serial.isConnected &&
                                      !serial.isScanning) ...[
                                    Spacing.verticalLg,
                                    const ConnectionHelpText(),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Calibration overlay
              if (serial.isCalibrating)
                AtmosphericCalibrationOverlay(
                  progress: serial.calibrationProgress,
                  onCancel: () => serial.cancelCalibration(),
                ),
            ],
          ),
        );
      },
    );
  }
}

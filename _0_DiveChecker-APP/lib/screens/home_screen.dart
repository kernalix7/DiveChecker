// Copyright (C) 2025-2026 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// HomeScreen - Device Connection & Status Overview
///
/// Displays USB MIDI connection status and current pressure reading.
/// Uses MidiProvider for state management.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../constants/app_constants.dart';
import '../providers/midi_provider.dart';
import '../widgets/home/home_widgets.dart';
import 'device_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _sensorErrorShown = false; // Track if sensor error dialog was shown
  bool _authWarningShown = false; // Track if authentication warning was shown
  bool _authProgressShown = false; // Track if auth progress snackbar was shown
  bool _calibProgressShown = false; // Track if calibration progress snackbar was shown
  bool _connectionCompleteShown = false; // Track if final success snackbar was shown
  MidiProvider? _midiProvider; // Cache provider reference for safe dispose

  @override
  void initState() {
    super.initState();
    // Listen for sensor status changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _midiProvider = context.read<MidiProvider>();
      _midiProvider?.addListener(_checkDeviceStatus);
    });
  }

  @override
  void dispose() {
    // Safely remove listener using cached reference
    _midiProvider?.removeListener(_checkDeviceStatus);
    _midiProvider = null;
    super.dispose();
  }

  void _checkDeviceStatus() {
    if (!mounted) return;
    final midi = _midiProvider;
    if (midi == null) return;

    // Connection progress SnackBars (sequential)
    if (midi.isConnected) {
      final l10n = AppLocalizations.of(context)!;

      // Step 1: Show "Verifying device..." when connected but auth not complete
      if (!midi.isAuthenticationComplete && !_authProgressShown) {
        _authProgressShown = true;
        _showProgressSnackBar(l10n.verifyingDevice, Icons.verified_user_outlined);
      }

      // Step 2: Show "Calibrating atmospheric pressure..." when auth done + calibrating
      if (midi.isAuthenticationComplete && midi.isCalibrating && !_calibProgressShown) {
        _calibProgressShown = true;
        _showProgressSnackBar(l10n.atmosphericCalibrating, Icons.compress);
      }

      // Step 3: Show feedback when calibration completes
      if (midi.isAuthenticationComplete && !midi.isCalibrating && _calibProgressShown && !_connectionCompleteShown) {
        _connectionCompleteShown = true;
        if (midi.atmosphericPressureOffset == 0.0) {
          // Calibration timed out or failed
          _showWarningSnackBar(l10n.calibrationTimedOut);
        } else {
          _showSuccessSnackBar(l10n.deviceConnectedSuccessfully);
        }
      }
    }

    // Show sensor error dialog when connected and sensor is not OK
    if (midi.isConnected && !midi.isSensorConnected && !_sensorErrorShown) {
      _sensorErrorShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showSensorErrorDialog();
      });
    }

    // Show authentication warning when connected but not authenticated
    // Only show AFTER authentication attempt has completed
    if (midi.isConnected &&
        midi.isAuthenticationComplete &&
        !midi.isDeviceAuthenticated &&
        !_authWarningShown) {
      _authWarningShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showCounterfeitWarningDialog();
      });
    }

    // Reset flags when disconnected
    if (!midi.isConnected) {
      _sensorErrorShown = false;
      _authWarningShown = false;
      _authProgressShown = false;
      _calibProgressShown = false;
      _connectionCompleteShown = false;
      // Clear any lingering progress SnackBars
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ScaffoldMessenger.of(context).clearSnackBars();
      });
    }
  }

  void _showProgressSnackBar(String message, IconData icon) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Text(message),
              ],
            ),
            duration: const Duration(seconds: 10),
            behavior: SnackBarBehavior.floating,
          ),
        );
    });
  }

  void _showSuccessSnackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: Spacing.sm),
                Text(message),
              ],
            ),
            backgroundColor: Colors.green.shade700,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
    });
  }

  void _showWarningSnackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.warning_amber, color: Colors.white, size: 20),
                const SizedBox(width: Spacing.sm),
                Expanded(child: Text(message)),
              ],
            ),
            backgroundColor: Colors.orange.shade700,
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
          ),
        );
    });
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

  void _toggleConnection(MidiProvider provider) {
    if (provider.isConnected) {
      _disconnectDevice(provider);
    } else {
      _openDeviceSelection();
    }
  }

  void _disconnectDevice(MidiProvider provider) {
    provider.disconnect();
  }

  Future<void> _openDeviceSelection() async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const DeviceSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = Responsive.padding(context);
    final maxWidth = Responsive.maxContentWidth(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final isCompact = screenHeight < 700; // Compact mode for small screens

    return Consumer<MidiProvider>(
      builder: (context, midi, child) {
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
                            isConnected: midi.isConnected,
                            isScanning: midi.isScanning,
                            isAuthenticated: midi.isDeviceAuthenticated,
                            isAuthenticationComplete:
                                midi.isAuthenticationComplete,
                          ),

                          SizedBox(height: isCompact ? Spacing.md : Spacing.section + Spacing.sm),

                          // Main Content - Scrollable
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: constraints.maxHeight,
                                    ),
                                    child: IntrinsicHeight(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // Connection Status Panel
                                          ConnectionStatusPanel(
                                            isConnected: midi.isConnected,
                                            isScanning: midi.isScanning,
                                            isCompact: isCompact,
                                          ),

                                          // Authentication Warning Banner (only after auth complete and failed)
                                          if (midi.isConnected &&
                                              midi.isAuthenticationComplete &&
                                              !midi.isDeviceAuthenticated) ...[
                                            SizedBox(height: isCompact ? Spacing.sm : Spacing.md),
                                            const AuthenticationWarningBanner(),
                                          ],

                                          // Pressure Display (when connected)
                                          if (midi.isConnected) ...[
                                            SizedBox(height: isCompact ? Spacing.lg : Spacing.xxl),
                                            CurrentPressurePanel(
                                              pressure: midi.currentPressure,
                                              isCompact: isCompact,
                                            ),
                                            SizedBox(height: isCompact ? Spacing.md : Spacing.xl),
                                            const LiveMonitoringIndicator(),
                                          ],

                                          // Flexible spacer
                                          const Spacer(),

                                          SizedBox(
                                            height: isCompact ? Spacing.lg : Spacing.section + Spacing.sm,
                                          ),

                                          // Connection Button
                                          ConnectionButton(
                                            isConnected: midi.isConnected,
                                            isScanning: midi.isScanning,
                                            onPressed: () => _toggleConnection(midi),
                                          ),

                                          // Help Text
                                          if (!midi.isConnected &&
                                              !midi.isScanning) ...[
                                            SizedBox(height: isCompact ? Spacing.md : Spacing.lg),
                                            const ConnectionHelpText(),
                                          ],
                                          
                                          // Bottom padding for safe area
                                          SizedBox(height: isCompact ? Spacing.md : Spacing.lg),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Calibration overlay
              if (midi.isCalibrating)
                AtmosphericCalibrationOverlay(
                  progress: midi.calibrationProgress,
                  onCancel: () => midi.cancelCalibration(),
                ),
            ],
          ),
        );
      },
    );
  }
}

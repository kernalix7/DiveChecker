// Copyright (C) 2025-2026 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../constants/app_constants.dart';
import '../models/chart_point.dart';
import '../providers/providers.dart';
import '../utils/formatters.dart';
import '../utils/ui_helpers.dart';
import '../widgets/status_badge.dart';
import '../widgets/measurement/measurement_widgets.dart';
import 'fullscreen_measurement_chart.dart';

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({super.key});

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  MeasurementController? _controller;
  bool _isInitialized = false;
  bool _wasConnected = false;
  bool _isShowingDisconnectDialog = false;

  // Store reference for dispose cleanup
  MidiProvider? _midiProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initController();
    });
  }

  void _initController() {
    if (_isInitialized) return;
    _midiProvider = context.read<MidiProvider>();
    _controller = MeasurementController(
      midiProvider: _midiProvider!,
    );
    _wasConnected = _midiProvider!.isConnected;
    
    // Listen for connection changes
    _midiProvider!.addListener(_onConnectionChanged);
    
    _isInitialized = true;
    setState(() {});
  }

  void _onConnectionChanged() {
    if (!mounted) return;
    final midi = _midiProvider;
    if (midi == null) return;
    final isConnected = midi.isConnected;
    final controller = _controller;
    
    // Detect disconnection during measurement
    if (_wasConnected && !isConnected && controller != null && controller.state.isMeasuring) {
      _handleDisconnectDuringMeasurement();
    }
    
    _wasConnected = isConnected;
  }

  void _handleDisconnectDuringMeasurement() {
    if (_isShowingDisconnectDialog) return;
    _isShowingDisconnectDialog = true;
    
    final controller = _controller;
    if (controller == null) return;
    
    // Stop measurement but keep data
    controller.stopMeasurement();
    
    _showDisconnectSaveDialog();
  }

  void _showDisconnectSaveDialog() {
    if (!mounted) return;  // Guard against showing dialog after unmount
    final l10n = AppLocalizations.of(context)!;
    final controller = _controller;
    if (controller == null) return;
    
    final noteController = TextEditingController();
    final state = controller.state;
    final settings = context.read<SettingsProvider>();

    // Capture references before async gap
    final sessionRepo = context.read<SessionRepository>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Icons.link_off,
          size: UIConstants.xlIconSize,
          color: Theme.of(dialogContext).colorScheme.error,
        ),
        title: Text(l10n.deviceDisconnected),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.connectionLostDuringMeasurement,
              style: TextStyle(
                color: Theme.of(dialogContext).colorScheme.error,
              ),
            ),
            Spacing.verticalLg,
            Text(
              '${l10n.maxPressure}: ${formatPressure(settings.convertPressure(state.maxPressure))} ${settings.pressureUnitSymbol}',
            ),
            Text(
              '${l10n.avgPressure}: ${formatPressure(settings.convertPressure(state.avgPressure))} ${settings.pressureUnitSymbol}',
            ),
            Text(
              '${l10n.elapsedTime}: ${formatDuration(state.elapsedTime.inSeconds)}',
            ),
            Spacing.verticalLg,
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: l10n.noteOptional,
                hintText: l10n.noteHint,
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _isShowingDisconnectDialog = false;
              Navigator.pop(dialogContext);
              controller.reset();
            },
            child: Text(l10n.discard),
          ),
          FilledButton(
            onPressed: () async {
              final savedId = await _saveSessionToRepo(noteController.text, sessionRepo);
              if (dialogContext.mounted) {
                _isShowingDisconnectDialog = false;
                Navigator.pop(dialogContext);
              }
              if (savedId != null && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.measurementSaved)),
                );
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    ).then((_) => noteController.dispose());
  }

  @override
  void dispose() {
    // Remove listener using stored reference (safe in dispose)
    if (_isInitialized && _midiProvider != null) {
      _midiProvider!.removeListener(_onConnectionChanged);
    }
    _controller?.dispose();
    super.dispose();
  }

  void _openFullscreenChart() {
    final controller = _controller;
    if (controller == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullscreenMeasurementChart(controller: controller),
      ),
    );
  }

  void _toggleMeasurement() {
    final controller = _controller;
    if (controller == null) return;

    if (controller.state.isMeasuring) {
      controller.stopMeasurement();
      _showSaveDialog();
    } else {
      if (!controller.isConnected) {
        _showConnectionRequiredDialog();
        return;
      }
      controller.startMeasurement();
      context.showSnackBar(AppLocalizations.of(context)!.measurementStarted);
    }
  }

  void _showConnectionRequiredDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.usb_off,
          size: UIConstants.xlIconSize,
          color: Theme.of(context).colorScheme.error,
        ),
        title: Text(l10n.connectionRequired),
        content: Text(
          l10n.connectionRequiredMessage,
          style: const TextStyle(fontSize: FontSizes.body),
        ),
        actions: [
          FilledButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.check),
            label: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showSaveDialog() {
    final controller = _controller;
    if (controller == null) return;

    final noteController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    final state = controller.state;
    final settings = context.read<SettingsProvider>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.measurementComplete),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.maxPressure}: ${formatPressure(settings.convertPressure(state.maxPressure))} ${settings.pressureUnitSymbol}',
            ),
            Text(
              '${l10n.avgPressure}: ${formatPressure(settings.convertPressure(state.avgPressure))} ${settings.pressureUnitSymbol}',
            ),
            Text(
              '${l10n.elapsedTime}: ${formatDuration(state.elapsedTime.inSeconds)}',
            ),
            Spacing.verticalLg,
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: l10n.noteOptional,
                hintText: l10n.noteHint,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              await _saveSession(noteController.text);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.measurementSaved)));
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    ).then((_) => noteController.dispose());
  }

  /// Save session with pre-captured SessionRepository (avoids context.read after async gap)
  Future<int?> _saveSessionToRepo(String notes, SessionRepository sessionRepo) async {
    final controller = _controller;
    if (controller == null) return null;

    try {
      // Get device info from MidiProvider
      final midiProvider = _midiProvider;
      final deviceSerial = midiProvider?.deviceSerial;
      final deviceName = midiProvider?.deviceName;

      final sessionId = await controller.saveSession(
        notes,
        deviceSerial: deviceSerial,
        deviceName: deviceName,
      );

      // Add to SessionRepository cache
      final state = controller.state;
      final newSession = SessionData(
        id: sessionId,
        date: state.sessionStartTime ?? DateTime.now(),
        maxPressure: state.maxPressure,
        avgPressure: state.avgPressure,
        duration: controller.actualDurationSeconds,
        notes: notes,
        deviceSerial: deviceSerial,
        deviceName: deviceName,
        chartData: List<ChartPoint>.from(state.pressureData),
        graphNotes: [],
      );

      sessionRepo.addSession(newSession);
      return sessionId;
    } catch (e) {
      _isShowingDisconnectDialog = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.failedToSaveSession(e.toString()))),
        );
      }
      return null;
    }
  }

  Future<void> _saveSession(String notes) async {
    final controller = _controller;
    if (controller == null) return;

    try {
      final midiProvider = _midiProvider;
      final deviceSerial = midiProvider?.deviceSerial;
      final deviceName = midiProvider?.deviceName;

      final sessionId = await controller.saveSession(
        notes,
        deviceSerial: deviceSerial,
        deviceName: deviceName,
      );

      final state = controller.state;
      final newSession = SessionData(
        id: sessionId,
        date: state.sessionStartTime ?? DateTime.now(),
        maxPressure: state.maxPressure,
        avgPressure: state.avgPressure,
        duration: controller.actualDurationSeconds,
        notes: notes,
        deviceSerial: deviceSerial,
        deviceName: deviceName,
        chartData: List<ChartPoint>.from(state.pressureData),
        graphNotes: [],
      );

      if (mounted) {
        context.read<SessionRepository>().addSession(newSession);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.failedToSaveSession(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = _controller;

    // Show loading until controller is initialized
    if (controller == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.measurement.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: LetterSpacings.wider,
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Consumer<MidiProvider>(
      builder: (context, midi, _) {
        return ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final state = controller.state;
            final isConnected = midi.isConnected;
            final screenPadding = Responsive.padding(context);
            final maxWidth = Responsive.maxContentWidth(context);

            return Scaffold(
              appBar: _buildAppBar(l10n, isConnected, state),
              body: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Padding(
                    padding: screenPadding,
                    child: Column(
                      children: [
                        PressureDisplay(
                          pressure: state.currentPressure,
                          isRecording: state.isMeasuring,
                        ),
                        const SizedBox(height: Spacing.sm),

                        if (state.isMeasuring &&
                            state.pressureData.isNotEmpty) ...[
                          StatsRow(
                            maxPressure: state.maxPressure,
                            avgPressure: state.avgPressure,
                            durationSeconds: controller.actualDurationSeconds,
                          ),
                          Spacing.verticalSm,
                        ],

                        Expanded(
                          child: PressureChart(
                            data: state.pressureData,
                            minX: state.minX,
                            maxX: state.maxX,
                            sampleRate: controller.outputRate,
                            onFullscreen: () => _openFullscreenChart(),
                          ),
                        ),

                        const SizedBox(height: Spacing.sm),

                        if (!state.isMeasuring)
                          ConnectionStatusBanner(isConnected: isConnected),

                        MeasurementControlButtons(
                          isMeasuring: state.isMeasuring,
                          isPaused: state.isPaused,
                          onToggleMeasurement: _toggleMeasurement,
                          onTogglePause: controller.togglePause,
                        ),
                        const SizedBox(height: Spacing.sm),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    AppLocalizations l10n,
    bool isConnected,
    MeasurementState state,
  ) {
    return AppBar(
      title: Text(
        l10n.measurement.toUpperCase(),
        style: const TextStyle(
          fontSize: FontSizes.titleSm,
          fontWeight: FontWeight.bold,
          letterSpacing: LetterSpacings.widest,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(
            right: state.isMeasuring ? Spacing.sm : Spacing.lg,
          ),
          child: StatusBadge(isConnected: isConnected),
        ),
        if (state.isMeasuring) const _RecordingIndicator(),
      ],
    );
  }
}

class _RecordingIndicator extends StatelessWidget {
  const _RecordingIndicator();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(right: Spacing.lg),
      child: Row(
        children: [
          Container(
            width: Spacing.sm,
            height: Spacing.sm,
            decoration: BoxDecoration(
              color: ScoreColors.poor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ScoreColors.poor.withValues(alpha: Opacities.mediumHigh),
                  blurRadius: Shadows.blurMedium,
                  spreadRadius: Shadows.spreadSmall,
                ),
              ],
            ),
          ),
          Spacing.horizontalSm,
          Text(
            l10n.recording,
            style: const TextStyle(
              fontSize: FontSizes.bodySm,
              fontWeight: FontWeight.bold,
              letterSpacing: LetterSpacings.wide,
            ),
          ),
        ],
      ),
    );
  }
}

// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../constants/app_constants.dart';
import '../providers/providers.dart';
import '../utils/formatters.dart';
import '../widgets/status_badge.dart';
import '../widgets/measurement/measurement_widgets.dart';

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({super.key});

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  MeasurementController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initController();
    });
  }

  void _initController() {
    if (_isInitialized) return;
    final serial = context.read<SerialProvider>();
    final settings = context.read<SettingsProvider>();
    _controller = MeasurementController(
      serialProvider: serial,
      settingsProvider: settings,
    );
    _isInitialized = true;
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.measurementStarted),
        ),
      );
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
    );
  }

  Future<void> _saveSession(String notes) async {
    final controller = _controller;
    if (controller == null) return;

    try {
      // Get device info from SerialProvider
      final serialProvider = context.read<SerialProvider>();
      final deviceSerial = serialProvider.deviceSerial;
      final deviceName = serialProvider.deviceName;

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
        duration: controller.actualDurationSeconds,  // Use actual data duration
        notes: notes,
        deviceSerial: deviceSerial,
        deviceName: deviceName,
        chartData: List<FlSpot>.from(state.pressureData),
        graphNotes: [],
      );

      if (mounted) {
        context.read<SessionRepository>().addSession(newSession);
      }
    } catch (e) {
      rethrow;
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

    return Consumer<SerialProvider>(
      builder: (context, serial, _) {
        return ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final state = controller.state;
            final isConnected = serial.isConnected;
            final screenPadding = Responsive.padding(context);
            final maxWidth = Responsive.maxContentWidth(context);

            return Scaffold(
              appBar: _buildAppBar(l10n, isConnected, state),
              body: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: screenPadding,
                      child: Column(
                        children: [
                          PressureDisplay(
                            pressure: state.currentPressure,
                            isRecording: state.isMeasuring,
                          ),
                          Spacing.verticalXl,

                          if (state.isMeasuring &&
                              state.pressureData.isNotEmpty) ...[
                            StatsRow(
                              maxPressure: state.maxPressure,
                              avgPressure: state.avgPressure,
                              durationSeconds: controller.actualDurationSeconds,
                            ),
                            Spacing.verticalXl,
                          ],

                          PressureChart(
                            data: state.pressureData,
                            minX: state.minX,
                            maxX: state.maxX,
                            sampleRate: controller.outputRate,
                          ),

                          Spacing.verticalXxl,

                          if (!state.isMeasuring)
                            ConnectionStatusBanner(isConnected: isConnected),

                          MeasurementControlButtons(
                            isMeasuring: state.isMeasuring,
                            isPaused: state.isPaused,
                            onToggleMeasurement: _toggleMeasurement,
                            onTogglePause: controller.togglePause,
                          ),
                        ],
                      ),
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
                  color: ScoreColors.poor.withOpacity(Opacities.mediumHigh),
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

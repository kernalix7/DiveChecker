// Copyright (C) 2025-2026 Createch (legal@createch.kr)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// Device Selection Screen
/// 
/// Scans for USB MIDI devices and allows user to select one for connection.
/// Uses flutter_midi_command for cross-platform support.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../constants/app_constants.dart';
import '../providers/midi_provider.dart';
import '../widgets/icon_container.dart';

class DeviceSelectionScreen extends StatefulWidget {
  const DeviceSelectionScreen({super.key});

  @override
  State<DeviceSelectionScreen> createState() => _DeviceSelectionScreenState();
}

class _DeviceSelectionScreenState extends State<DeviceSelectionScreen> {
  List<MidiDeviceInfo> _devices = [];
  bool _isScanning = false;
  String? _connectingDeviceId;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _scanDevices();
  }

  Future<void> _scanDevices() async {
    final midi = context.read<MidiProvider>();
    
    setState(() {
      _isScanning = true;
      _errorMessage = null;
      _devices = [];
    });

    try {
      final devices = await midi.scanDevices();
      
      if (mounted) {
        setState(() {
          _devices = devices;
          _isScanning = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Scan failed: $e';
          _isScanning = false;
        });
      }
    }
  }

  Future<void> _connectToDevice(MidiDeviceInfo device) async {
    // Block connection to non-DiveChecker devices
    if (!device.isDiveChecker) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          icon: Icon(
            Icons.warning_amber_rounded,
            size: 48,
            color: Theme.of(dialogContext).colorScheme.error,
          ),
          title: Text(l10n.unsupportedDevice),
          content: Text(l10n.onlyDiveCheckerSupported),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
      return;
    }
    
    final midi = context.read<MidiProvider>();
    
    setState(() {
      _connectingDeviceId = device.portName;
      _errorMessage = null;
    });

    try {
      final success = await midi.connect(device);
      
      if (mounted) {
        if (success) {
          Navigator.pop(context, true);
        } else {
          setState(() {
            _errorMessage = midi.errorMessage ?? 'Connection failed';
            _connectingDeviceId = null;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Connection error: $e';
          _connectingDeviceId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.selectUsbDevice,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: LetterSpacings.wider,
          ),
        ),
        actions: [
          if (_isScanning)
            const Padding(
              padding: EdgeInsets.all(Spacing.lg),
              child: SizedBox(
                width: WidgetSizes.containerMedium,
                height: WidgetSizes.containerMedium,
                child: CircularProgressIndicator(strokeWidth: ChartDimensions.strokeMedium),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _scanDevices,
              tooltip: l10n.rescan,
            ),
        ],
      ),
      body: Column(
        children: [
          // Info banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Spacing.lg),
            color: theme.colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                Icon(
                  Icons.usb,
                  color: theme.colorScheme.primary,
                ),
                Spacing.horizontalMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.usbMidiDevicesTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        l10n.connectViaCable,
                        style: TextStyle(
                          fontSize: FontSizes.bodySm,
                          color: theme.colorScheme.onSurface.withValues(alpha: Opacities.high),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Error message
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.md),
              color: theme.colorScheme.errorContainer,
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: theme.colorScheme.onErrorContainer,
                    size: IconSizes.sm,
                  ),
                  Spacing.horizontalSm,
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: theme.colorScheme.onErrorContainer,
                        fontSize: FontSizes.bodyMd,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          // Device list
          Expanded(
            child: _devices.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isScanning) ...[
                          const CircularProgressIndicator(),
                          Spacing.verticalLg,
                          Text(l10n.scanningForDevices),
                        ] else ...[
                          IconContainer(
                            icon: Icons.usb_off,
                            size: IconSizes.display * 1.67,
                            color: StatusColors.tertiaryText,
                          ),
                          Spacing.verticalLg,
                          Text(
                            l10n.noUsbDevicesFound,
                            style: TextStyle(
                              fontSize: FontSizes.bodyLg,
                              color: StatusColors.secondaryText,
                            ),
                          ),
                          Spacing.verticalSm,
                          Text(
                            l10n.connectDeviceViaCable,
                            style: TextStyle(
                              fontSize: FontSizes.body,
                              color: StatusColors.tertiaryText,
                            ),
                          ),
                          Spacing.verticalXl,
                          OutlinedButton.icon(
                            onPressed: _scanDevices,
                            icon: const Icon(Icons.refresh),
                            label: Text(l10n.scanAgain),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                    itemCount: _devices.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final device = _devices[index];
                      final isConnecting = _connectingDeviceId == device.portName;
                      
                      return _DeviceTile(
                        device: device,
                        isConnecting: isConnecting,
                        onTap: isConnecting ? null : () => _connectToDevice(device),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  final MidiDeviceInfo device;
  final bool isConnecting;
  final VoidCallback? onTap;

  const _DeviceTile({
    required this.device,
    required this.isConnecting,
    this.onTap,
  });

  /// Normalize platform-specific MIDI device IDs for display
  /// Android: "0", "1" → shown as-is
  /// Linux: "28:0" or "hw:1,0,0" → shown as-is
  /// macOS/iOS: long CoreMIDI endpoint → last 8 chars
  /// Windows: long USB path → extract VID/PID or last 8 chars
  String _formatDeviceId(String rawId) {
    // Short IDs (Android integer, Linux ALSA) — show as-is
    if (rawId.length <= 12) return rawId;
    // Windows USB path: extract VID & PID if present
    final vidMatch = RegExp(r'vid_([0-9a-fA-F]{4})').firstMatch(rawId);
    final pidMatch = RegExp(r'pid_([0-9a-fA-F]{4})').firstMatch(rawId);
    if (vidMatch != null && pidMatch != null) {
      return '${vidMatch.group(1)!.toUpperCase()}:${pidMatch.group(1)!.toUpperCase()}';
    }
    // Long IDs (macOS CoreMIDI, etc.) — show last 8 chars
    return '...${rawId.substring(rawId.length - 8)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.sm),
      leading: Container(
        width: IconSizes.display,
        height: IconSizes.display,
        decoration: BoxDecoration(
          color: device.isDiveChecker 
              ? theme.colorScheme.primary.withValues(alpha: Opacities.veryLow)
              : Colors.grey.withValues(alpha: Opacities.veryLow),
          borderRadius: BorderRadii.mdAll,
        ),
        child: Icon(
          device.isDiveChecker ? Icons.sensors : Icons.usb,
          color: device.isDiveChecker ? theme.colorScheme.primary : Colors.grey,
        ),
      ),
      title: Text(
        device.displayName,
        style: TextStyle(
          fontWeight: device.isDiveChecker ? FontWeight.bold : FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show MIDI device name (consistent across platforms)
          Text(
            device.name,
            style: TextStyle(
              fontSize: FontSizes.bodySm,
              color: theme.colorScheme.onSurface.withValues(alpha: Opacities.mediumHigh),
            ),
          ),
          // Show device ID in a platform-normalized way
          Text(
            'ID: ${_formatDeviceId(device.portName)}',
            style: TextStyle(
              fontSize: FontSizes.sm,
              fontFamily: 'monospace',
              color: theme.colorScheme.onSurface.withValues(alpha: Opacities.medium),
            ),
          ),
          if (device.isDiveChecker)
            Container(
              margin: const EdgeInsets.only(top: Spacing.xs),
              padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xxs),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadii.xsAll,
              ),
              child: Text(
                AppLocalizations.of(context)!.diveCheckerCompatible,
                style: TextStyle(
                  fontSize: FontSizes.sm,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
        ],
      ),
      trailing: isConnecting
          ? const SizedBox(
              width: IconSizes.lg,
              height: IconSizes.lg,
              child: CircularProgressIndicator(strokeWidth: ChartDimensions.strokeMedium),
            )
          : Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withValues(alpha: Opacities.mediumHigh),
            ),
      onTap: onTap,
    );
  }
}

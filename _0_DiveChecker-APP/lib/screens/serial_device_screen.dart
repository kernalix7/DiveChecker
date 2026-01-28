// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// Serial Device Selection Screen
/// 
/// Scans for USB MIDI devices and allows user to select one for connection.
/// Uses flutter_midi_command for cross-platform support.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../constants/app_constants.dart';
import '../providers/serial_provider.dart';
import '../widgets/icon_container.dart';

class SerialDeviceScreen extends StatefulWidget {
  const SerialDeviceScreen({super.key});

  @override
  State<SerialDeviceScreen> createState() => _SerialDeviceScreenState();
}

class _SerialDeviceScreenState extends State<SerialDeviceScreen> {
  List<SerialDeviceInfo> _devices = [];
  bool _isScanning = false;
  String? _connectingDeviceId;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _scanDevices();
  }

  Future<void> _scanDevices() async {
    final serial = context.read<SerialProvider>();
    
    setState(() {
      _isScanning = true;
      _errorMessage = null;
      _devices = [];
    });

    try {
      final devices = await serial.scanDevices();
      
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

  Future<void> _connectToDevice(SerialDeviceInfo device) async {
    final serial = context.read<SerialProvider>();
    
    setState(() {
      _connectingDeviceId = device.portName;
      _errorMessage = null;
    });

    try {
      final success = await serial.connect(device);
      
      if (mounted) {
        if (success) {
          Navigator.pop(context, true);
        } else {
          setState(() {
            _errorMessage = serial.errorMessage ?? 'Connection failed';
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
                        'USB MIDI Devices',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Connect your pressure sensor via USB cable',
                        style: TextStyle(
                          fontSize: FontSizes.bodySm,
                          color: theme.colorScheme.onSurface.withOpacity(Opacities.high),
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
                            'No USB devices found',
                            style: TextStyle(
                              fontSize: FontSizes.bodyLg,
                              color: StatusColors.secondaryText,
                            ),
                          ),
                          Spacing.verticalSm,
                          Text(
                            'Connect your device via USB cable',
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
                    separatorBuilder: (_, __) => const Divider(height: 1),
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
  final SerialDeviceInfo device;
  final bool isConnecting;
  final VoidCallback? onTap;

  const _DeviceTile({
    required this.device,
    required this.isConnecting,
    this.onTap,
  });

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
              ? theme.colorScheme.primary.withOpacity(Opacities.veryLow)
              : Colors.grey.withOpacity(Opacities.veryLow),
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
          if (device.manufacturer != null && device.manufacturer!.isNotEmpty)
            Text(
              device.manufacturer!,
              style: TextStyle(
                fontSize: FontSizes.bodySm,
                color: theme.colorScheme.onSurface.withOpacity(Opacities.medium),
              ),
            ),
          Row(
            children: [
              Text(
                device.portName,
                style: TextStyle(
                  fontSize: FontSizes.bodySm,
                  fontFamily: 'monospace',
                  color: theme.colorScheme.onSurface.withOpacity(Opacities.mediumHigh),
                ),
              ),
              if (device.vendorId != null) ...[
                Spacing.horizontalSm,
                Text(
                  'VID: ${device.vendorId!.toRadixString(16).toUpperCase().padLeft(4, '0')}',
                  style: TextStyle(
                    fontSize: FontSizes.sm,
                    fontFamily: 'monospace',
                    color: theme.colorScheme.onSurface.withOpacity(Opacities.medium),
                  ),
                ),
              ],
              if (device.productId != null) ...[
                Spacing.horizontalXs,
                Text(
                  'PID: ${device.productId!.toRadixString(16).toUpperCase().padLeft(4, '0')}',
                  style: TextStyle(
                    fontSize: FontSizes.sm,
                    fontFamily: 'monospace',
                    color: theme.colorScheme.onSurface.withOpacity(Opacities.medium),
                  ),
                ),
              ],
            ],
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
                'DiveChecker Compatible',
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
              color: theme.colorScheme.onSurface.withOpacity(Opacities.mediumHigh),
            ),
      onTap: onTap,
    );
  }
}

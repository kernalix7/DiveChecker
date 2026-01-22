// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0.

/// Device-specific Settings Screen
/// 
/// Shows detailed settings for a connected DiveChecker device.
/// Designed to support multiple product variants (V1, V2, etc.)
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../providers/serial_provider.dart';
import '../utils/ui_helpers.dart';
import '../widgets/common/styled_container.dart';
import '../widgets/section_header.dart';
import '../widgets/icon_container.dart';
import 'firmware_update_screen.dart';

/// Device product information
class DeviceProductInfo {
  final String productName;      // "DiveChecker V1"
  final String productId;        // "DC-V1"
  final String? firmwareVersion; // "4.5.0"
  final String? serialNumber;
  final bool isAuthenticated;
  final IconData icon;
  
  const DeviceProductInfo({
    required this.productName,
    required this.productId,
    this.firmwareVersion,
    this.serialNumber,
    this.isAuthenticated = false,
    this.icon = Icons.sensors,
  });
}

class DeviceSettingsScreen extends StatefulWidget {
  const DeviceSettingsScreen({super.key});

  @override
  State<DeviceSettingsScreen> createState() => _DeviceSettingsScreenState();
}

class _DeviceSettingsScreenState extends State<DeviceSettingsScreen> {
  final _pinController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  DeviceProductInfo _getDeviceInfo(SerialProvider provider) {
    // Parse device info from SerialProvider
    final serial = provider.deviceSerial;
    final isAuth = provider.isDeviceAuthenticated;
    
    // Determine product variant from firmware version or name
    String productName = AppConfig.productNameV1;
    String productId = AppConfig.productIdV1;
    
    // TODO: Parse actual firmware version from device response
    String? firmwareVersion;
    if (provider.isConnected) {
      firmwareVersion = AppConfig.defaultFirmwareVersion; // Placeholder - should come from device
    }
    
    return DeviceProductInfo(
      productName: productName,
      productId: productId,
      firmwareVersion: firmwareVersion,
      serialNumber: serial,
      isAuthenticated: isAuth,
      icon: Icons.sensors,
    );
  }

  Future<void> _showChangePinDialog(BuildContext context, AppLocalizations l10n, SerialProvider provider) async {
    final currentPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.changeDevicePin),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPinController,
              decoration: InputDecoration(
                labelText: l10n.currentPin,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
            ),
            Spacing.verticalLg,
            TextField(
              controller: newPinController,
              decoration: InputDecoration(
                labelText: l10n.newPin,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
            ),
            Spacing.verticalLg,
            TextField(
              controller: confirmPinController,
              decoration: InputDecoration(
                labelText: l10n.confirmPin,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (newPinController.text != confirmPinController.text) {
                context.showSnackBar(l10n.pinMismatch);
                return;
              }
              if (newPinController.text.length != 4) {
                context.showSnackBar(l10n.pinMustBe4Digits);
                return;
              }
              // Send PIN change command: W:currentPin:newPin
              provider.sendCommand('W:${currentPinController.text}:${newPinController.text}');
              Navigator.pop(context);
              context.showSnackBar(l10n.pinChangeRequested);
            },
            child: Text(l10n.change),
          ),
        ],
      ),
    );
  }

  Future<void> _showChangeNameDialog(BuildContext context, AppLocalizations l10n, SerialProvider provider) async {
    _nameController.text = provider.deviceName ?? 'DiveChecker';
    _pinController.clear();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.changeDeviceName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _pinController,
              decoration: InputDecoration(
                labelText: l10n.devicePin,
                border: const OutlineInputBorder(),
                helperText: l10n.pinRequiredForChange,
              ),
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
            ),
            Spacing.verticalLg,
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.newDeviceName,
                border: const OutlineInputBorder(),
              ),
              maxLength: 24,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (_pinController.text.length != 4) {
                context.showSnackBar(l10n.pinMustBe4Digits);
                return;
              }
              // Send name change command: N:pin:newName
              provider.sendCommand('N:${_pinController.text}:${_nameController.text}');
              Navigator.pop(context);
              context.showSnackBar(l10n.nameChangeRequested);
            },
            child: Text(l10n.change),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<SerialProvider>(
      builder: (context, serialProvider, _) {
        if (!serialProvider.isConnected) {
          // Device disconnected - go back
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) Navigator.pop(context);
          });
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        final deviceInfo = _getDeviceInfo(serialProvider);
        final shortSerial = deviceInfo.serialNumber != null && deviceInfo.serialNumber!.length >= 4
            ? deviceInfo.serialNumber!.substring(deviceInfo.serialNumber!.length - 4)
            : '';
        
        return Scaffold(
          appBar: AppBar(
            title: Text(deviceInfo.productName),
          ),
          body: ListView(
            padding: Spacing.screenPadding,
            children: [
              // Device Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.lg),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(Spacing.lg),
                        decoration: BoxDecoration(
                          color: deviceInfo.isAuthenticated
                              ? StatusColors.connected.withOpacity(Opacities.low)
                              : StatusColors.warning.withOpacity(Opacities.low),
                          borderRadius: BorderRadii.lgAll,
                        ),
                        child: Icon(
                          deviceInfo.icon,
                          size: IconSizes.huge,
                          color: deviceInfo.isAuthenticated ? StatusColors.connected : StatusColors.warning,
                        ),
                      ),
                      Spacing.horizontalLg,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              serialProvider.deviceName ?? deviceInfo.productName,
                              style: const TextStyle(
                                fontSize: FontSizes.titleSm,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacing.verticalXs,
                            Text(
                              'S/N: ${deviceInfo.serialNumber ?? 'Unknown'}',
                              style: TextStyle(
                                fontSize: FontSizes.bodySm,
                                color: StatusColors.neutral,
                              ),
                            ),
                            Spacing.verticalXs,
                            Row(
                              children: [
                                Icon(
                                  deviceInfo.isAuthenticated ? Icons.verified : Icons.gpp_maybe,
                                  size: IconSizes.sm,
                                  color: deviceInfo.isAuthenticated ? StatusColors.connected : StatusColors.warning,
                                ),
                                Spacing.horizontalXs,
                                Text(
                                  deviceInfo.isAuthenticated
                                      ? l10n.deviceAuthenticated
                                      : l10n.deviceNotAuthenticated,
                                  style: TextStyle(
                                    fontSize: FontSizes.bodySm,
                                    color: deviceInfo.isAuthenticated ? StatusColors.connected : StatusColors.warning,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: Spacing.xl),
              
              // Device Settings Section
              SectionHeader(l10n.deviceSettings),
              Spacing.verticalSm,
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: IconContainer(
                        icon: Icons.edit,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(
                        l10n.deviceName,
                        style: AppTextStyles.semiBold,
                      ),
                      subtitle: Text('${serialProvider.deviceName ?? AppConfig.appName}${shortSerial.isNotEmpty ? '-$shortSerial' : ''}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showChangeNameDialog(context, l10n, serialProvider),
                    ),
                    const AppDivider(),
                    ListTile(
                      leading: IconContainer(
                        icon: Icons.lock,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(
                        l10n.devicePin,
                        style: AppTextStyles.semiBold,
                      ),
                      subtitle: Text(l10n.changeDevicePin),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showChangePinDialog(context, l10n, serialProvider),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: Spacing.xl),
              
              // Firmware Section
              SectionHeader(l10n.firmwareUpdate),
              Spacing.verticalSm,
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: IconContainer(
                        icon: Icons.info_outline,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(
                        l10n.currentFirmware,
                        style: AppTextStyles.semiBold,
                      ),
                      subtitle: Text('v${deviceInfo.firmwareVersion ?? 'Unknown'}'),
                    ),
                    const AppDivider(),
                    ListTile(
                      leading: IconContainer(
                        icon: Icons.system_update,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(
                        l10n.firmwareUpdate,
                        style: AppTextStyles.semiBold,
                      ),
                      subtitle: Text(l10n.firmwareUpdateDescription),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FirmwareUpdateScreen()),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: Spacing.xl),
              
              // Danger Zone
              SectionHeader(l10n.dangerZone),
              Spacing.verticalSm,
              Card(
                color: ScoreColors.poor.withOpacity(Opacities.veryLow),
                child: Column(
                  children: [
                    ListTile(
                      leading: IconContainer(
                        icon: Icons.restart_alt,
                        color: ScoreColors.warning,
                      ),
                      title: Text(
                        l10n.rebootDevice,
                        style: AppTextStyles.semiBold,
                      ),
                      subtitle: Text(l10n.rebootDeviceDescription),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _confirmReboot(context, l10n, serialProvider),
                    ),
                    const AppDivider(),
                    ListTile(
                      leading: IconContainer(
                        icon: Icons.developer_mode,
                        color: ScoreColors.poor,
                      ),
                      title: Text(
                        l10n.bootselMode,
                        style: AppTextStyles.semiBold,
                      ),
                      subtitle: Text(l10n.bootselModeDescription),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _confirmBootsel(context, l10n, serialProvider),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: Spacing.xxl),
            ],
          ),
        );
      },
    );
  }
  
  Future<void> _confirmReboot(BuildContext context, AppLocalizations l10n, SerialProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.restart_alt, size: IconSizes.huge, color: ScoreColors.warning),
        title: Text(l10n.rebootDevice),
        content: Text(l10n.rebootConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: ScoreColors.warning),
            child: Text(l10n.reboot),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Send soft reboot command (not BOOTSEL)
      // For now, we don't have a soft reboot command, just disconnect
      provider.disconnect();
      context.showSnackBar(l10n.deviceDisconnected);
    }
  }

  Future<void> _confirmBootsel(BuildContext context, AppLocalizations l10n, SerialProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.developer_mode, size: IconSizes.huge, color: ScoreColors.poor),
        title: Text(l10n.bootselMode),
        content: Text(l10n.firmwareRebootDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: ScoreColors.poor),
            child: Text(l10n.reboot),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      provider.sendCommand('B');  // BOOTSEL reboot command
      context.showSnackBar(l10n.bootselRebootSent);
    }
  }
}

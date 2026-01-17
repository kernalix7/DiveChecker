// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../constants/app_constants.dart';
import '../widgets/section_header.dart';
import '../widgets/icon_container.dart';
import '../widgets/settings/license_page.dart';
import '../providers/locale_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/serial_provider.dart';
import '../services/backup_service.dart';
import '../utils/file_helper.dart';
import 'device_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isBackingUp = false;
  bool _isRestoring = false;
  double _progress = 0.0;
  String _statusMessage = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();
    final screenPadding = Responsive.padding(context);
    final maxWidth = Responsive.maxContentWidth(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: const TextStyle(
            fontSize: FontSizes.titleSm,
            fontWeight: FontWeight.bold,
            letterSpacing: LetterSpacings.widest,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ListView(
            padding: screenPadding,
            children: [
              SectionHeader(l10n.language.toUpperCase()),
          Spacing.verticalSm,
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: IconContainer(
                    icon: Icons.language,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(
                    l10n.language,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(LocaleProvider.getDisplayName(localeProvider.locale)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showLanguageDialog(context),
                ),
              ],
            ),
          ),
          
          Spacing.verticalXxl,
          
          SectionHeader(l10n.appearance),
          Spacing.verticalSm,
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: IconContainer(
                    icon: Icons.palette_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(
                    l10n.theme,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(_getThemeDisplayName(context, context.watch<SettingsProvider>().themeMode)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showThemeDialog(context),
                ),
              ],
            ),
          ),
          
          Spacing.verticalXxl,
          
          SectionHeader(l10n.measurementSettings),
          Spacing.verticalSm,
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: IconContainer(
                    icon: Icons.straighten,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(
                    l10n.pressureUnit,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(context.watch<SettingsProvider>().pressureUnit.displayName),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showPressureUnitDialog(context),
                ),
                // Output Rate - Firmware setting (requires device connection)
                Consumer<SerialProvider>(
                  builder: (context, serialProvider, _) {
                    final isConnected = serialProvider.isConnected;
                    return Column(
                      children: [
                        Divider(height: Dimensions.dividerHeight, indent: WidgetSizes.dividerIndent, color: theme.colorScheme.outlineVariant),
                        ListTile(
                          leading: IconContainer(
                            icon: Icons.waves,
                            color: isConnected ? theme.colorScheme.primary : StatusColors.disabled,
                          ),
                          title: Text(
                            l10n.outputRate,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isConnected ? null : StatusColors.disabled,
                            ),
                          ),
                          subtitle: Text(
                            isConnected 
                                ? '${serialProvider.outputRate} Hz' 
                                : l10n.connectDeviceFirst,
                            style: TextStyle(color: isConnected ? null : StatusColors.disabled),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: isConnected ? null : StatusColors.disabled,
                          ),
                          enabled: isConnected,
                          onTap: isConnected ? () => _showOutputRateDialog(context, serialProvider) : null,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          
          // My Devices Section - Always show, navigate to device settings when connected
          const SizedBox(height: UIConstants.sectionSpacing),
          SectionHeader(l10n.myDevices),
          Spacing.verticalSm,
          Consumer<SerialProvider>(
            builder: (context, serialProvider, _) {
              if (!serialProvider.isConnected) {
                // No device connected
                return Card(
                  child: ListTile(
                    leading: IconContainer(
                      icon: Icons.sensors_off,
                      color: StatusColors.disabled,
                    ),
                    title: Text(
                      l10n.noDeviceConnected,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(l10n.tapToConnect),
                  ),
                );
              }
              
              final deviceName = serialProvider.deviceName ?? AppConfig.appName;
              final shortSerial = serialProvider.deviceSerial != null && 
                  serialProvider.deviceSerial!.length >= 4
                  ? serialProvider.deviceSerial!.substring(serialProvider.deviceSerial!.length - 4)
                  : '';
              final isAuth = serialProvider.isDeviceAuthenticated;
              
              return Card(
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(Spacing.sm),
                    decoration: BoxDecoration(
                      color: isAuth ? StatusColors.connected.withOpacity(Opacities.low) : StatusColors.warning.withOpacity(Opacities.low),
                      borderRadius: BorderRadii.mdAll,
                    ),
                    child: Icon(
                      Icons.sensors,
                      color: isAuth ? StatusColors.connected : StatusColors.warning,
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        '$deviceName${shortSerial.isNotEmpty ? '-$shortSerial' : ''}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Spacing.horizontalSm,
                      Icon(
                        isAuth ? Icons.verified : Icons.gpp_maybe,
                        size: IconSizes.sm,
                        color: isAuth ? StatusColors.connected : StatusColors.warning,
                      ),
                    ],
                  ),
                  subtitle: Text(AppConfig.productNameV1),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DeviceSettingsScreen()),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: UIConstants.sectionSpacing),
          
          SectionHeader(l10n.notifications),
          Spacing.verticalSm,
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: IconContainer(
                    icon: Icons.notifications,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(
                    l10n.enableNotifications,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(l10n.getAlertsForMeasurements),
                  value: true,
                  onChanged: (value) {
                  },
                ),
                Divider(height: Dimensions.dividerHeight, indent: WidgetSizes.dividerIndent, color: theme.colorScheme.outlineVariant),
                SwitchListTile(
                  secondary: IconContainer(
                    icon: Icons.vibration,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(
                    l10n.hapticFeedback,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(l10n.vibrateOnKeyActions),
                  value: true,
                  onChanged: (value) {
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: UIConstants.sectionSpacing),
          
          SectionHeader(l10n.dataManagement),
          Spacing.verticalSm,
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: IconContainer(
                    icon: Icons.cloud_download,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(
                    l10n.backupData,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(l10n.backupDataDescription),
                  trailing: _isBackingUp 
                    ? const SizedBox(
                        width: WidgetSizes.containerMediumLarge, 
                        height: WidgetSizes.containerMediumLarge, 
                        child: CircularProgressIndicator(strokeWidth: ChartDimensions.strokeMedium),
                      )
                    : const Icon(Icons.chevron_right),
                  onTap: _isBackingUp ? null : () => _performBackup(context, l10n),
                ),
                if (_isBackingUp || _isRestoring) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(value: _progress),
                        Spacing.verticalXs,
                        Text(
                          _statusMessage,
                          style: TextStyle(
                            fontSize: FontSizes.bodySm,
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        Spacing.verticalSm,
                      ],
                    ),
                  ),
                ],
                Divider(height: Dimensions.dividerHeight, indent: WidgetSizes.dividerIndent, color: theme.colorScheme.outlineVariant),
                ListTile(
                  leading: IconContainer(
                    icon: Icons.cloud_upload,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(
                    l10n.restoreData,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(l10n.restoreDataDescription),
                  trailing: _isRestoring 
                    ? const SizedBox(
                        width: WidgetSizes.containerMediumLarge, 
                        height: WidgetSizes.containerMediumLarge, 
                        child: CircularProgressIndicator(strokeWidth: ChartDimensions.strokeMedium),
                      )
                    : const Icon(Icons.chevron_right),
                  onTap: _isRestoring ? null : () => _performRestore(context, l10n),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: UIConstants.sectionSpacing),
          
          SectionHeader(l10n.about),
          Spacing.verticalSm,
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: IconContainer(
                    icon: Icons.info,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(
                    l10n.appVersion,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(AppConfig.versionDisplay),
                ),
                Divider(height: Dimensions.dividerHeight, indent: WidgetSizes.dividerIndent, color: theme.colorScheme.outlineVariant),
                ListTile(
                  leading: IconContainer(
                    icon: Icons.help_outline,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(
                    l10n.helpAndSupport,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                  },
                ),
                Divider(height: Dimensions.dividerHeight, indent: WidgetSizes.dividerIndent, color: theme.colorScheme.outlineVariant),
                ListTile(
                  leading: IconContainer(
                    icon: Icons.description,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(
                    l10n.licenses,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showCustomLicensePage(context, l10n, theme),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: UIConstants.sectionSpacing),
          
          Center(
            child: Column(
              children: [
                IconContainer(
                  icon: Icons.water_drop,
                  size: IconSizes.xl,
                  padding: Spacing.lg,
                  useGradient: true,
                ),
                Spacing.verticalLg,
                Text(
                  l10n.appTitle,
                  style: const TextStyle(
                    fontSize: FontSizes.titleLg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.verticalXs,
                Text(
                  l10n.appDescription,
                  style: TextStyle(
                    fontSize: FontSizes.bodySm,
                    color: StatusColors.neutral,
                    letterSpacing: LetterSpacings.normal,
                  ),
                ),
                Spacing.verticalLg,
                Text(
                  '© 2025-2026 Kim DaeHyun',
                  style: TextStyle(
                    fontSize: FontSizes.xs,
                    color: StatusColors.disabled,
                  ),
                ),
                Spacing.verticalXs,
                Text(
                  'kernalix7@kodenet.io',
                  style: TextStyle(
                    fontSize: FontSizes.xs,
                    color: StatusColors.disabled.withOpacity(Opacities.veryHigh),
                  ),
                ),
                Spacing.verticalXxl,
              ],
            ),
          ),
          
        ],
          ),
        ),
      ),
    );
  }

  Future<void> _performBackup(BuildContext context, AppLocalizations l10n) async {
    setState(() {
      _isBackingUp = true;
      _progress = 0.0;
      _statusMessage = '';
    });

    try {
      final backupService = BackupService();
      
      final backup = await backupService.createBackup(
        onProgress: (progress, status) {
          if (mounted) {
            setState(() {
              _progress = progress;
              _statusMessage = status;
            });
          }
        },
      );

      final jsonContent = backupService.backupToJson(backup);
      final filename = backupService.generateBackupFilename();

      final savedPath = await downloadFile(jsonContent, filename);

      if (mounted) {
        if (savedPath != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.backupSuccess}\n${l10n.sessionsCount(backup.stats.sessionCount)}, ${l10n.dataPointsCount(backup.stats.dataPointCount)}'),
              backgroundColor: ScoreColors.excellent,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.backupFailed),
              backgroundColor: ScoreColors.poor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.backupFailed}: $e'),
            backgroundColor: ScoreColors.poor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBackingUp = false;
          _progress = 0.0;
          _statusMessage = '';
        });
      }
    }
  }

  Future<void> _performRestore(BuildContext context, AppLocalizations l10n) async {
    try {
      final jsonContent = await pickAndReadFile();
      if (jsonContent == null) return;

      final backupService = BackupService();
      final backup = backupService.parseBackup(jsonContent);
      
      if (backup == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.invalidBackupFile),
              backgroundColor: ScoreColors.poor,
            ),
          );
        }
        return;
      }

      final validation = backupService.validateBackup(backup);
      
      if (!mounted) return;
      
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.restoreConfirm),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.restoreConfirmMessage),
              Spacing.verticalLg,
              Text('📦 ${l10n.sessionsCount(backup.stats.sessionCount)}'),
              Text('📊 ${l10n.dataPointsCount(backup.stats.dataPointCount)}'),
              if (validation.warnings.isNotEmpty) ...[
                Spacing.verticalSm,
                Text(
                  '⚠️ ${validation.warnings.join('\n')}',
                  style: const TextStyle(color: ScoreColors.warning, fontSize: FontSizes.bodySm),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.restore),
            ),
          ],
        ),
      );

      if (confirm != true || !mounted) return;

      setState(() {
        _isRestoring = true;
        _progress = 0.0;
        _statusMessage = '';
      });

      final result = await backupService.restoreBackup(
        backup,
        mode: RestoreMode.replace,
        onProgress: (progress, status) {
          if (mounted) {
            setState(() {
              _progress = progress;
              _statusMessage = status;
            });
          }
        },
      );

      if (mounted) {
        if (result.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.restoreSuccess}\n${l10n.sessionsCount(result.sessionsRestored)}'),
              backgroundColor: ScoreColors.excellent,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.restoreFailed}: ${result.errors.join(', ')}'),
              backgroundColor: ScoreColors.poor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.restoreFailed}: $e'),
            backgroundColor: ScoreColors.poor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRestoring = false;
          _progress = 0.0;
          _statusMessage = '';
        });
      }
    }
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.read<LocaleProvider>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: LocaleProvider.supportedLocales.map((locale) {
            final isSelected = localeProvider.locale == locale;
            return ListTile(
              leading: Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: isSelected ? Theme.of(context).colorScheme.primary : null,
              ),
              title: Text(LocaleProvider.getDisplayName(locale)),
              onTap: () {
                localeProvider.setLocale(locale);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  String _getThemeDisplayName(BuildContext context, AppThemeMode mode) {
    final l10n = AppLocalizations.of(context)!;
    switch (mode) {
      case AppThemeMode.system:
        return l10n.themeSystem;
      case AppThemeMode.light:
        return l10n.themeLight;
      case AppThemeMode.dark:
        return l10n.themeDark;
    }
  }

  void _showThemeDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsProvider = context.read<SettingsProvider>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppThemeMode.values.map((mode) {
            final isSelected = settingsProvider.themeMode == mode;
            return ListTile(
              leading: Icon(
                _getThemeIcon(mode),
                color: isSelected ? Theme.of(context).colorScheme.primary : null,
              ),
              title: Text(_getThemeDisplayName(context, mode)),
              trailing: isSelected
                  ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                settingsProvider.setThemeMode(mode);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  IconData _getThemeIcon(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return Icons.brightness_auto;
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
    }
  }

  void _showPressureUnitDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsProvider = context.read<SettingsProvider>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.pressureUnit),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: PressureUnit.values.map((unit) {
            final isSelected = settingsProvider.pressureUnit == unit;
            return ListTile(
              leading: Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: isSelected ? Theme.of(context).colorScheme.primary : null,
              ),
              title: Text(unit.displayName),
              subtitle: Text(unit.symbol),
              onTap: () {
                settingsProvider.setPressureUnit(unit);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showOutputRateDialog(BuildContext context, SerialProvider serialProvider) {
    final l10n = AppLocalizations.of(context)!;
    final currentRate = serialProvider.outputRate;
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.outputRate),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: OutputRate.values.map((rate) {
            final isSelected = rate.value == currentRate;
            return ListTile(
              leading: Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: Theme.of(dialogContext).colorScheme.primary,
              ),
              title: Text(rate.displayName),
              subtitle: Text(rate.description),
              onTap: () async {
                final success = await serialProvider.setOutputRate(rate.value);
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Output rate: ${rate.value} Hz')),
                  );
                }
                Navigator.of(dialogContext).pop();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showCustomLicensePage(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CustomLicensePage(l10n: l10n, theme: theme),
      ),
    );
  }
  
  void _showChangeNameDialog(BuildContext context, AppLocalizations l10n, SerialProvider serialProvider) {
    final nameController = TextEditingController(text: serialProvider.deviceName ?? '');
    final pinController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;
    String? errorMessage;
    
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.changeDeviceName),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.enterNewDeviceName,
                    border: const OutlineInputBorder(),
                  ),
                  maxLength: 24,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.enterNewDeviceName;
                    }
                    // Check UTF-8 byte length
                    final bytes = value.codeUnits.fold(0, (sum, code) {
                      if (code <= 0x7F) return sum + 1;
                      if (code <= 0x7FF) return sum + 2;
                      return sum + 3;
                    });
                    if (bytes > 24) {
                      return l10n.nameTooLong;
                    }
                    return null;
                  },
                ),
                Spacing.verticalMd,
                TextFormField(
                  controller: pinController,
                  decoration: InputDecoration(
                    labelText: l10n.enterCurrentPin,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length != 4 || !RegExp(r'^\d{4}$').hasMatch(value)) {
                      return l10n.pinMustBe4Digits;
                    }
                    return null;
                  },
                ),
                if (errorMessage != null) ...[
                  Spacing.verticalSm,
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: isLoading ? null : () async {
                if (!formKey.currentState!.validate()) return;
                
                setDialogState(() {
                  isLoading = true;
                  errorMessage = null;
                });
                
                final success = await serialProvider.setDeviceName(
                  nameController.text.trim(),
                  pinController.text,
                );
                
                if (!context.mounted) return;
                
                if (success) {
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.nameChanged)),
                  );
                } else {
                  setDialogState(() {
                    isLoading = false;
                    errorMessage = l10n.wrongPin;
                  });
                }
              },
              child: isLoading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(l10n.ok),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showChangePinDialog(BuildContext context, AppLocalizations l10n, SerialProvider serialProvider) {
    final oldPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;
    String? errorMessage;
    
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.changeDevicePin),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: oldPinController,
                  decoration: InputDecoration(
                    labelText: l10n.enterCurrentPin,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length != 4 || !RegExp(r'^\d{4}$').hasMatch(value)) {
                      return l10n.pinMustBe4Digits;
                    }
                    return null;
                  },
                ),
                Spacing.verticalMd,
                TextFormField(
                  controller: newPinController,
                  decoration: InputDecoration(
                    labelText: l10n.enterNewPin,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length != 4 || !RegExp(r'^\d{4}$').hasMatch(value)) {
                      return l10n.pinMustBe4Digits;
                    }
                    return null;
                  },
                ),
                Spacing.verticalMd,
                TextFormField(
                  controller: confirmPinController,
                  decoration: InputDecoration(
                    labelText: l10n.confirmNewPin,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  validator: (value) {
                    if (value != newPinController.text) {
                      return l10n.pinsMustMatch;
                    }
                    return null;
                  },
                ),
                if (errorMessage != null) ...[
                  Spacing.verticalSm,
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: isLoading ? null : () async {
                if (!formKey.currentState!.validate()) return;
                
                setDialogState(() {
                  isLoading = true;
                  errorMessage = null;
                });
                
                final success = await serialProvider.changeDevicePin(
                  oldPinController.text,
                  newPinController.text,
                );
                
                if (!context.mounted) return;
                
                if (success) {
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.pinChanged)),
                  );
                } else {
                  setDialogState(() {
                    isLoading = false;
                    errorMessage = l10n.wrongPin;
                  });
                }
              },
              child: isLoading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(l10n.ok),
            ),
          ],
        ),
      ),
    );
  }
}
// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';
import '../common/styled_container.dart';
import '../icon_container.dart';
import '../section_header.dart';

class LanguageSection extends StatelessWidget {
  final LocaleProvider localeProvider;
  final VoidCallback onTap;
  
  const LanguageSection({
    super.key,
    required this.localeProvider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(l10n.language.toUpperCase()),
        Spacing.verticalSm,
        Card(
          child: ListTile(
            leading: IconContainer(
              icon: Icons.language,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              l10n.language,
              style: AppTextStyles.semiBold,
            ),
            subtitle: Text(LocaleProvider.getDisplayName(localeProvider.locale)),
            trailing: const Icon(Icons.chevron_right),
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}

class NotificationsSection extends StatelessWidget {
  final bool notificationsEnabled;
  final bool hapticEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<bool> onHapticChanged;
  
  const NotificationsSection({
    super.key,
    required this.notificationsEnabled,
    required this.hapticEnabled,
    required this.onNotificationsChanged,
    required this.onHapticChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  style: AppTextStyles.semiBold,
                ),
                subtitle: Text(l10n.getAlertsForMeasurements),
                value: notificationsEnabled,
                onChanged: onNotificationsChanged,
              ),
              const AppDivider(),
              SwitchListTile(
                secondary: IconContainer(
                  icon: Icons.vibration,
                  color: theme.colorScheme.primary,
                ),
                title: Text(
                  l10n.hapticFeedback,
                  style: AppTextStyles.semiBold,
                ),
                subtitle: Text(l10n.vibrateOnKeyActions),
                value: hapticEnabled,
                onChanged: onHapticChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DataManagementSection extends StatelessWidget {
  final bool isBackingUp;
  final bool isRestoring;
  final double progress;
  final String statusMessage;
  final VoidCallback onBackup;
  final VoidCallback onRestore;
  final VoidCallback onClearData;
  
  const DataManagementSection({
    super.key,
    required this.isBackingUp,
    required this.isRestoring,
    required this.progress,
    required this.statusMessage,
    required this.onBackup,
    required this.onRestore,
    required this.onClearData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  style: AppTextStyles.semiBold,
                ),
                subtitle: Text(l10n.backupDataDescription),
                trailing: isBackingUp 
                  ? const SizedBox(
                      width: WidgetSizes.containerMediumLarge, 
                      height: WidgetSizes.containerMediumLarge, 
                      child: CircularProgressIndicator(strokeWidth: ChartDimensions.strokeMedium),
                    )
                  : const Icon(Icons.chevron_right),
                onTap: isBackingUp ? null : onBackup,
              ),
              
              if (isBackingUp || isRestoring) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(value: progress),
                      Spacing.verticalXs,
                      Text(
                        statusMessage,
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
              
              const AppDivider(),
              
              ListTile(
                leading: IconContainer(
                  icon: Icons.cloud_upload,
                  color: theme.colorScheme.primary,
                ),
                title: Text(
                  l10n.restoreData,
                  style: AppTextStyles.semiBold,
                ),
                subtitle: Text(l10n.restoreDataDescription),
                trailing: isRestoring
                  ? const SizedBox(
                      width: WidgetSizes.containerMediumLarge,
                      height: WidgetSizes.containerMediumLarge,
                      child: CircularProgressIndicator(strokeWidth: ChartDimensions.strokeMedium),
                    )
                  : const Icon(Icons.chevron_right),
                onTap: isRestoring ? null : onRestore,
              ),
              
              const AppDivider(),
              
              ListTile(
                leading: IconContainer(
                  icon: Icons.delete_forever,
                  color: theme.colorScheme.error,
                ),
                title: Text(
                  l10n.clearData,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.error,
                  ),
                ),
                subtitle: Text(l10n.deleteAllMeasurementData),
                trailing: Icon(Icons.chevron_right, color: theme.colorScheme.error),
                onTap: onClearData,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AppInfoSection extends StatelessWidget {
  final VoidCallback onLicensesTap;
  final VoidCallback onVersionTap;
  
  const AppInfoSection({
    super.key,
    required this.onLicensesTap,
    required this.onVersionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  style: AppTextStyles.semiBold,
                ),
                subtitle: const Text(AppConfig.versionDisplay),
                trailing: const Icon(Icons.chevron_right),
                onTap: onVersionTap,
              ),
              const AppDivider(),
              ListTile(
                leading: IconContainer(
                  icon: Icons.article,
                  color: theme.colorScheme.primary,
                ),
                title: Text(
                  l10n.licenses,
                  style: AppTextStyles.semiBold,
                ),
                subtitle: Text(l10n.openSourceLicenses),
                trailing: const Icon(Icons.chevron_right),
                onTap: onLicensesTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DeveloperSection extends StatelessWidget {
  final VoidCallback onExportTap;
  
  const DeveloperSection({
    super.key,
    required this.onExportTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader('Developer'),
        Spacing.verticalSm,
        Card(
          child: Column(
            children: [
              ListTile(
                leading: IconContainer(
                  icon: Icons.download,
                  color: theme.colorScheme.tertiary,
                ),
                title: Text(
                  l10n.exportDbToFile,
                  style: AppTextStyles.semiBold,
                ),
                subtitle: Text(l10n.exportDatabaseForDebugging),
                trailing: const Icon(Icons.chevron_right),
                onTap: onExportTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

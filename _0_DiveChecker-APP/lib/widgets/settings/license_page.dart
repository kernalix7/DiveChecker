// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../l10n/app_localizations.dart';

class CustomLicensePage extends StatelessWidget {
  final AppLocalizations l10n;
  final ThemeData theme;

  const CustomLicensePage({super.key, required this.l10n, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _LicenseHeader(l10n: l10n, theme: theme),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoCard(
                    icon: Icons.info_outline,
                    title: l10n.about,
                    content: l10n.appDescription,
                    color: theme.colorScheme.primary,
                  ),
                  Spacing.verticalLg,
                  
                  _InfoCard(
                    icon: Icons.copyright,
                    title: l10n.copyright,
                    content: '© 2025 Kim DaeHyun (kernalix7@kodenet.io)',
                    color: ScoreColors.warning,
                  ),
                  Spacing.verticalLg,
                  
                  _TappableInfoCard(
                    icon: Icons.gavel,
                    title: l10n.mitLicense,
                    content: l10n.mitLicenseContent,
                    color: ScoreColors.excellent,
                    l10n: l10n,
                    onTap: () => _showFullLicenseDialog(context),
                  ),
                  Spacing.verticalXl,
                  
                  _OpenSourceSection(l10n: l10n, theme: theme),
                  Spacing.verticalXl,
                  
                  _ViewAllLicensesButton(l10n: l10n),
                  Spacing.verticalXxl,
                  
                  _LicenseFooter(l10n: l10n, theme: theme),
                  Spacing.verticalXl,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullLicenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _LicenseDialog(theme: theme, l10n: l10n),
    );
  }
}

class _LicenseHeader extends StatelessWidget {
  final AppLocalizations l10n;
  final ThemeData theme;

  const _LicenseHeader({required this.l10n, required this.theme});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: WidgetSizes.expandedAppBarHeight,
      pinned: true,
      backgroundColor: theme.colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacing.verticalXl,
                Container(
                  padding: const EdgeInsets.all(Spacing.lg),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(Opacities.mediumLow),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.water_drop,
                    size: IconSizes.display,
                    color: Colors.white,
                  ),
                ),
                Spacing.verticalLg,
                Text(
                  l10n.appTitle,
                  style: const TextStyle(
                    fontSize: FontSizes.headline,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Spacing.verticalXs,
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: FontSizes.body,
                    color: Colors.white.withOpacity(Opacities.almostFull),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: color.withOpacity(Opacities.veryLow),
        borderRadius: BorderRadii.lgAll,
        border: Border.all(
          color: color.withOpacity(Opacities.mediumLow),
          width: Dimensions.dividerHeight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: color.withOpacity(Opacities.low),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: IconSizes.md),
          ),
          Spacing.horizontalMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: FontSizes.body,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Spacing.verticalSm,
                Text(
                  content,
                  style: TextStyle(
                    fontSize: FontSizes.bodySm,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(Opacities.high),
                    height: LineHeights.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TappableInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  const _TappableInfoCard({
    required this.icon,
    required this.title,
    required this.content,
    required this.color,
    required this.l10n,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Spacing.lg),
        decoration: BoxDecoration(
          color: color.withOpacity(Opacities.veryLow),
          borderRadius: BorderRadii.lgAll,
          border: Border.all(
            color: color.withOpacity(Opacities.mediumLow),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(Spacing.md),
              decoration: BoxDecoration(
                color: color.withOpacity(Opacities.low),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: IconSizes.md),
            ),
            Spacing.horizontalMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: FontSizes.body,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Spacing.verticalSm,
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: FontSizes.bodySm,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(Opacities.high),
                      height: LineHeights.normal,
                    ),
                  ),
                  Spacing.verticalSm,
                  Text(
                    l10n.tapToViewFullLicense,
                    style: TextStyle(
                      fontSize: FontSizes.tiny,
                      color: color.withOpacity(Opacities.almostFull),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: color.withOpacity(Opacities.mediumHigh),
              size: IconSizes.sm,
            ),
          ],
        ),
      ),
    );
  }
}

class _OpenSourceSection extends StatelessWidget {
  final AppLocalizations l10n;
  final ThemeData theme;

  const _OpenSourceSection({required this.l10n, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.openSourceLicenses.toUpperCase(),
          style: TextStyle(
            fontSize: FontSizes.bodySm,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: LetterSpacings.widest,
          ),
        ),
        Spacing.verticalMd,
        _LicenseItem(name: 'flutter_blue_plus', license: 'BSD-3-Clause', description: l10n.bleConnectivity, theme: theme),
        _LicenseItem(name: 'fl_chart', license: 'MIT', description: l10n.chartVisualization, theme: theme),
        _LicenseItem(name: 'sqflite', license: 'MIT', description: l10n.sqliteDatabase, theme: theme),
        _LicenseItem(name: 'provider', license: 'MIT', description: l10n.stateManagement, theme: theme),
        _LicenseItem(name: 'shared_preferences', license: 'BSD-3-Clause', description: l10n.localStorage, theme: theme),
        _LicenseItem(name: 'intl', license: 'BSD-3-Clause', description: l10n.internationalization, theme: theme),
      ],
    );
  }
}

class _LicenseItem extends StatelessWidget {
  final String name;
  final String license;
  final String description;
  final ThemeData theme;

  const _LicenseItem({
    required this.name,
    required this.license,
    required this.description,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadii.mdAll,
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(Opacities.mediumLow),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: WidgetSizes.containerHuge,
              height: WidgetSizes.containerHuge,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(Opacities.veryLow),
                borderRadius: BorderRadii.smAll,
              ),
              child: Center(
                child: Text(
                  name[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: FontSizes.bodyLg,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            Spacing.horizontalMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: FontSizes.body,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacing.verticalXxs,
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: FontSizes.bodySm,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(Opacities.veryLow),
                borderRadius: BorderRadii.smAll,
              ),
              child: Text(
                license,
                style: TextStyle(
                  fontSize: FontSizes.tiny,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewAllLicensesButton extends StatelessWidget {
  final AppLocalizations l10n;

  const _ViewAllLicensesButton({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          showLicensePage(
            context: context,
            applicationName: l10n.appTitle,
            applicationVersion: '1.0.0',
          );
        },
        icon: const Icon(Icons.description_outlined),
        label: Text(l10n.openSourceLicenses),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadii.mdAll,
          ),
        ),
      ),
    );
  }
}

class _LicenseFooter extends StatelessWidget {
  final AppLocalizations l10n;
  final ThemeData theme;

  const _LicenseFooter({required this.l10n, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.favorite,
            color: ScoreColors.poor.withOpacity(Opacities.mediumHigh),
            size: IconSizes.sm,
          ),
          Spacing.verticalSm,
          Text(
            l10n.madeWithFlutter,
            style: TextStyle(
              fontSize: FontSizes.bodySm,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _LicenseDialog extends StatelessWidget {
  final ThemeData theme;
  final AppLocalizations l10n;

  const _LicenseDialog({required this.theme, required this.l10n});

  static const String _apacheLicenseText = '''Apache License
Version 2.0, January 2004
http://www.apache.org/licenses/

TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

1. Definitions.
"License" shall mean the terms and conditions for use, reproduction, and distribution as defined by Sections 1 through 9 of this document.

2. Grant of Copyright License.
Subject to the terms and conditions of this License, each Contributor hereby grants You a perpetual, worldwide, non-exclusive, no-charge, royalty-free copyright license to reproduce, prepare Derivative Works of, publicly display, publicly perform, sublicense, and distribute the Work and such Derivative Works in Source or Object form.

3. Grant of Patent License.
Subject to the terms and conditions of this License, each Contributor hereby grants You a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable patent license to make, have made, use, offer to sell, sell, import, and otherwise transfer the Work.

4. Redistribution.
You may reproduce and distribute copies of the Work or Derivative Works provided that You give proper attribution, include this License and NOTICE, and state significant changes.

5. Trademark.
This License does not grant permission to use trade names, trademarks, service marks, or product names of the Licensor.

6. Disclaimer of Warranty.
Unless required by applicable law or agreed to in writing, Licensor provides the Work on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND.

7. Limitation of Liability.
In no event and under no legal theory shall any Contributor be liable for damages arising out of the use of the Work.

For the complete license text, see: https://www.apache.org/licenses/LICENSE-2.0
''';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadii.lgAll),
      child: Container(
        constraints: const BoxConstraints(maxWidth: WidgetSizes.maxSizeDialog, maxHeight: WidgetSizes.maxSizeDialog),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(Spacing.xl),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(Opacities.veryLow),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(BorderRadii.lg)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.gavel,
                    color: theme.colorScheme.primary,
                    size: IconSizes.xl,
                  ),
                  Spacing.horizontalMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Apache License 2.0',
                          style: TextStyle(
                            fontSize: FontSizes.title,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Spacing.verticalXs,
                        Text(
                          '© 2025 Kim DaeHyun (kernalix7@kodenet.io)',
                          style: TextStyle(
                            fontSize: FontSizes.bodySm,
                            color: theme.colorScheme.onSurface.withOpacity(Opacities.medium),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Spacing.xl),
                child: Text(
                  _apacheLicenseText,
                  style: TextStyle(
                    fontSize: FontSizes.bodySm,
                    color: theme.colorScheme.onSurface.withOpacity(Opacities.almostFull),
                    height: LineHeights.relaxed,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(Spacing.lg),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(Opacities.mediumLow),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.close),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

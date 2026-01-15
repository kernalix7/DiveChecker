// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/providers.dart';

class SessionCard extends StatelessWidget {
  final SessionData session;
  final VoidCallback onTap;
  final VoidCallback onAnalyze;
  final String Function(DateTime) formatDate;
  final String Function(int) formatDuration;

  const SessionCard({
    super.key,
    required this.session,
    required this.onTap,
    required this.onAnalyze,
    required this.formatDate,
    required this.formatDuration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      elevation: Elevations.low,
      shape: RoundedRectangleBorder(borderRadius: BorderRadii.mdAll),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadii.mdAll,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, theme, l10n),
              Spacing.verticalSm,
              Text(
                formatDate(session.date),
                style: TextStyle(fontSize: FontSizes.bodyLg, color: theme.colorScheme.onSurfaceVariant),
              ),
              Spacing.verticalMd,
              _buildStatsRow(),
              if (session.notes.isNotEmpty) ...[
                Spacing.verticalMd,
                _buildNotesPreview(theme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            session.displayTitle?.isNotEmpty == true
                ? session.displayTitle!
                : l10n.measurementNumber(session.id ?? 0),
            style: const TextStyle(
              fontSize: FontSizes.title,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.analytics_outlined,
                color: theme.colorScheme.primary,
                size: IconSizes.lg,
              ),
              tooltip: l10n.peakAnalysis,
              onPressed: onAnalyze,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: WidgetSizes.minSizeButton, minHeight: WidgetSizes.minSizeButton),
            ),
            Icon(Icons.chevron_right, color: theme.colorScheme.outline),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        MiniStat(
          icon: Icons.arrow_upward,
          value: session.maxPressure.toStringAsFixed(1),
          color: ScoreColors.poor,
        ),
        Spacing.horizontalLg,
        MiniStat(
          icon: Icons.show_chart,
          value: session.avgPressure.toStringAsFixed(1),
          color: ScoreColors.excellent,
        ),
        Spacing.horizontalLg,
        MiniStat(
          icon: Icons.timer,
          value: formatDuration(session.duration),
          color: ScoreColors.intermediate,
        ),
      ],
    );
  }

  Widget _buildNotesPreview(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(Opacities.medium),
        borderRadius: BorderRadii.smAll,
      ),
      child: Text(
        session.notes,
        style: TextStyle(fontSize: FontSizes.body, color: theme.colorScheme.onPrimaryContainer),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const MiniStat({
    super.key,
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: IconSizes.sm, color: color),
        Spacing.horizontalXs,
        Text(
          value,
          style: TextStyle(
            fontSize: FontSizes.body,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class DetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const DetailCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: color.withOpacity(Opacities.light),
        borderRadius: BorderRadii.mdAll,
        border: Border.all(color: color.withOpacity(Opacities.mediumHigh)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.xsPlus),
            decoration: BoxDecoration(
              color: color.withOpacity(Opacities.mediumLow),
              borderRadius: BorderRadii.mdAll,
            ),
            child: Icon(icon, color: color, size: IconSizes.md),
          ),
          Spacing.verticalMd,
          Text(
            label,
            style: TextStyle(
              fontSize: FontSizes.bodySm,
              color: color.withOpacity(Opacities.nearFull),
              fontWeight: FontWeight.w600,
              letterSpacing: LetterSpacings.normal,
            ),
          ),
          Spacing.verticalXs,
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: FontSizes.title,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


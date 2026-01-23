// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../l10n/app_localizations.dart';

enum AnalysisType {
  peak,
  statistics,
  segment,
  trend,
  pattern,
}

class AnalysisTypeTabs extends StatelessWidget {
  final AnalysisType selectedType;
  final ValueChanged<AnalysisType> onTypeChanged;
  final VoidCallback? onDisabledTap;

  const AnalysisTypeTabs({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    this.onDisabledTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.sm),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _AnalysisTab(
              icon: Icons.show_chart,
              label: l10n.peakAnalysis,
              type: AnalysisType.peak,
              selectedType: selectedType,
              enabled: true,
              onTap: onTypeChanged,
            ),
            const SizedBox(width: Spacing.sm),
            _AnalysisTab(
              icon: Icons.dashboard,
              label: l10n.statisticsDashboard,
              type: AnalysisType.statistics,
              selectedType: selectedType,
              enabled: true,
              onTap: onTypeChanged,
            ),
            const SizedBox(width: Spacing.sm),
            _AnalysisTab(
              icon: Icons.view_timeline,
              label: l10n.segmentAnalysis,
              type: AnalysisType.segment,
              selectedType: selectedType,
              enabled: true,
              onTap: onTypeChanged,
            ),
            const SizedBox(width: Spacing.sm),
            _AnalysisTab(
              icon: Icons.trending_up,
              label: l10n.trendGraph,
              type: AnalysisType.trend,
              selectedType: selectedType,
              enabled: true,
              onTap: onTypeChanged,
            ),
            const SizedBox(width: Spacing.sm),
            _AnalysisTab(
              icon: Icons.pattern,
              label: l10n.patternRecognition,
              type: AnalysisType.pattern,
              selectedType: selectedType,
              enabled: true,
              onTap: onTypeChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalysisTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final AnalysisType type;
  final AnalysisType selectedType;
  final bool enabled;
  final ValueChanged<AnalysisType> onTap;

  const _AnalysisTab({
    required this.icon,
    required this.label,
    required this.type,
    required this.selectedType,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isSelected = selectedType == type;

    return GestureDetector(
      onTap: enabled ? () => onTap(type) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.smPlus),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : enabled
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.surfaceContainerHighest.withOpacity(Opacities.high),
          borderRadius: BorderRadii.xxlAll,
          border: isSelected
              ? null
              : Border.all(color: theme.colorScheme.outline.withOpacity(Opacities.low)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: IconSizes.sm + 2,
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : enabled
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.outline,
            ),
            Spacing.horizontalXs,
            Text(
              label,
              style: TextStyle(
                fontSize: FontSizes.md - 1,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : enabled
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.outline,
              ),
            ),
            if (!enabled) ...[
              Spacing.horizontalXs,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.xsPlus, vertical: Spacing.xxs),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadii.smAll,
                ),
                child: Text(
                  l10n.comingSoon,
                  style: TextStyle(
                    fontSize: FontSizes.xxs,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

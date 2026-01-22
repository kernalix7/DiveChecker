// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/peak_analyzer.dart';

class IntensityDistribution extends StatelessWidget {
  final PeakAnalysisResult result;

  const IntensityDistribution({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    final total = result.peaks.length;
    if (total == 0) {
      return const SizedBox.shrink();
    }

    final weakPct = result.weakPeakCount / total;
    final moderatePct = result.moderatePeakCount / total;
    final strongPct = result.strongPeakCount / total;

    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.mdAll,
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(Opacities.low)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          children: [
            _IntensityBar(
              weakPct: weakPct,
              moderatePct: moderatePct,
              strongPct: strongPct,
              l10n: l10n,
            ),
            Spacing.verticalMd,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _IntensityLegendItem(
                  label: l10n.weakIntensity,
                  color: ScoreColors.warning,
                  count: result.weakPeakCount,
                  total: total,
                ),
                _IntensityLegendItem(
                  label: l10n.moderateIntensity,
                  color: Colors.blue,
                  count: result.moderatePeakCount,
                  total: total,
                ),
                _IntensityLegendItem(
                  label: l10n.strongIntensity,
                  color: ScoreColors.excellent,
                  count: result.strongPeakCount,
                  total: total,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IntensityBar extends StatelessWidget {
  final double weakPct;
  final double moderatePct;
  final double strongPct;
  final AppLocalizations l10n;

  const _IntensityBar({
    required this.weakPct,
    required this.moderatePct,
    required this.strongPct,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadii.smAll,
      child: SizedBox(
        height: WidgetSizes.intensityBarHeight,
        child: Row(
          children: [
            if (weakPct > 0)
              Expanded(
                flex: (weakPct * 100).round(),
                child: Container(
                  color: ScoreColors.warning,
                  child: Center(
                    child: Text(
                      weakPct > 0.15 ? l10n.weak : '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: FontSizes.xs,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            if (moderatePct > 0)
              Expanded(
                flex: (moderatePct * 100).round(),
                child: Container(
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      moderatePct > 0.15 ? l10n.moderate : '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: FontSizes.xs,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            if (strongPct > 0)
              Expanded(
                flex: (strongPct * 100).round(),
                child: Container(
                  color: ScoreColors.excellent,
                  child: Center(
                    child: Text(
                      strongPct > 0.15 ? l10n.strong : '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: FontSizes.xs,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _IntensityLegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final int count;
  final int total;

  const _IntensityLegendItem({
    required this.label,
    required this.color,
    required this.count,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pct = total > 0 ? (count / total * 100).toStringAsFixed(0) : '0';
    
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: WidgetSizes.containerSmall,
              height: WidgetSizes.containerSmall,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadii.xsAll,
              ),
            ),
            Spacing.horizontalXs,
            Text(label, style: const TextStyle(fontSize: FontSizes.xxs)),
          ],
        ),
        Spacing.verticalXxs,
        Text(
          l10n.countWithPercent(count, pct),
          style: const TextStyle(fontSize: FontSizes.bodySm, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

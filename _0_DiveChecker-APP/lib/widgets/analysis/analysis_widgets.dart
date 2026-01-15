// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class MiniStatWidget extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const MiniStatWidget({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: FontSizes.sm, color: theme.colorScheme.outline),
        ),
        Spacing.verticalXs,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: FontSizes.titleSm, fontWeight: FontWeight.bold),
            ),
            Spacing.horizontalXs,
            Text(
              unit,
              style: TextStyle(fontSize: FontSizes.xs, color: theme.colorScheme.outline),
            ),
          ],
        ),
      ],
    );
  }
}

class ScoreBarWidget extends StatelessWidget {
  final String label;
  final double score;
  final double maxScore;
  final Color? color;

  const ScoreBarWidget({
    super.key,
    required this.label,
    required this.score,
    this.maxScore = 100.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scoreColor = color ?? ScoreColors.fromScore(score);
    final percentage = (score / maxScore).clamp(0.0, 1.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: FontSizes.body)),
            Text(
              '${score.toStringAsFixed(0)}점',
              style: TextStyle(
                fontSize: FontSizes.body,
                fontWeight: FontWeight.w600,
                color: scoreColor,
              ),
            ),
          ],
        ),
        Spacing.verticalXs,
        ClipRRect(
          borderRadius: BorderRadii.xsAll,
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: Dimensions.progressBarMedium,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(scoreColor),
          ),
        ),
      ],
    );
  }
}

class CompactMetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? unit;
  final Color? iconColor;

  const CompactMetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.unit,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;
    
    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.lgAll,
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(Opacities.medium)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(Spacing.sm),
              decoration: BoxDecoration(
                color: effectiveIconColor.withOpacity(Opacities.low),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: IconSizes.md, color: effectiveIconColor),
            ),
            Spacing.horizontalMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: FontSizes.bodySm,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  Spacing.verticalXs,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: FontSizes.title,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (unit != null) ...[
                        Spacing.horizontalXs,
                        Text(
                          unit!,
                          style: TextStyle(
                            fontSize: FontSizes.bodySm,
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ],
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

class MiniScoreCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double score;
  final String? description;

  const MiniScoreCard({
    super.key,
    required this.icon,
    required this.label,
    required this.score,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scoreColor = ScoreColors.fromScore(score);
    
    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.lgAll,
        side: BorderSide(color: scoreColor.withOpacity(Opacities.mediumHigh)),
      ),
      color: scoreColor.withOpacity(Opacities.veryLow),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: IconSizes.md, color: scoreColor),
                Spacing.horizontalSm,
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: FontSizes.body,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            Spacing.verticalSm,
            Row(
              children: [
                Text(
                  score.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: FontSizes.headline,
                    fontWeight: FontWeight.bold,
                    color: scoreColor,
                  ),
                ),
                Text(
                  '점',
                  style: TextStyle(
                    fontSize: FontSizes.body,
                    color: scoreColor.withOpacity(Opacities.almostFull),
                  ),
                ),
              ],
            ),
            if (description != null) ...[
              Spacing.verticalXs,
              Text(
                description!,
                style: TextStyle(
                  fontSize: FontSizes.sm,
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ChartLegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const ChartLegendItem({
    super.key,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: Dimensions.heatmapCell,
          height: Dimensions.heatmapCell,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadii.xsAll,
          ),
        ),
        Spacing.horizontalXs,
        Text(label, style: const TextStyle(fontSize: FontSizes.bodySm)),
      ],
    );
  }
}

class NoDataView extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const NoDataView({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.info_outline,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.section),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: IconSizes.display, color: theme.colorScheme.outline),
            Spacing.verticalLg,
            Text(
              title,
              style: const TextStyle(
                fontSize: FontSizes.title,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.verticalSm,
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: FontSizes.bodyLg,
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const StatRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: FontSizes.bodyMd,
              color: theme.colorScheme.outline,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: FontSizes.bodyMd,
              fontWeight: FontWeight.w600,
              color: valueColor ?? theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

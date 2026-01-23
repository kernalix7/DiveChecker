// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/peak_analyzer.dart';

class OverallGradeCard extends StatelessWidget {
  final PeakAnalysisResult result;

  const OverallGradeCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    final grade = result.overallGrade;
    final gradeLabel = ScoreColors.gradeLabel(grade);
    final gradeColor = ScoreColors.fromScore(grade);

    return Card(
      elevation: Elevations.medium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadii.lgAll),
      color: gradeColor.withOpacity(Opacities.low),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Row(
          children: [
            _GradeCircle(
              gradeLabel: gradeLabel,
              grade: grade,
              color: gradeColor,
              l10n: l10n,
            ),
            const SizedBox(width: Spacing.xl),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.overallGrade,
                    style: TextStyle(
                      fontSize: FontSizes.body,
                      color: theme.colorScheme.onSurface.withOpacity(Opacities.high),
                    ),
                  ),
                  Spacing.verticalXs,
                  Text(
                    _getGradeDescription(grade, l10n),
                    style: TextStyle(
                      fontSize: FontSizes.bodyLg,
                      fontWeight: FontWeight.w600,
                      color: gradeColor,
                    ),
                  ),
                  Spacing.verticalSm,
                  _MiniScoreBar(label: l10n.rhythmLabel, score: result.rhythmScore),
                  const SizedBox(height: Spacing.xs),
                  _MiniScoreBar(label: l10n.pressureLabel, score: result.pressureScore),
                  const SizedBox(height: Spacing.xs),
                  _MiniScoreBar(label: l10n.techniqueScore, score: result.techniqueScore),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGradeDescription(double score, AppLocalizations l10n) {
    if (score >= 90) return l10n.excellentFrenzel;
    if (score >= 80) return l10n.veryGoodTechnique;
    if (score >= 70) return l10n.satisfactoryLevel;
    if (score >= 60) return l10n.roomForImprovement;
    if (score >= 50) return l10n.moreTrainingNeeded;
    return l10n.startFromBasics;
  }
}

class _GradeCircle extends StatelessWidget {
  final String gradeLabel;
  final double grade;
  final Color color;
  final AppLocalizations l10n;

  const _GradeCircle({
    required this.gradeLabel,
    required this.grade,
    required this.color,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: WidgetSizes.containerLegend,
      height: WidgetSizes.containerLegend,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(Opacities.medium),
            blurRadius: Spacing.md,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            gradeLabel,
            style: const TextStyle(
              fontSize: FontSizes.headline,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            '${grade.toStringAsFixed(0)}${l10n.points}',
            style: const TextStyle(fontSize: FontSizes.bodySm, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _MiniScoreBar extends StatelessWidget {
  final String label;
  final double score;

  const _MiniScoreBar({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        SizedBox(
          width: WidgetSizes.containerXxl,
          child: Text(
            label,
            style: TextStyle(
              fontSize: FontSizes.xxs,
              color: theme.colorScheme.onSurface.withOpacity(Opacities.medium),
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadii.xsAll,
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: WidgetSizes.minSize,
              backgroundColor: theme.colorScheme.outline.withOpacity(Opacities.low),
              valueColor: AlwaysStoppedAnimation(ScoreColors.fromScore(score)),
            ),
          ),
        ),
        Spacing.horizontalXs,
        Text(
          '${score.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: FontSizes.xxs,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withOpacity(Opacities.high),
          ),
        ),
      ],
    );
  }
}

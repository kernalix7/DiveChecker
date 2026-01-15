// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import '../../constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/peak_analyzer.dart';
import 'analysis_widgets.dart';

/// 패턴 인식 뷰 위젯
class PatternRecognitionView extends StatelessWidget {
  final PeakAnalysisResult? analysisResult;
  final PeakAnalysisResult? filteredResult;
  final AppLocalizations l10n;

  const PatternRecognitionView({
    super.key,
    required this.analysisResult,
    required this.filteredResult,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    if (analysisResult == null || analysisResult!.peaks.isEmpty) {
      return NoDataView(
        title: l10n.noData,
        message: l10n.noPeaksDetected,
      );
    }

    final peaks = analysisResult!.peaks;
    final intervals = analysisResult!.peakIntervals;
    final result = filteredResult ?? analysisResult!;

    // 패턴 분석
    final patternResult = _analyzePattern(peaks, intervals);

    // 연속성 분석 (연속된 좋은 피크 수)
    final consecutiveAnalysis = _analyzeConsecutivePeaks(result);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 패턴 매칭 점수
          _PatternScoreCard(patternResult: patternResult, l10n: l10n),
          Spacing.verticalLg,

          // 개인화된 훈련 단계
          _TrainingPhaseCard(
            patternResult: patternResult,
            l10n: l10n,
          ),
          Spacing.verticalXxl,

          // 연속 수행 분석
          Text(
            l10n.continuousPerformanceAnalysis,
            style: const TextStyle(fontSize: FontSizes.title, fontWeight: FontWeight.bold),
          ),
          Spacing.verticalMd,
          _ConsecutiveAnalysisCard(
            analysis: consecutiveAnalysis,
            l10n: l10n,
          ),
          Spacing.verticalXxl,

          // 이상적인 패턴 vs 현재 패턴
          Text(
            l10n.patternComparison,
            style: const TextStyle(fontSize: FontSizes.title, fontWeight: FontWeight.bold),
          ),
          Spacing.verticalMd,
          _PatternComparisonChart(peaks: peaks, l10n: l10n),
          Spacing.verticalXxl,

          // 피크 품질 히트맵
          Text(
            l10n.peakQualityHeatmap,
            style: const TextStyle(fontSize: FontSizes.title, fontWeight: FontWeight.bold),
          ),
          Spacing.verticalMd,
          _PeakQualityHeatmap(result: result, l10n: l10n),
          Spacing.verticalXxl,

          // 패턴 특성 분석
          Text(
            l10n.patternCharacteristics,
            style: const TextStyle(fontSize: FontSizes.title, fontWeight: FontWeight.bold),
          ),
          Spacing.verticalMd,
          _PatternCharacteristics(patternResult: patternResult, l10n: l10n),
          Spacing.verticalXxl,

          // 상세 개선 제안
          Text(
            l10n.customTrainingSuggestions,
            style: const TextStyle(fontSize: FontSizes.title, fontWeight: FontWeight.bold),
          ),
          Spacing.verticalMd,

          ...(patternResult['suggestions'] as List<String>).map<Widget>(
            (suggestion) => Padding(
              padding: const EdgeInsets.only(bottom: Spacing.sm),
              child: _SuggestionCard(suggestion: suggestion),
            ),
          ),

          Spacing.verticalLg,

          // 훈련 팁
          _TrainingTipsCard(patternResult: patternResult, l10n: l10n),
        ],
      ),
    );
  }

  /// 연속 피크 분석
  Map<String, dynamic> _analyzeConsecutivePeaks(PeakAnalysisResult result) {
    if (result.peakDetails.isEmpty) {
      return {
        'maxConsecutiveGood': 0,
        'avgConsecutiveGood': 0.0,
        'totalGoodPeaks': 0,
        'goodPeakRatio': 0.0,
        'bestStreak': <int>[],
      };
    }

    const qualityThreshold = 70.0;
    int currentStreak = 0;
    int maxStreak = 0;
    int maxStreakStart = 0;
    int currentStreakStart = 0;
    int totalGood = 0;
    final streaks = <int>[];

    for (int i = 0; i < result.peakDetails.length; i++) {
      final detail = result.peakDetails[i];
      if (detail.qualityScore >= qualityThreshold) {
        if (currentStreak == 0) currentStreakStart = i;
        currentStreak++;
        totalGood++;
      } else {
        if (currentStreak > 0) {
          streaks.add(currentStreak);
          if (currentStreak > maxStreak) {
            maxStreak = currentStreak;
            maxStreakStart = currentStreakStart;
          }
        }
        currentStreak = 0;
      }
    }

    if (currentStreak > 0) {
      streaks.add(currentStreak);
      if (currentStreak > maxStreak) {
        maxStreak = currentStreak;
        maxStreakStart = currentStreakStart;
      }
    }

    final avgStreak =
        streaks.isEmpty ? 0.0 : streaks.reduce((a, b) => a + b) / streaks.length;
    final goodRatio = result.peakDetails.isEmpty
        ? 0.0
        : totalGood / result.peakDetails.length * 100;

    return {
      'maxConsecutiveGood': maxStreak,
      'avgConsecutiveGood': avgStreak,
      'totalGoodPeaks': totalGood,
      'goodPeakRatio': goodRatio,
      'bestStreakStart': maxStreakStart,
      'bestStreakEnd': maxStreakStart + maxStreak,
    };
  }

  /// 패턴 분석
  Map<String, dynamic> _analyzePattern(
    List<FlSpot> peaks,
    List<double> intervals,
  ) {
    final suggestions = <String>[];

    // 1. 리듬 점수 (간격 일관성)
    double rhythmScore = 100.0;
    if (intervals.length > 1) {
      final avgInterval = intervals.reduce((a, b) => a + b) / intervals.length;
      final intervalVariance =
          intervals.map((i) => pow(i - avgInterval, 2)).reduce((a, b) => a + b) /
              intervals.length;
      final intervalStdDev = sqrt(intervalVariance);
      final intervalCv = avgInterval > 0 ? (intervalStdDev / avgInterval) * 100 : 0;
      rhythmScore = max(0, 100 - intervalCv * 3);

      if (rhythmScore < 60) {
        suggestions.add(l10n.irregularIntervalSuggestion);
      }
    }

    // 2. 압력 점수 (압력 일관성)
    double pressureScore = 100.0;
    if (peaks.length > 1) {
      final pressures = peaks.map((p) => p.y).toList();
      final avgPressure = pressures.reduce((a, b) => a + b) / pressures.length;
      final pressureVariance =
          pressures.map((p) => pow(p - avgPressure, 2)).reduce((a, b) => a + b) /
              pressures.length;
      final pressureStdDev = sqrt(pressureVariance);
      final pressureCv =
          avgPressure > 0 ? (pressureStdDev / avgPressure) * 100 : 0;
      pressureScore = max(0, 100 - pressureCv * 2);

      if (pressureScore < 60) {
        suggestions.add(l10n.irregularPressureSuggestion);
      }
    }

    // 3. 빈도 점수
    double frequencyScore = 100.0;
    final freq = analysisResult!.frequencyPerMinute;
    if (freq < 15) {
      frequencyScore = 50 + (freq / 15) * 30;
      suggestions.add(l10n.lowFrequencySuggestion);
    } else if (freq > 60) {
      frequencyScore = 50 + ((100 - freq) / 40) * 30;
      suggestions.add(l10n.highFrequencySuggestion);
    } else if (freq >= 20 && freq <= 40) {
      frequencyScore = 100;
    } else {
      frequencyScore = 80;
    }

    // 4. 피로도 점수
    double enduranceScore = 100 - analysisResult!.fatigueIndex;
    if (analysisResult!.fatigueIndex > 30) {
      suggestions.add(l10n.fatigueDetectedSuggestion);
    }

    // 전체 점수
    final overallScore =
        (rhythmScore + pressureScore + frequencyScore + enduranceScore) / 4;

    // 패턴 타입 결정
    String patternType;
    String patternDescription;
    if (overallScore >= 80) {
      patternType = l10n.excellentPattern;
      patternDescription = l10n.excellentPatternDesc;
    } else if (overallScore >= 60) {
      patternType = l10n.goodPattern;
      patternDescription = l10n.goodPatternDesc;
    } else if (overallScore >= 40) {
      patternType = l10n.averagePattern;
      patternDescription = l10n.averagePatternDesc;
    } else {
      patternType = l10n.needsPractice;
      patternDescription = l10n.needsPracticeDesc;
    }

    if (suggestions.isEmpty) {
      suggestions.add(l10n.excellentPatternKeepUp);
    }

    return {
      'overallScore': overallScore,
      'rhythmScore': rhythmScore,
      'pressureScore': pressureScore,
      'frequencyScore': frequencyScore,
      'enduranceScore': enduranceScore,
      'patternType': patternType,
      'patternDescription': patternDescription,
      'suggestions': suggestions,
    };
  }
}

/// 패턴 점수 카드
class _PatternScoreCard extends StatelessWidget {
  final Map<String, dynamic> patternResult;
  final AppLocalizations l10n;

  const _PatternScoreCard({
    required this.patternResult,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final score = patternResult['overallScore'] as double;
    final color = ScoreColors.fromScore(score);

    return Card(
      elevation: Elevations.none,
      color: color.withOpacity(Opacities.low),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.xlAll,
        side: BorderSide(color: color.withOpacity(Opacities.mediumHigh)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Dimensions.scoreCircleXL,
                  height: Dimensions.scoreCircleXL,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: Dimensions.scoreCircleXL,
                        height: Dimensions.scoreCircleXL,
                        child: CircularProgressIndicator(
                          value: score / 100,
                          strokeWidth: ChartDimensions.strokeBold,
                          backgroundColor:
                              theme.colorScheme.outline.withOpacity(Opacities.medium),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            score.toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: FontSizes.display,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          Text(
                            l10n.points,
                            style: TextStyle(
                              fontSize: FontSizes.body,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacing.horizontalXxl,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.patternGrade(patternResult['patternType']),
                        style: TextStyle(
                          fontSize: FontSizes.title,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Spacing.verticalSm,
                      Text(
                        patternResult['patternDescription'],
                        style: const TextStyle(fontSize: FontSizes.bodyMd),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacing.verticalXl,
            _ScoreBar(label: l10n.rhythmLabel, score: patternResult['rhythmScore'] as double),
            Spacing.verticalSm,
            _ScoreBar(label: l10n.pressureLabel, score: patternResult['pressureScore'] as double),
            Spacing.verticalSm,
            _ScoreBar(label: l10n.frequencyLabel, score: patternResult['frequencyScore'] as double),
            Spacing.verticalSm,
            _ScoreBar(label: l10n.enduranceLabel, score: patternResult['enduranceScore'] as double),
          ],
        ),
      ),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  final String label;
  final double score;

  const _ScoreBar({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = ScoreColors.fromScore(score);

    return Row(
      children: [
        SizedBox(
          width: WidgetSizes.containerXHuge,
          child: Text(
            label,
            style: TextStyle(fontSize: FontSizes.body, color: theme.colorScheme.outline),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadii.xsAll,
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: theme.colorScheme.outline.withOpacity(Opacities.medium),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: Dimensions.progressBarMedium,
            ),
          ),
        ),
        Spacing.horizontalSm,
        SizedBox(
          width: WidgetSizes.containerXxxl,
          child: Text(
            '${score.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: FontSizes.body, fontWeight: FontWeight.w600),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

/// 훈련 단계 카드
class _TrainingPhaseCard extends StatelessWidget {
  final Map<String, dynamic> patternResult;
  final AppLocalizations l10n;

  const _TrainingPhaseCard({
    required this.patternResult,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overallScore = patternResult['overallScore'] as double;

    String phase;
    String phaseDescription;
    IconData phaseIcon;
    Color phaseColor;
    List<String> focuses;

    if (overallScore >= 85) {
      phase = l10n.masterPhase;
      phaseDescription = l10n.masterPhaseDesc;
      phaseIcon = Icons.military_tech;
      phaseColor = Colors.amber;
      focuses = l10n.masterFocuses.split(',');
    } else if (overallScore >= 70) {
      phase = l10n.advancedPhase;
      phaseDescription = l10n.advancedPhaseDesc;
      phaseIcon = Icons.trending_up;
      phaseColor = ScoreColors.advanced;
      focuses = l10n.advancedFocuses.split(',');
    } else if (overallScore >= 55) {
      phase = l10n.intermediatePhase;
      phaseDescription = l10n.intermediatePhaseDesc;
      phaseIcon = Icons.school;
      phaseColor = ScoreColors.intermediate;
      focuses = l10n.intermediateFocuses.split(',');
    } else {
      phase = l10n.basicPhase;
      phaseDescription = l10n.basicPhaseDesc;
      phaseIcon = Icons.fitness_center;
      phaseColor = ScoreColors.basic;
      focuses = l10n.basicFocuses.split(',');
    }

    return Card(
      elevation: Elevations.medium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadii.xlAll),
      color: phaseColor.withOpacity(Opacities.low),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(Spacing.smPlus),
                  decoration: BoxDecoration(
                    color: phaseColor,
                    borderRadius: BorderRadii.lgAll,
                  ),
                  child: Icon(phaseIcon, size: IconSizes.xl, color: Colors.white),
                ),
                Spacing.horizontalMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        phase,
                        style: TextStyle(
                          fontSize: FontSizes.title,
                          fontWeight: FontWeight.bold,
                          color: phaseColor,
                        ),
                      ),
                      Text(
                        phaseDescription,
                        style: TextStyle(
                          fontSize: FontSizes.body,
                          color: theme.colorScheme.onSurface.withOpacity(Opacities.veryHigh),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacing.verticalLg,
            Text(
              l10n.currentFocusAreas,
              style: TextStyle(
                fontSize: FontSizes.body,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(Opacities.veryHigh),
              ),
            ),
            Spacing.verticalSm,
            Wrap(
              spacing: Spacing.sm,
              runSpacing: Spacing.sm,
              children: focuses
                  .map(
                    (focus) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.md,
                        vertical: Spacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: phaseColor.withOpacity(Opacities.medium),
                        borderRadius: BorderRadii.circularAll,
                        border: Border.all(color: phaseColor.withOpacity(Opacities.mediumHigh)),
                      ),
                      child: Text(
                        focus.trim(),
                        style: TextStyle(
                          fontSize: FontSizes.body,
                          fontWeight: FontWeight.w500,
                          color: phaseColor,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// 연속 수행 분석 카드
class _ConsecutiveAnalysisCard extends StatelessWidget {
  final Map<String, dynamic> analysis;
  final AppLocalizations l10n;

  const _ConsecutiveAnalysisCard({
    required this.analysis,
    required this.l10n,
  });

  String _getStreakAdvice(int maxStreak, double goodRatio) {
    if (maxStreak >= 15 && goodRatio >= 80) {
      return l10n.excellentConsistency;
    } else if (maxStreak >= 10) {
      return l10n.goodConsistency;
    } else if (maxStreak >= 5) {
      return l10n.moderateConsistency;
    } else {
      return l10n.needsImprovementConsistency;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxStreak = analysis['maxConsecutiveGood'] as int;
    final avgStreak = analysis['avgConsecutiveGood'] as double;
    final goodRatio = analysis['goodPeakRatio'] as double;

    Color streakColor = maxStreak >= 10
        ? ScoreColors.excellent
        : maxStreak >= 5
            ? ScoreColors.good
            : ScoreColors.poor;

    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.lgAll,
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(Opacities.medium)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.local_fire_department, size: IconSizes.xxl, color: streakColor),
                      Spacing.verticalXs,
                      Text(
                        '$maxStreak',
                        style: TextStyle(
                          fontSize: FontSizes.display,
                          fontWeight: FontWeight.bold,
                          color: streakColor,
                        ),
                      ),
                      Text(
                        l10n.maxConsecutive,
                        style: TextStyle(fontSize: FontSizes.bodySm, color: theme.colorScheme.outline),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: Dimensions.dividerHeight,
                  height: WidgetSizes.boxplotHeight,
                  color: theme.colorScheme.outline.withOpacity(Opacities.medium),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.trending_up, size: IconSizes.xxl, color: theme.colorScheme.primary),
                      Spacing.verticalXs,
                      Text(
                        avgStreak.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: FontSizes.display,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        l10n.avgConsecutive,
                        style: TextStyle(fontSize: FontSizes.bodySm, color: theme.colorScheme.outline),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: Dimensions.dividerHeight,
                  height: WidgetSizes.boxplotHeight,
                  color: theme.colorScheme.outline.withOpacity(Opacities.medium),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, size: IconSizes.xxl, color: ScoreColors.excellent),
                      Spacing.verticalXs,
                      Text(
                        '${goodRatio.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: FontSizes.display,
                          fontWeight: FontWeight.bold,
                          color: ScoreColors.excellent,
                        ),
                      ),
                      Text(
                        l10n.qualityPeaks,
                        style: TextStyle(fontSize: FontSizes.bodySm, color: theme.colorScheme.outline),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacing.verticalMd,
            Container(
              padding: const EdgeInsets.all(Spacing.smPlus),
              decoration: BoxDecoration(
                color: streakColor.withOpacity(Opacities.low),
                borderRadius: BorderRadii.mdAll,
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb, size: IconSizes.md, color: streakColor),
                  Spacing.horizontalSm,
                  Expanded(
                    child: Text(
                      _getStreakAdvice(maxStreak, goodRatio),
                      style: TextStyle(
                        fontSize: FontSizes.body,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
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

/// 패턴 비교 차트
class _PatternComparisonChart extends StatelessWidget {
  final List<FlSpot> peaks;
  final AppLocalizations l10n;

  const _PatternComparisonChart({
    required this.peaks,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (peaks.isEmpty) return const SizedBox();

    // 현재 패턴: 피크 간 간격 정규화
    final currentPattern = <FlSpot>[];
    for (int i = 0; i < peaks.length && i < 10; i++) {
      currentPattern.add(FlSpot(i.toDouble(), peaks[i].y));
    }

    // 이상적인 패턴: 현재 평균 압력으로 일정한 패턴
    final avgPressure =
        peaks.map((p) => p.y).reduce((a, b) => a + b) / peaks.length;
    final idealPattern = <FlSpot>[];
    for (int i = 0; i < min(10, peaks.length); i++) {
      idealPattern.add(FlSpot(i.toDouble(), avgPressure));
    }

    final minY = peaks.map((p) => p.y).reduce(min) - 20;
    final maxY = peaks.map((p) => p.y).reduce(max) + 20;

    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.lgAll,
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(Opacities.medium)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ChartLegendItem(
                  color: theme.colorScheme.primary,
                  label: l10n.currentPattern,
                ),
                Spacing.horizontalLg,
                ChartLegendItem(
                  color: ScoreColors.excellent.withOpacity(Opacities.high),
                  label: l10n.idealPattern,
                ),
              ],
            ),
            Spacing.verticalMd,
            Builder(
              builder: (context) {
                final screenHeight = MediaQuery.of(context).size.height;
                final chartHeight = (screenHeight * 0.2).clamp(150.0, 300.0);
                return SizedBox(
                  height: chartHeight,
                  child: LineChart(
                    LineChartData(
                      minY: minY,
                      maxY: maxY,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: theme.colorScheme.outline.withOpacity(Opacities.low),
                          strokeWidth: ChartDimensions.strokeNormal,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: ChartDimensions.reservedSizeXl,
                            getTitlesWidget: (value, meta) => Text(
                              '${value.toInt()}',
                              style: TextStyle(
                                fontSize: FontSizes.sm,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: ChartDimensions.reservedSizeSmall,
                            getTitlesWidget: (value, meta) => Text(
                              '${value.toInt() + 1}',
                              style: TextStyle(
                                fontSize: FontSizes.sm,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        // 이상적인 패턴
                        LineChartBarData(
                          spots: idealPattern,
                          isCurved: false,
                          color: ScoreColors.excellent.withOpacity(Opacities.high),
                          barWidth: ChartDimensions.barWidthMedium,
                          dotData: const FlDotData(show: false),
                          dashArray: ChartDimensions.dashLong,
                          belowBarData: BarAreaData(
                            show: true,
                            color: ScoreColors.excellent.withOpacity(Opacities.low),
                          ),
                        ),
                        // 현재 패턴
                        LineChartBarData(
                          spots: currentPattern,
                          isCurved: false,
                          color: theme.colorScheme.primary,
                          barWidth: ChartDimensions.barWidthSmall,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                              radius: ChartDimensions.dotRadiusMedium,
                              color: theme.colorScheme.primary,
                              strokeWidth: ChartDimensions.strokeNone,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Spacing.verticalSm,
            Center(
              child: Text(
                l10n.peakNumber,
                style: TextStyle(fontSize: FontSizes.bodySm, color: theme.colorScheme.outline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 피크 품질 히트맵
class _PeakQualityHeatmap extends StatelessWidget {
  final PeakAnalysisResult result;
  final AppLocalizations l10n;

  const _PeakQualityHeatmap({
    required this.result,
    required this.l10n,
  });

  Color _getQualityHeatmapColor(double score) {
    if (score >= 80) return ScoreColors.excellent;
    if (score >= 60) return Colors.yellow.shade700;
    if (score >= 40) return ScoreColors.good;
    return ScoreColors.poorLight;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (result.peakDetails.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.lgAll,
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(Opacities.medium)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 히트맵 그리드
            Wrap(
              spacing: Spacing.xs,
              runSpacing: Spacing.xs,
              children: result.peakDetails.asMap().entries.map((entry) {
                final index = entry.key;
                final detail = entry.value;
                final color = _getQualityHeatmapColor(detail.qualityScore);
                final isOutlier = result.outlierIndices.contains(index);

                return Tooltip(
                  message: l10n.peakScore(
                    index + 1,
                    detail.qualityScore.toStringAsFixed(0),
                  ),
                  child: Container(
                    width: WidgetSizes.containerMediumLarge,
                    height: WidgetSizes.containerMediumLarge,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadii.xsAll,
                      border:
                          isOutlier ? Border.all(color: ScoreColors.poor, width: ChartDimensions.strokeSmMedium) : null,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: FontSizes.xs,
                          fontWeight: FontWeight.bold,
                          color:
                              detail.qualityScore >= 50 ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            Spacing.verticalMd,
            // 범례
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _HeatmapLegend(label: '0-40', color: ScoreColors.poorLight),
                Spacing.horizontalSm,
                _HeatmapLegend(label: '40-60', color: ScoreColors.good),
                Spacing.horizontalSm,
                _HeatmapLegend(label: '60-80', color: Colors.yellow.shade700),
                Spacing.horizontalSm,
                _HeatmapLegend(label: '80-100', color: ScoreColors.excellent),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeatmapLegend extends StatelessWidget {
  final String label;
  final Color color;

  const _HeatmapLegend({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: Dimensions.legendIndicator,
          height: Dimensions.legendIndicator,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadii.xsAll,
          ),
        ),
        Spacing.horizontalXs,
        Text(label, style: const TextStyle(fontSize: FontSizes.sm)),
      ],
    );
  }
}

/// 패턴 특성
class _PatternCharacteristics extends StatelessWidget {
  final Map<String, dynamic> patternResult;
  final AppLocalizations l10n;

  const _PatternCharacteristics({
    required this.patternResult,
    required this.l10n,
  });

  String _getCharacteristicLevel(double score) {
    if (score >= 90) return l10n.veryGood;
    if (score >= 75) return l10n.good;
    if (score >= 60) return l10n.average;
    if (score >= 40) return l10n.needsImprovement;
    return l10n.needsMorePractice;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.lgAll,
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(Opacities.medium)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          children: [
            _CharacteristicRow(
              label: l10n.rhythmConsistency,
              level: _getCharacteristicLevel(patternResult['rhythmScore'] as double),
              icon: Icons.music_note,
              score: patternResult['rhythmScore'] as double,
            ),
            const Divider(),
            _CharacteristicRow(
              label: l10n.pressureConsistency,
              level: _getCharacteristicLevel(patternResult['pressureScore'] as double),
              icon: Icons.compress,
              score: patternResult['pressureScore'] as double,
            ),
            const Divider(),
            _CharacteristicRow(
              label: l10n.frequencyAdequacy,
              level: _getCharacteristicLevel(patternResult['frequencyScore'] as double),
              icon: Icons.speed,
              score: patternResult['frequencyScore'] as double,
            ),
            const Divider(),
            _CharacteristicRow(
              label: l10n.enduranceLabel,
              level: _getCharacteristicLevel(patternResult['enduranceScore'] as double),
              icon: Icons.fitness_center,
              score: patternResult['enduranceScore'] as double,
            ),
          ],
        ),
      ),
    );
  }
}

class _CharacteristicRow extends StatelessWidget {
  final String label;
  final String level;
  final IconData icon;
  final double score;

  const _CharacteristicRow({
    required this.label,
    required this.level,
    required this.icon,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final color = ScoreColors.fromScore(score);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      child: Row(
        children: [
          Icon(icon, size: IconSizes.md, color: color),
          Spacing.horizontalMd,
          Expanded(child: Text(label, style: const TextStyle(fontSize: FontSizes.bodyLg))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.smPlus, vertical: Spacing.xs),
            decoration: BoxDecoration(
              color: color.withOpacity(Opacities.low),
              borderRadius: BorderRadii.lgAll,
            ),
            child: Text(
              level,
              style: TextStyle(
                fontSize: FontSizes.body,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 제안 카드
class _SuggestionCard extends StatelessWidget {
  final String suggestion;

  const _SuggestionCard({required this.suggestion});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.lgAll,
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(Opacities.medium)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb_outline, color: Colors.amber, size: IconSizes.md),
            Spacing.horizontalMd,
            Expanded(
              child: Text(suggestion, style: const TextStyle(fontSize: FontSizes.bodyMd)),
            ),
          ],
        ),
      ),
    );
  }
}

/// 훈련 팁 카드
class _TrainingTipsCard extends StatelessWidget {
  final Map<String, dynamic> patternResult;
  final AppLocalizations l10n;

  const _TrainingTipsCard({
    required this.patternResult,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rhythmScore = patternResult['rhythmScore'] as double;
    final pressureScore = patternResult['pressureScore'] as double;
    final frequencyScore = patternResult['frequencyScore'] as double;
    final enduranceScore = patternResult['enduranceScore'] as double;

    // 가장 낮은 점수 영역 찾기
    final scores = {
      'rhythm': rhythmScore,
      'pressure': pressureScore,
      'frequency': frequencyScore,
      'endurance': enduranceScore,
    };
    final weakestArea =
        scores.entries.reduce((a, b) => a.value < b.value ? a : b).key;

    String tipTitle;
    List<String> tips;
    IconData tipIcon;

    switch (weakestArea) {
      case 'rhythm':
        tipTitle = l10n.rhythmImprovementTraining;
        tipIcon = Icons.music_note;
        tips = [l10n.rhythmTip1, l10n.rhythmTip2, l10n.rhythmTip3];
        break;
      case 'pressure':
        tipTitle = l10n.pressureConsistencyTraining;
        tipIcon = Icons.compress;
        tips = [l10n.pressureTip1, l10n.pressureTip2, l10n.pressureTip3];
        break;
      case 'frequency':
        tipTitle = l10n.frequencyOptimizationTraining;
        tipIcon = Icons.speed;
        tips = [l10n.frequencyTip1, l10n.frequencyTip2, l10n.frequencyTip3];
        break;
      default:
        tipTitle = l10n.enduranceTraining;
        tipIcon = Icons.fitness_center;
        tips = [l10n.enduranceTip1, l10n.enduranceTip2, l10n.enduranceTip3];
    }

    return Card(
      elevation: Elevations.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadii.lgAll,
        side: BorderSide(color: ScoreColors.intermediate.withOpacity(Opacities.mediumHigh)),
      ),
      color: ScoreColors.intermediate.withOpacity(Opacities.veryLow),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(tipIcon, size: IconSizes.lg, color: ScoreColors.intermediate),
                Spacing.horizontalSm,
                Text(
                  tipTitle,
                  style: const TextStyle(
                    fontSize: FontSizes.titleSm,
                    fontWeight: FontWeight.bold,
                    color: ScoreColors.intermediate,
                  ),
                ),
              ],
            ),
            Spacing.verticalMd,
            ...tips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: Spacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, size: IconSizes.sm, color: ScoreColors.intermediate),
                    Spacing.horizontalSm,
                    Expanded(
                      child: Text(
                        tip,
                        style: TextStyle(
                          fontSize: FontSizes.bodyMd,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

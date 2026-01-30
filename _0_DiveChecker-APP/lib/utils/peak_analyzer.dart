// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

import 'dart:math';

import '../models/chart_point.dart';

class PeakDetail {
  final ChartPoint peak;
  final int index;
  final double riseTime;
  final double fallTime;
  final double riseSlope;
  final double fallSlope;
  final double peakWidth;
  final double amplitude;
  final String intensity;
  final double qualityScore;
  final double? intervalFromPrev;
  
  PeakDetail({
    required this.peak,
    required this.index,
    required this.riseTime,
    required this.fallTime,
    required this.riseSlope,
    required this.fallSlope,
    required this.peakWidth,
    required this.amplitude,
    required this.intensity,
    required this.qualityScore,
    this.intervalFromPrev,
  });
}

class PeakAnalysisResult {
  final List<ChartPoint> peaks;
  final List<PeakDetail> peakDetails;
  final double averagePeakPressure;
  final double maxPeakPressure;
  final double minPeakPressure;
  final double averagePeakInterval;
  final double peakConsistencyScore;
  final double frequencyPerMinute;
  final List<double> peakIntervals;
  final double fatigueIndex;
  
  final double rhythmScore;
  final double pressureScore;
  final double techniqueScore;
  final double overallGrade;
  final double avgRiseTime;
  final double avgFallTime;
  final double avgPeakWidth;
  final int weakPeakCount;
  final int moderatePeakCount;
  final int strongPeakCount;
  final double stabilityTrend;
  final List<int> outlierIndices;

  PeakAnalysisResult({
    required this.peaks,
    required this.peakDetails,
    required this.averagePeakPressure,
    required this.maxPeakPressure,
    required this.minPeakPressure,
    required this.averagePeakInterval,
    required this.peakConsistencyScore,
    required this.frequencyPerMinute,
    required this.peakIntervals,
    required this.fatigueIndex,
    required this.rhythmScore,
    required this.pressureScore,
    required this.techniqueScore,
    required this.overallGrade,
    required this.avgRiseTime,
    required this.avgFallTime,
    required this.avgPeakWidth,
    required this.weakPeakCount,
    required this.moderatePeakCount,
    required this.strongPeakCount,
    required this.stabilityTrend,
    required this.outlierIndices,
  });
}

class PeakAnalyzer {
  final double minPeakHeight;
  
  final int minPeakDistance;
  
  /// 피크 감지 민감도 (0.0 ~ 1.0, 높을수록 민감)
  final double sensitivity;

  PeakAnalyzer({
    this.minPeakHeight = 8.0,  // 15.0에서 8.0으로 낮춤 (더 민감)
    this.minPeakDistance = 5,   // 10에서 5로 낮춤 (빠른 연속 피크 감지)
    this.sensitivity = 0.7,     // 기본 민감도
  });

  PeakAnalysisResult analyze(List<ChartPoint> data) {
    if (data.isEmpty) {
      return _emptyResult();
    }

    final baseline = data.fold<double>(0.0, (sum, d) => sum + d.y) / data.length;

    final peakIndices = _detectPeakIndices(data);
    
    if (peakIndices.isEmpty) {
      return _emptyResult();
    }

    final peaks = peakIndices.map((i) => data[i]).toList();

    final peakDetails = _calculatePeakDetails(data, peakIndices, baseline);

    final pressures = peaks.map((p) => p.y).toList();
    final avgPressure = pressures.fold<double>(0.0, (sum, p) => sum + p) / pressures.length;
    final maxPressure = pressures.reduce(max);
    final minPressure = pressures.reduce(min);

    final intervals = <double>[];
    for (int i = 1; i < peaks.length; i++) {
      intervals.add((peaks[i].x - peaks[i - 1].x) / 1000.0);
    }
    final avgInterval = intervals.isEmpty ? 0.0 : intervals.fold<double>(0.0, (sum, i) => sum + i) / intervals.length;

    final totalDuration = (data.last.x - data.first.x) / 1000.0;
    final frequency = totalDuration > 0 ? (peaks.length / totalDuration) * 60 : 0.0;

    final rhythmScore = _calculateRhythmScore(intervals);
    final pressureScore = _calculatePressureScore(pressures);
    final techniqueScore = _calculateTechniqueScore(peakDetails);
    final consistencyScore = (rhythmScore + pressureScore) / 2;

    final fatigueIndex = _calculateFatigueIndex(peaks);

    int weak = 0, moderate = 0, strong = 0;
    for (final detail in peakDetails) {
      switch (detail.intensity) {
        case 'weak': weak++; break;
        case 'moderate': moderate++; break;
        case 'strong': strong++; break;
      }
    }

    final stabilityTrend = _calculateStabilityTrend(peakDetails);

    final outliers = _detectOutliers(pressures);

    final avgRiseTime = peakDetails.isEmpty ? 0.0 : 
        peakDetails.fold<double>(0.0, (sum, d) => sum + d.riseTime) / peakDetails.length;
    final avgFallTime = peakDetails.isEmpty ? 0.0 : 
        peakDetails.fold<double>(0.0, (sum, d) => sum + d.fallTime) / peakDetails.length;
    final avgPeakWidth = peakDetails.isEmpty ? 0.0 : 
        peakDetails.map((d) => d.peakWidth).reduce((a, b) => a + b) / peakDetails.length;

    final overallGrade = (rhythmScore * 0.25 + pressureScore * 0.25 + 
        techniqueScore * 0.25 + (100 - fatigueIndex) * 0.25);

    return PeakAnalysisResult(
      peaks: peaks,
      peakDetails: peakDetails,
      averagePeakPressure: avgPressure,
      maxPeakPressure: maxPressure,
      minPeakPressure: minPressure,
      averagePeakInterval: avgInterval,
      peakConsistencyScore: consistencyScore,
      frequencyPerMinute: frequency,
      peakIntervals: intervals,
      fatigueIndex: fatigueIndex,
      rhythmScore: rhythmScore,
      pressureScore: pressureScore,
      techniqueScore: techniqueScore,
      overallGrade: overallGrade,
      avgRiseTime: avgRiseTime,
      avgFallTime: avgFallTime,
      avgPeakWidth: avgPeakWidth,
      weakPeakCount: weak,
      moderatePeakCount: moderate,
      strongPeakCount: strong,
      stabilityTrend: stabilityTrend,
      outlierIndices: outliers,
    );
  }

  List<int> _detectPeakIndices(List<ChartPoint> data) {
    final peakIndices = <int>[];
    
    if (data.length < 3) return peakIndices;

    // 동적 임계값 계산 (민감도 적용)
    final pressures = data.map((d) => d.y).toList();
    final avgPressure = pressures.reduce((a, b) => a + b) / pressures.length;
    final maxPressure = pressures.reduce(max);
    final minPressure = pressures.reduce(min);
    
    // 민감도에 따른 동적 임계값 (range 고려)
    final range = maxPressure - minPressure;
    final dynamicThreshold = avgPressure + (minPeakHeight * (1.0 - sensitivity * 0.5)) * (range > 50 ? 1.0 : 0.8);
    
    // 노이즈 레벨 추정 (표준편차 기반)
    final variance = pressures.fold<double>(0.0, (sum, p) => sum + pow(p - avgPressure, 2)) / pressures.length;
    final noiseLevel = sqrt(variance) * 0.3;
    
    // 최종 임계값 (노이즈 레벨 고려)
    final threshold = max(dynamicThreshold, avgPressure + noiseLevel + 3.0);

    int lastPeakIndex = -minPeakDistance;

    // 1단계: 데이터 스무딩 (3-point moving average)
    final smoothed = _smoothData(data, windowSize: 3);
    
    // 2단계: 기울기 계산 (피크 검증에 사용)
    final gradients = _calculateGradients(smoothed);
    // ignore: unused_local_variable
    final _ = gradients; // 향후 고급 피크 검증에 사용 예정

    // 3단계: 첫 번째 피크 감지 (시작 부분)
    if (data[0].y > threshold && data[0].y > data[1].y) {
      bool isDescending = true;
      for (int j = 1; j < min(5, data.length); j++) {
        if (data[j].y > data[j - 1].y) {
          isDescending = false;
          break;
        }
      }
      if (isDescending) {
        peakIndices.add(0);
        lastPeakIndex = 0;
      }
    }
    
    // 4단계: 초기 구간에서 피크 찾기
    if (peakIndices.isEmpty && data.length > 3) {
      int earlyMaxIdx = 0;
      double earlyMax = data[0].y;
      final checkRange = min(15, data.length - 1);  // 10에서 15로 확장
      
      for (int i = 1; i < checkRange; i++) {
        if (data[i].y > earlyMax) {
          earlyMax = data[i].y;
          earlyMaxIdx = i;
        }
      }
      
      if (earlyMax > threshold && earlyMaxIdx > 0 && earlyMaxIdx < checkRange - 1) {
        bool risingBefore = data[earlyMaxIdx].y > data[0].y;
        bool fallingAfter = data[earlyMaxIdx].y > data[min(earlyMaxIdx + 3, data.length - 1)].y;
        
        if (risingBefore && fallingAfter) {
          peakIndices.add(earlyMaxIdx);
          lastPeakIndex = earlyMaxIdx;
        }
      }
    }

    // 5단계: 메인 피크 감지 (개선된 알고리즘)
    for (int i = 2; i < data.length - 2; i++) {
      if (peakIndices.contains(i)) continue;
      
      final curr = data[i].y;
      
      // 현재 값이 임계값 이상인지 확인
      if (curr <= threshold) continue;
      
      // 로컬 맥시멈 확인 (좌우 2개 포인트 비교)
      bool isLocalMax = curr >= data[i - 1].y && curr >= data[i + 1].y;
      
      // 평탄한 정상 감지 (같은 값이 연속될 때)
      if (!isLocalMax && curr == data[i - 1].y && curr > data[i + 1].y) {
        // 평탄 구간의 시작점 찾기
        int flatStart = i - 1;
        while (flatStart > 0 && data[flatStart].y == curr) {
          flatStart--;
        }
        if (data[flatStart].y < curr) {
          isLocalMax = true;
          // 평탄 구간의 중앙점 사용
          i = (flatStart + 1 + i) ~/ 2;
        }
      }
      
      // 더 넓은 윈도우에서 확인 (노이즈 제거)
      if (isLocalMax) {
        final windowSize = min(4, min(i, data.length - 1 - i));
        bool isRealPeak = true;
        
        for (int j = 1; j <= windowSize; j++) {
          if (data[i - j].y > curr * 1.02 || data[i + j].y > curr * 1.02) {
            isRealPeak = false;
            break;
          }
        }
        
        if (isRealPeak) {
          // 기울기 변화 확인 (상승 → 하강)
          final leftSlope = i >= 2 ? (data[i].y - data[i-2].y) : 0.0;
          final rightSlope = i < data.length - 2 ? (data[i+2].y - data[i].y) : 0.0;
          
          // 상승 후 하강하는 패턴인지 확인
          if (leftSlope >= 0 && rightSlope <= 0) {
            if (i - lastPeakIndex >= minPeakDistance) {
              peakIndices.add(i);
              lastPeakIndex = i;
            } else if (peakIndices.isNotEmpty && curr > data[peakIndices.last].y) {
              // 더 높은 피크로 교체
              peakIndices[peakIndices.length - 1] = i;
              lastPeakIndex = i;
            }
          }
        }
      }
    }
    
    // 6단계: 마지막 피크 감지 (끝 부분)
    if (data.length > 5) {
      final lastIdx = data.length - 1;
      final checkStart = max(lastPeakIndex + minPeakDistance, lastIdx - 10);
      
      int endMaxIdx = checkStart;
      double endMax = data[checkStart].y;
      
      for (int i = checkStart; i <= lastIdx; i++) {
        if (data[i].y > endMax) {
          endMax = data[i].y;
          endMaxIdx = i;
        }
      }
      
      if (endMax > threshold && endMaxIdx - lastPeakIndex >= minPeakDistance) {
        // 상승 후 끝나는 패턴 확인
        if (endMaxIdx > 0 && data[endMaxIdx].y > data[endMaxIdx - 1].y) {
          peakIndices.add(endMaxIdx);
        }
      }
    }

    return peakIndices;
  }
  
  /// 데이터 스무딩 (이동 평균)
  List<ChartPoint> _smoothData(List<ChartPoint> data, {int windowSize = 3}) {
    if (data.length < windowSize) return data;
    
    final smoothed = <ChartPoint>[];
    final halfWindow = windowSize ~/ 2;
    
    for (int i = 0; i < data.length; i++) {
      double sum = 0;
      int count = 0;
      
      for (int j = max(0, i - halfWindow); j <= min(data.length - 1, i + halfWindow); j++) {
        sum += data[j].y;
        count++;
      }
      
      smoothed.add(ChartPoint(data[i].x, sum / count));
    }
    
    return smoothed;
  }
  
  /// 기울기 계산
  List<double> _calculateGradients(List<ChartPoint> data) {
    if (data.length < 2) return [];
    
    final gradients = <double>[];
    
    for (int i = 0; i < data.length - 1; i++) {
      final dx = data[i + 1].x - data[i].x;
      final dy = data[i + 1].y - data[i].y;
      gradients.add(dx > 0 ? dy / dx * 1000 : 0.0);  // per second
    }
    
    gradients.add(0.0);  // 마지막 포인트
    return gradients;
  }

  List<PeakDetail> _calculatePeakDetails(List<ChartPoint> data, List<int> peakIndices, double baseline) {
    final details = <PeakDetail>[];
    
    for (int i = 0; i < peakIndices.length; i++) {
      final peakIdx = peakIndices[i];
      final peak = data[peakIdx];
      
      int riseStart = peakIdx;
      if (peakIdx > 0) {
        for (int j = peakIdx - 1; j >= 0; j--) {
          if (data[j].y <= baseline || j == 0) {
            riseStart = j;
            break;
          }
          if (data[j].y > data[j + 1].y) {
            riseStart = j + 1;
            break;
          }
        }
      }
      
      int fallEnd = peakIdx;
      for (int j = peakIdx + 1; j < data.length; j++) {
        if (data[j].y <= baseline || j == data.length - 1) {
          fallEnd = j;
          break;
        }
        if (data[j].y > data[j - 1].y) {
          fallEnd = j - 1;
          break;
        }
      }
      
      final riseTime = peakIdx == riseStart ? 0.0 : (peak.x - data[riseStart].x) / 1000.0;
      final fallTime = (data[fallEnd].x - peak.x) / 1000.0;
      final peakWidth = riseTime + fallTime;
      
      final riseSlope = riseTime > 0 ? (peak.y - data[riseStart].y) / riseTime : 0.0;
      final fallSlope = fallTime > 0 ? (peak.y - data[fallEnd].y) / fallTime : 0.0;
      
      final amplitude = peak.y - baseline;
      
      // 개선된 intensity 분류 (더 낮은 기준)
      String intensity;
      if (amplitude < 15) {        // 25에서 15로 낮춤
        intensity = 'weak';
      } else if (amplitude < 35) { // 50에서 35로 낮춤
        intensity = 'moderate';
      } else {
        intensity = 'strong';
      }
      
      final balanceRatio = riseTime > 0 && fallTime > 0 
          ? min(riseTime, fallTime) / max(riseTime, fallTime) 
          : 0.5;
      final idealWidth = 0.25;  // 0.3에서 0.25로 조정 (빠른 피크에 맞춤)
      final widthScore = 100 - min(100.0, (peakWidth - idealWidth).abs() * 150);  // 200에서 150으로 완화
      final qualityScore = (balanceRatio * 50 + widthScore * 0.5).clamp(0.0, 100.0);
      
      double? intervalFromPrev;
      if (i > 0) {
        intervalFromPrev = (peak.x - data[peakIndices[i - 1]].x) / 1000.0;
      }
      
      details.add(PeakDetail(
        peak: peak,
        index: i,
        riseTime: riseTime,
        fallTime: fallTime,
        riseSlope: riseSlope,
        fallSlope: fallSlope,
        peakWidth: peakWidth,
        amplitude: amplitude,
        intensity: intensity,
        qualityScore: qualityScore,
        intervalFromPrev: intervalFromPrev,
      ));
    }
    
    return details;
  }

  double _calculateRhythmScore(List<double> intervals) {
    if (intervals.length < 2) return 100.0;
    
    final avg = intervals.fold<double>(0.0, (sum, i) => sum + i) / intervals.length;
    final variance = intervals.fold<double>(0.0, (sum, i) => sum + pow(i - avg, 2)) / intervals.length;
    final stdDev = sqrt(variance);
    final cv = avg > 0 ? stdDev / avg : 0.0;
    
    return (100.0 - cv * 150).clamp(0.0, 100.0);
  }

  double _calculatePressureScore(List<double> pressures) {
    if (pressures.length < 2) return 100.0;
    
    final avg = pressures.fold<double>(0.0, (sum, p) => sum + p) / pressures.length;
    final variance = pressures.fold<double>(0.0, (sum, p) => sum + pow(p - avg, 2)) / pressures.length;
    final stdDev = sqrt(variance);
    final cv = avg > 0 ? stdDev / avg : 0.0;
    
    return (100.0 - cv * 200).clamp(0.0, 100.0);
  }

  double _calculateTechniqueScore(List<PeakDetail> details) {
    if (details.isEmpty) return 0.0;
    return details.fold<double>(0.0, (sum, d) => sum + d.qualityScore) / details.length;
  }

  double _calculateStabilityTrend(List<PeakDetail> details) {
    if (details.length < 4) return 0.0;
    
    final halfIdx = details.length ~/ 2;
    final firstHalfQuality = details.sublist(0, halfIdx)
        .fold<double>(0.0, (sum, d) => sum + d.qualityScore) / halfIdx;
    final secondHalfQuality = details.sublist(halfIdx)
        .fold<double>(0.0, (sum, d) => sum + d.qualityScore) / (details.length - halfIdx);
    
    return (secondHalfQuality - firstHalfQuality).clamp(-100.0, 100.0);
  }

  List<int> _detectOutliers(List<double> pressures) {
    if (pressures.length < 4) return [];
    
    final sorted = List<double>.from(pressures)..sort();
    final q1 = sorted[(sorted.length * 0.25).floor()];
    final q3 = sorted[(sorted.length * 0.75).floor()];
    final iqr = q3 - q1;
    final lowerBound = q1 - 1.5 * iqr;
    final upperBound = q3 + 1.5 * iqr;
    
    final outliers = <int>[];
    for (int i = 0; i < pressures.length; i++) {
      if (pressures[i] < lowerBound || pressures[i] > upperBound) {
        outliers.add(i);
      }
    }
    
    return outliers;
  }

  double _calculateFatigueIndex(List<ChartPoint> peaks) {
    if (peaks.length < 4) return 0.0;

    final halfIndex = peaks.length ~/ 2;
    final firstHalf = peaks.sublist(0, halfIndex);
    final secondHalf = peaks.sublist(halfIndex);

    final firstAvg = firstHalf.fold<double>(0.0, (sum, p) => sum + p.y) / firstHalf.length;
    final secondAvg = secondHalf.fold<double>(0.0, (sum, p) => sum + p.y) / secondHalf.length;

    if (firstAvg <= 0) return 0.0;
    
    final decline = (firstAvg - secondAvg) / firstAvg * 100;
    return max(0.0, min(100.0, decline * 2));
  }

  PeakAnalysisResult _emptyResult() {
    return PeakAnalysisResult(
      peaks: [],
      peakDetails: [],
      averagePeakPressure: 0,
      maxPeakPressure: 0,
      minPeakPressure: 0,
      averagePeakInterval: 0,
      peakConsistencyScore: 0,
      frequencyPerMinute: 0,
      peakIntervals: [],
      fatigueIndex: 0,
      rhythmScore: 0,
      pressureScore: 0,
      techniqueScore: 0,
      overallGrade: 0,
      avgRiseTime: 0,
      avgFallTime: 0,
      avgPeakWidth: 0,
      weakPeakCount: 0,
      moderatePeakCount: 0,
      strongPeakCount: 0,
      stabilityTrend: 0,
      outlierIndices: [],
    );
  }
}

class SegmentAnalysis {
  final double startTime;
  final double endTime;
  final int peakCount;
  final double avgPressure;
  final double maxPressure;

  SegmentAnalysis({
    required this.startTime,
    required this.endTime,
    required this.peakCount,
    required this.avgPressure,
    required this.maxPressure,
  });
}

List<SegmentAnalysis> analyzeSegments(
  List<ChartPoint> data, 
  PeakAnalysisResult peakResult, 
  {int segmentCount = 4}
) {
  if (data.isEmpty) return [];

  final segments = <SegmentAnalysis>[];
  final totalRange = data.last.x - data.first.x;
  final segmentSize = totalRange / segmentCount;

  for (int i = 0; i < segmentCount; i++) {
    final startX = data.first.x + (segmentSize * i);
    final endX = startX + segmentSize;

    final segmentData = data.where((d) => d.x >= startX && d.x < endX).toList();
    final segmentPeaks = peakResult.peaks.where((p) => p.x >= startX && p.x < endX).toList();

    if (segmentData.isEmpty) continue;

    final pressures = segmentData.map((d) => d.y).toList();
    
    segments.add(SegmentAnalysis(
      startTime: startX / 1000.0,
      endTime: endX / 1000.0,
      peakCount: segmentPeaks.length,
      avgPressure: pressures.reduce((a, b) => a + b) / pressures.length,
      maxPressure: pressures.reduce(max),
    ));
  }

  return segments;
}

/// 선택된 피크들로 통계를 재계산합니다.
/// 
/// [selectedPeaks]: 사용자가 선택한 피크 위치 리스트
/// [selectedDetails]: 선택된 피크들의 상세 정보
/// [chartData]: 전체 차트 데이터 (totalDuration 계산용)
/// [originalFatigueIndex]: 원본 피로도 인덱스
/// [originalStabilityTrend]: 원본 안정성 트렌드
PeakAnalysisResult recalculateWithSelectedPeaks({
  required List<ChartPoint> selectedPeaks,
  required List<PeakDetail> selectedDetails,
  required List<ChartPoint> chartData,
  required double originalFatigueIndex,
  required double originalStabilityTrend,
}) {
  // 선택된 피크가 없으면 빈 결과 반환
  if (selectedPeaks.isEmpty) {
    return PeakAnalysisResult(
      peaks: [],
      peakDetails: [],
      averagePeakPressure: 0,
      maxPeakPressure: 0,
      minPeakPressure: 0,
      averagePeakInterval: 0,
      peakConsistencyScore: 0,
      frequencyPerMinute: 0,
      peakIntervals: [],
      fatigueIndex: 0,
      rhythmScore: 0,
      pressureScore: 0,
      techniqueScore: 0,
      overallGrade: 0,
      avgRiseTime: 0,
      avgFallTime: 0,
      avgPeakWidth: 0,
      weakPeakCount: 0,
      moderatePeakCount: 0,
      strongPeakCount: 0,
      stabilityTrend: 0,
      outlierIndices: [],
    );
  }

  // 선택된 피크로 통계 재계산
  final pressures = selectedPeaks.map((p) => p.y).toList();
  final avgPressure = pressures.reduce((a, b) => a + b) / pressures.length;
  final maxPressure = pressures.reduce(max);
  final minPressure = pressures.reduce(min);

  final intervals = <double>[];
  for (int i = 1; i < selectedPeaks.length; i++) {
    intervals.add((selectedPeaks[i].x - selectedPeaks[i - 1].x) / 1000.0);
  }
  final avgInterval = intervals.isEmpty
      ? 0.0
      : intervals.reduce((a, b) => a + b) / intervals.length;

  final totalDuration = chartData.isNotEmpty
      ? (chartData.last.x - chartData.first.x) / 1000.0
      : 0.0;
  final frequency = totalDuration > 0
      ? (selectedPeaks.length / totalDuration) * 60
      : 0.0;

  // 점수 재계산
  double rhythmScore = 100.0;
  if (intervals.length > 1) {
    final avg = intervals.reduce((a, b) => a + b) / intervals.length;
    final variance =
        intervals.map((i) => pow(i - avg, 2)).reduce((a, b) => a + b) /
        intervals.length;
    final stdDev = sqrt(variance);
    final cv = avg > 0 ? stdDev / avg : 0.0;
    rhythmScore = (100.0 - cv * 150).clamp(0.0, 100.0);
  }

  double pressureScore = 100.0;
  if (pressures.length > 1) {
    final avg = avgPressure;
    final variance =
        pressures.map((p) => pow(p - avg, 2)).reduce((a, b) => a + b) /
        pressures.length;
    final stdDev = sqrt(variance);
    final cv = avg > 0 ? stdDev / avg : 0.0;
    pressureScore = (100.0 - cv * 200).clamp(0.0, 100.0);
  }

  final consistencyScore = (rhythmScore + pressureScore) / 2;
  final techniqueScore = selectedDetails.isEmpty
      ? 0.0
      : selectedDetails.map((d) => d.qualityScore).reduce((a, b) => a + b) /
            selectedDetails.length;

  // 강도별 분류
  int weak = 0, moderate = 0, strong = 0;
  for (final detail in selectedDetails) {
    switch (detail.intensity) {
      case 'weak':
        weak++;
        break;
      case 'moderate':
        moderate++;
        break;
      case 'strong':
        strong++;
        break;
    }
  }

  final overallGrade =
      (rhythmScore * 0.25 +
      pressureScore * 0.25 +
      techniqueScore * 0.25 +
      (100 - originalFatigueIndex) * 0.25);

  return PeakAnalysisResult(
    peaks: selectedPeaks,
    peakDetails: selectedDetails,
    averagePeakPressure: avgPressure,
    maxPeakPressure: maxPressure,
    minPeakPressure: minPressure,
    averagePeakInterval: avgInterval,
    peakConsistencyScore: consistencyScore,
    frequencyPerMinute: frequency,
    peakIntervals: intervals,
    fatigueIndex: originalFatigueIndex,
    rhythmScore: rhythmScore,
    pressureScore: pressureScore,
    techniqueScore: techniqueScore,
    overallGrade: overallGrade,
    avgRiseTime: selectedDetails.isEmpty
        ? 0
        : selectedDetails.map((d) => d.riseTime).reduce((a, b) => a + b) /
              selectedDetails.length,
    avgFallTime: selectedDetails.isEmpty
        ? 0
        : selectedDetails.map((d) => d.fallTime).reduce((a, b) => a + b) /
              selectedDetails.length,
    avgPeakWidth: selectedDetails.isEmpty
        ? 0
        : selectedDetails.map((d) => d.peakWidth).reduce((a, b) => a + b) /
              selectedDetails.length,
    weakPeakCount: weak,
    moderatePeakCount: moderate,
    strongPeakCount: strong,
    stabilityTrend: originalStabilityTrend,
    outlierIndices: [],
  );
}

// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// Shared chart utility functions for consistent time formatting and interval calculation.
library;

/// Calculate X axis interval aligned to sample rate.
/// Returns interval in milliseconds that is a multiple of sample interval.
double calculateXAxisInterval({
  required double rangeMs,
  required int sampleRate,
  bool dense = false,
}) {
  final rangeInSeconds = rangeMs / 1000.0;
  final sampleIntervalMs = 1000.0 / sampleRate;

  // Target interval in seconds based on range and density
  double targetSeconds;
  if (dense) {
    // Dense mode for zoomed views
    if (rangeInSeconds <= 1) {
      targetSeconds = 0.125;
    } else if (rangeInSeconds <= 2) {
      targetSeconds = 0.25;
    } else if (rangeInSeconds <= 5) {
      targetSeconds = 0.5;
    } else if (rangeInSeconds <= 10) {
      targetSeconds = 1;
    } else if (rangeInSeconds <= 20) {
      targetSeconds = 2;
    } else if (rangeInSeconds <= 40) {
      targetSeconds = 5;
    } else if (rangeInSeconds <= 90) {
      targetSeconds = 10;
    } else if (rangeInSeconds <= 180) {
      targetSeconds = 15;
    } else {
      targetSeconds = 20;
    }
  } else {
    // Normal mode
    if (rangeInSeconds <= 5) {
      targetSeconds = 0.5;
    } else if (rangeInSeconds <= 10) {
      targetSeconds = 1;
    } else if (rangeInSeconds <= 20) {
      targetSeconds = 2;
    } else if (rangeInSeconds <= 40) {
      targetSeconds = 5;
    } else if (rangeInSeconds <= 90) {
      targetSeconds = 10;
    } else if (rangeInSeconds <= 180) {
      targetSeconds = 15;
    } else {
      targetSeconds = 20;
    }
  }

  // Snap to nearest sample interval multiple
  final targetMs = targetSeconds * 1000.0;
  final samples = (targetMs / sampleIntervalMs).round().clamp(1, 1000000);
  return samples * sampleIntervalMs;
}

/// Format time label: seconds for < 60s, m:ss for >= 60s.
/// Uses floor for consistent display.
String formatTimeLabel(double seconds) {
  final totalSeconds = seconds.floor();
  if (totalSeconds < 60) {
    return '${totalSeconds}s';
  } else {
    final minutes = totalSeconds ~/ 60;
    final secs = totalSeconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }
}

/// Convert milliseconds to seconds.
double msToSeconds(double ms) => ms / 1000.0;

/// Calculate vertical grid interval aligned to sample rate.
/// Grid lines are placed at multiples of sample interval.
/// Used for denser grids compared to labels.
double calculateVerticalGridInterval({
  required double rangeMs,
  required int sampleRate,
}) {
  final rangeInSeconds = rangeMs / 1000.0;
  final sampleIntervalMs = 1000.0 / sampleRate;

  // Choose target interval in seconds based on zoom level
  double targetSeconds;
  if (rangeInSeconds <= 2) {
    targetSeconds = 0.125; // 8 grids per second
  } else if (rangeInSeconds <= 5) {
    targetSeconds = 0.25; // 4 grids per second
  } else if (rangeInSeconds <= 10) {
    targetSeconds = 0.5; // 2 grids per second
  } else if (rangeInSeconds <= 20) {
    targetSeconds = 1.0; // 1 grid per second
  } else if (rangeInSeconds <= 60) {
    targetSeconds = 2.0; // 1 grid per 2 seconds
  } else if (rangeInSeconds <= 120) {
    targetSeconds = 5.0; // 1 grid per 5 seconds
  } else if (rangeInSeconds <= 300) {
    targetSeconds = 10.0; // 1 grid per 10 seconds
  } else {
    targetSeconds = 30.0; // 1 grid per 30 seconds
  }

  // Snap to nearest sample interval multiple
  final targetMs = targetSeconds * 1000.0;
  final samples = (targetMs / sampleIntervalMs).round().clamp(1, 1000000);
  return samples * sampleIntervalMs;
}

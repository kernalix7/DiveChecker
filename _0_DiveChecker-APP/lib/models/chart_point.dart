// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// A simple immutable data point for charts.
/// Replaces fl_chart's FlSpot for use with graphic library.
class ChartPoint {
  final double x;
  final double y;

  const ChartPoint(this.x, this.y);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChartPoint && other.x == x && other.y == y;
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'ChartPoint($x, $y)';

  /// Create a copy with modified values
  ChartPoint copyWith({double? x, double? y}) {
    return ChartPoint(x ?? this.x, y ?? this.y);
  }

  /// Convert to Map for serialization
  Map<String, dynamic> toMap() => {'x': x, 'y': y};

  /// Create from Map
  factory ChartPoint.fromMap(Map<String, dynamic> map) {
    return ChartPoint(
      (map['x'] as num).toDouble(),
      (map['y'] as num).toDouble(),
    );
  }
}

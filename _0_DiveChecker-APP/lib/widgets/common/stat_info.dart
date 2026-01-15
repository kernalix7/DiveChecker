// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

/// 통계 정보를 표시하는 위젯
/// 
/// 레이블, 값, 단위를 세로로 배치하여 표시합니다.
class StatInfo extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const StatInfo({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: FontSizes.xs,
            fontWeight: FontWeight.bold,
            color: color.withOpacity(Opacities.almostFull),
            letterSpacing: LetterSpacings.wider,
          ),
        ),
        Spacing.verticalXs,
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: FontSizes.headline,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'monospace',
                letterSpacing: -0.5,
              ),
            ),
            Spacing.horizontalXs,
            Text(
              unit,
              style: TextStyle(
                fontSize: FontSizes.sm,
                fontWeight: FontWeight.w600,
                color: color.withOpacity(Opacities.veryHigh),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 아이콘과 함께 정보를 표시하는 행 위젯
/// 
/// 아이콘, 레이블, 값을 가로로 배치하여 표시합니다.
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(Spacing.sm),
          decoration: BoxDecoration(
            color: color.withOpacity(Opacities.low),
            borderRadius: BorderRadii.smAll,
          ),
          child: Icon(
            icon,
            size: IconSizes.md,
            color: color,
          ),
        ),
        Spacing.horizontalSm,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: FontSizes.body,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: FontSizes.lg,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

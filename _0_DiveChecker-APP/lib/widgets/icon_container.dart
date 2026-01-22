// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class IconContainer extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double size;
  final double padding;
  final bool useGradient;
  
  const IconContainer({
    super.key,
    required this.icon,
    this.color,
    this.size = IconSizes.lg,
    this.padding = Spacing.sm,
    this.useGradient = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = color ?? theme.colorScheme.primary;
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: useGradient ? null : iconColor.withOpacity(Opacities.veryLow),
        gradient: useGradient
            ? LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(useGradient ? BorderRadii.md : BorderRadii.sm),
      ),
      child: Icon(
        icon,
        color: useGradient ? OverlayColors.whiteContent : iconColor,
        size: size,
      ),
    );
  }
}

// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

/// Common padding values for StyledContainer
class _Paddings {
  static const allMd = EdgeInsets.all(Spacing.md);
  static const allLg = EdgeInsets.all(Spacing.lg);
  static const chipPadding = EdgeInsets.symmetric(
    horizontal: Spacing.sm,
    vertical: Spacing.xs,
  );
}

/// A reusable styled container with consistent decoration patterns.
/// 
/// Provides several factory constructors for common use cases:
/// - [StyledContainer.card] - Standard card with shadow
/// - [StyledContainer.section] - Section container with border
/// - [StyledContainer.stat] - Stats/metric display container
/// - [StyledContainer.chip] - Small chip-style container
class StyledContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? borderColor;
  final double? borderWidth;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final Clip clipBehavior;
  final AlignmentGeometry? alignment;

  const StyledContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.borderRadius = BorderRadii.md,
    this.boxShadow,
    this.gradient,
    this.width,
    this.height,
    this.constraints,
    this.clipBehavior = Clip.none,
    this.alignment,
  });

  /// Card-style container with elevation shadow.
  /// Good for: Cards, list items, dialog content
  factory StyledContainer.card({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    double borderRadius = BorderRadii.md,
    double? width,
    double? height,
    bool elevated = true,
  }) {
    return StyledContainer(
      key: key,
      padding: padding ?? _Paddings.allMd,
      margin: margin,
      color: color,
      borderRadius: borderRadius,
      boxShadow: elevated
          ? [
              BoxShadow(
                color: OverlayColors.darkOverlay.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
      width: width,
      height: height,
      child: child,
    );
  }

  /// Section container with subtle border.
  /// Good for: Form sections, grouped content
  factory StyledContainer.section({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Color? borderColor,
    double borderRadius = BorderRadii.md,
    double? width,
    double? height,
  }) {
    return StyledContainer(
      key: key,
      padding: padding ?? _Paddings.allMd,
      margin: margin,
      color: color,
      borderColor: borderColor,
      borderWidth: 1.0,
      borderRadius: borderRadius,
      width: width,
      height: height,
      child: child,
    );
  }

  /// Stat/metric display container.
  /// Good for: Statistics, scores, metrics display
  factory StyledContainer.stat({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    double borderRadius = BorderRadii.lg,
    double? width,
    double? height,
  }) {
    return StyledContainer(
      key: key,
      padding: padding ?? _Paddings.allLg,
      margin: margin,
      color: color,
      gradient: gradient,
      borderRadius: borderRadius,
      boxShadow: [
        BoxShadow(
          color: OverlayColors.darkOverlay.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      width: width,
      height: height,
      child: child,
    );
  }

  /// Small chip-style container.
  /// Good for: Tags, badges, small labels
  factory StyledContainer.chip({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    double borderRadius = BorderRadii.sm,
    double? width,
    double? height,
  }) {
    return StyledContainer(
      key: key,
      padding: padding ?? _Paddings.chipPadding,
      margin: margin,
      color: color,
      borderRadius: borderRadius,
      width: width,
      height: height,
      child: child,
    );
  }

  /// Gradient-filled container.
  /// Good for: Highlighted sections, hero content
  factory StyledContainer.gradient({
    Key? key,
    required Widget child,
    required Gradient gradient,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double borderRadius = BorderRadii.md,
    double? width,
    double? height,
    List<BoxShadow>? boxShadow,
  }) {
    return StyledContainer(
      key: key,
      padding: padding ?? _Paddings.allMd,
      margin: margin,
      gradient: gradient,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      width: width,
      height: height,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: width,
      height: height,
      constraints: constraints,
      alignment: alignment,
      padding: padding,
      margin: margin,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: gradient == null 
            ? (color ?? theme.colorScheme.surface) 
            : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null || borderWidth != null
            ? Border.all(
                color: borderColor ?? theme.colorScheme.outline.withValues(alpha: 0.2),
                width: borderWidth ?? 1.0,
              )
            : null,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}

/// A themed divider with consistent styling for list items.
/// 
/// Use this instead of manual Divider configuration for cards and lists.
class AppDivider extends StatelessWidget {
  /// Standard indent for list tile dividers
  final double indent;
  
  /// Height/thickness of the divider
  final double height;
  
  const AppDivider({
    super.key,
    this.indent = WidgetSizes.dividerIndent,
    this.height = Dimensions.dividerHeight,
  });
  
  /// Divider with no indent - full width
  const AppDivider.fullWidth({
    super.key,
  }) : indent = 0, height = Dimensions.dividerHeight;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      indent: indent,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

/// Section spacing widget - use between major sections
class SectionSpacing extends StatelessWidget {
  const SectionSpacing({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: UIConstants.sectionSpacing);
  }
}

// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// Common UI helper functions and widgets for consistent UX patterns.
library;

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Show a simple SnackBar with text message
void showAppSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

/// Show a success SnackBar (green background)
void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: ScoreColors.excellent,
    ),
  );
}

/// Show an error SnackBar (red background)
void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: ScoreColors.poor,
    ),
  );
}

/// Small loading indicator for list tiles
class CompactLoadingIndicator extends StatelessWidget {
  final double size;
  
  const CompactLoadingIndicator({
    super.key,
    this.size = WidgetSizes.containerMediumLarge,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(
        strokeWidth: ChartDimensions.strokeMedium,
      ),
    );
  }
}

/// Full screen loading overlay
class LoadingOverlay extends StatelessWidget {
  final String? message;
  
  const LoadingOverlay({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: OverlayColors.darkOverlay.withOpacity(Opacities.high),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              Spacing.verticalLg,
              Text(
                message!,
                style: const TextStyle(color: OverlayColors.whiteContent),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Extension on BuildContext for easier access to common patterns
extension BuildContextExtensions on BuildContext {
  /// Get theme data
  ThemeData get theme => Theme.of(this);
  
  /// Get color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  /// Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  /// Check if dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  
  /// Show simple snackbar
  void showSnackBar(String message) => showAppSnackBar(this, message);
  
  /// Show success snackbar
  void showSuccess(String message) => showSuccessSnackBar(this, message);
  
  /// Show error snackbar
  void showError(String message) => showErrorSnackBar(this, message);
}

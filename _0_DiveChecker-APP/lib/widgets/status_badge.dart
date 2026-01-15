// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';

class StatusBadge extends StatelessWidget {
  final bool isConnected;
  final bool isScanning;
  final bool showLabel;
  final bool isAuthenticated;
  
  const StatusBadge({
    super.key,
    required this.isConnected,
    this.isScanning = false,
    this.showLabel = true,
    this.isAuthenticated = true,
  });
  
  @override
  Widget build(BuildContext context) {
    // Show warning color if connected but not authenticated
    final isWarning = isConnected && !isAuthenticated;
    final badgeColor = isWarning 
        ? ScoreColors.warning 
        : (isConnected ? StatusColors.connected : StatusColors.disabled);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(Opacities.low),
        borderRadius: BorderRadius.circular(UIConstants.statusBadgeRadius),
        border: Border.all(
          color: badgeColor.withOpacity(Opacities.mediumHigh),
          width: UIConstants.thinBorderWidth,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isWarning
                ? Icons.gpp_bad_outlined
                : isScanning
                    ? Icons.usb
                    : isConnected
                        ? Icons.usb
                        : Icons.usb_off,
            color: badgeColor,
            size: UIConstants.smallIconSize,
          ),
          if (showLabel || isConnected || isScanning) ...[
            Spacing.horizontalXs,
            Container(
              width: Spacing.sm,
              height: Spacing.sm,
              decoration: BoxDecoration(
                color: isScanning
                    ? ScoreColors.warning
                    : badgeColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class RecordingBadge extends StatelessWidget {
  const RecordingBadge({super.key});
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Row(
      children: [
        Container(
          width: Spacing.sm,
          height: Spacing.sm,
          decoration: BoxDecoration(
            color: ScoreColors.poor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: ScoreColors.poor.withOpacity(Opacities.high),
                blurRadius: Shadows.blurMedium,
                spreadRadius: Shadows.spreadSmall,
              ),
            ],
          ),
        ),
        Spacing.horizontalSm,
        Text(
          l10n.recording,
          style: const TextStyle(
            fontSize: FontSizes.bodySm,
            fontWeight: FontWeight.bold,
            letterSpacing: LetterSpacings.wide,
          ),
        ),
      ],
    );
  }
}

class StatusIndicator extends StatelessWidget {
  final bool isActive;
  final String label;
  final Color? activeColor;
  
  const StatusIndicator({
    super.key,
    required this.isActive,
    required this.label,
    this.activeColor,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = activeColor ?? theme.colorScheme.secondary;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
      decoration: BoxDecoration(
        color: isActive
            ? color.withOpacity(Opacities.low)
            : theme.colorScheme.outline.withOpacity(Opacities.veryLow),
        borderRadius: BorderRadii.smAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Spacing.sm,
            height: Spacing.sm,
            decoration: BoxDecoration(
              color: isActive ? color : theme.colorScheme.outline,
              shape: BoxShape.circle,
            ),
          ),
          Spacing.horizontalSm,
          Text(
            label,
            style: TextStyle(
              fontSize: FontSizes.tiny,
              fontWeight: FontWeight.bold,
              letterSpacing: LetterSpacings.wider,
              color: isActive
                  ? color
                  : theme.colorScheme.onSurface.withOpacity(Opacities.medium),
            ),
          ),
        ],
      ),
    );
  }
}

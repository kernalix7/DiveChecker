// Copyright (C) 2025-2026 Createch (legal@createch.kr)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';
import '../../utils/formatters.dart';
import '../status_badge.dart';

class HomeHeader extends StatelessWidget {
  final bool isConnected;
  final bool isScanning;
  final bool isAuthenticated;
  final bool isAuthenticationComplete;
  
  const HomeHeader({
    super.key,
    required this.isConnected,
    this.isScanning = false,
    this.isAuthenticated = true,
    this.isAuthenticationComplete = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Only show warning state after authentication attempt is complete
    final showAuthWarning = isConnected && isAuthenticationComplete && !isAuthenticated;
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(BorderRadii.md),
          ),
          child: Image.asset(
            'assets/logo.png',
            height: IconSizes.xl,
            color: OverlayColors.whiteContent,
          ),
        ),
        Spacing.horizontalLg,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.appTitle,
                style: const TextStyle(
                  fontSize: FontSizes.headline,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                l10n.appDescription,
                style: TextStyle(
                  fontSize: FontSizes.body,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  letterSpacing: LetterSpacings.normal,
                ),
              ),
            ],
          ),
        ),
        StatusBadge(
          isConnected: isConnected,
          isScanning: isScanning,
          isAuthenticated: !showAuthWarning,  // Only show warning after auth complete
        ),
      ],
    );
  }
}

class ConnectionStatusPanel extends StatelessWidget {
  final bool isConnected;
  final bool isScanning;
  final bool isCompact;
  
  const ConnectionStatusPanel({
    super.key,
    required this.isConnected,
    this.isScanning = false,
    this.isCompact = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final padding = isCompact ? Spacing.lg : Spacing.xxl;
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadii.xxlAll,
        border: Border.all(
          color: isConnected 
              ? theme.colorScheme.primary.withValues(alpha: Opacities.moderate)
              : theme.colorScheme.outline.withValues(alpha: Opacities.mediumHigh),
          width: ChartDimensions.lineWidthSmall,
        ),
        boxShadow: [
          BoxShadow(
            color: (isConnected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline)
                .withValues(alpha: Opacities.mediumLow),
            blurRadius: Shadows.blurXl,
            offset: const Offset(0, Spacing.sm),
          ),
        ],
      ),
      child: Column(
        children: [
          _StatusIndicatorWithL10n(
            isConnected: isConnected,
            isScanning: isScanning,
          ),
          SizedBox(height: isCompact ? Spacing.md : Spacing.xl),
          
          _ConnectionIcon(
            isConnected: isConnected,
            isScanning: isScanning,
            isCompact: isCompact,
          ),
          SizedBox(height: isCompact ? Spacing.md : Spacing.xl),
          
          _ConnectionStatusText(
            isConnected: isConnected,
            isScanning: isScanning,
            l10n: l10n,
          ),
        ],
      ),
    );
  }
}

class _ConnectionIcon extends StatelessWidget {
  final bool isConnected;
  final bool isScanning;
  final bool isCompact;
  
  const _ConnectionIcon({
    required this.isConnected,
    required this.isScanning,
    this.isCompact = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconPadding = isCompact ? Spacing.lg : Spacing.xxl;
    final iconSize = isCompact ? IconSizes.display : IconSizes.display + IconSizes.sm;
    
    return Container(
      padding: EdgeInsets.all(iconPadding),
      decoration: BoxDecoration(
        color: isConnected
            ? theme.colorScheme.primary.withValues(alpha: Opacities.veryLow)
            : theme.colorScheme.outline.withValues(alpha: Opacities.veryLow),
        shape: BoxShape.circle,
        border: Border.all(
          color: isConnected
              ? theme.colorScheme.primary.withValues(alpha: Opacities.mediumHigh)
              : theme.colorScheme.outline.withValues(alpha: Opacities.low),
          width: ChartDimensions.lineWidthSmall,
        ),
      ),
      child: Icon(
        isScanning
            ? Icons.usb
            : isConnected
                ? Icons.usb
                : Icons.usb_off,
        size: iconSize,
        color: isConnected 
            ? theme.colorScheme.primary 
            : theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _ConnectionStatusText extends StatelessWidget {
  final bool isConnected;
  final bool isScanning;
  final AppLocalizations l10n;
  
  const _ConnectionStatusText({
    required this.isConnected,
    required this.isScanning,
    required this.l10n,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Text(
          isScanning
              ? l10n.deviceDiscovery
              : isConnected
                  ? l10n.deviceConnected
                  : l10n.deviceNotConnected,
          style: TextStyle(
            fontSize: FontSizes.bodyLg,
            fontWeight: FontWeight.bold,
            letterSpacing: LetterSpacings.widest,
            color: theme.colorScheme.onSurface.withValues(alpha: Opacities.almostFull),
          ),
        ),
        Spacing.verticalSm,
        Text(
          isScanning
              ? l10n.searchingDevice
              : isConnected
                  ? l10n.measurementReady
                  : l10n.tapToConnect,
          style: TextStyle(
            fontSize: FontSizes.bodyLg,
            color: isConnected
                ? OverlayColors.whiteContent.withValues(alpha: Opacities.nearFull)
                : StatusColors.tertiaryText,
          ),
        ),
      ],
    );
  }
}

class CurrentPressurePanel extends StatelessWidget {
  final double pressure;
  final bool isCompact;
  
  const CurrentPressurePanel({
    super.key,
    required this.pressure,
    this.isCompact = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsProvider>();
    final displayPressure = settings.convertPressure(pressure);
    
    final padding = isCompact ? Spacing.lg : Spacing.xxl;
    final pressureFontSize = isCompact 
        ? FontSizes.display 
        : FontSizes.display + FontSizes.titleLg;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadii.xlAll,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: Opacities.low),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.speed,
                color: theme.colorScheme.primary,
                size: IconSizes.md,
              ),
              Spacing.horizontalSm,
              Text(
                l10n.currentPressureLabel.toUpperCase(),
                style: TextStyle(
                  fontSize: FontSizes.body,
                  fontWeight: FontWeight.bold,
                  letterSpacing: LetterSpacings.widest,
                  color: StatusColors.secondaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: isCompact ? Spacing.md : Spacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatPressure(displayPressure),
                style: TextStyle(
                  fontSize: pressureFontSize,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  height: 1,
                ),
              ),
              Spacing.horizontalSm,
              Padding(
                padding: const EdgeInsets.only(bottom: Spacing.sm),
                child: Text(
                  settings.pressureUnitSymbol,
                  style: TextStyle(
                    fontSize: FontSizes.titleSm,
                    color: StatusColors.secondaryText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LiveMonitoringIndicator extends StatelessWidget {
  const LiveMonitoringIndicator({
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: Spacing.sm,
          height: Spacing.sm,
          decoration: BoxDecoration(
            color: ScoreColors.excellent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: ScoreColors.excellent.withValues(alpha: Opacities.high),
                blurRadius: Shadows.blurMedium,
                spreadRadius: Shadows.spreadSmall,
              ),
            ],
          ),
        ),
        Spacing.horizontalSm,
        Text(
          l10n.liveMonitoring,
          style: TextStyle(
            fontSize: FontSizes.bodyLg,
            color: StatusColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

class RecalibrateAtmosphericButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isCalibrating;
  
  const RecalibrateAtmosphericButton({
    super.key,
    this.onPressed,
    this.isCalibrating = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return OutlinedButton.icon(
      onPressed: isCalibrating ? null : onPressed,
      icon: isCalibrating 
          ? SizedBox(
              width: IconSizes.md,
              height: IconSizes.md,
              child: CircularProgressIndicator(
                strokeWidth: ChartDimensions.strokeMedium,
                color: theme.colorScheme.primary,
              ),
            )
          : Icon(
              Icons.refresh,
              size: IconSizes.md,
              color: onPressed != null 
                  ? theme.colorScheme.primary 
                  : StatusColors.disabled,
            ),
      label: Text(isCalibrating ? l10n.atmosphericCalibrating : l10n.atmosphericRecalibrate),
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.primary,
        side: BorderSide(
          color: onPressed != null 
              ? theme.colorScheme.primary.withValues(alpha: Opacities.high)
              : StatusColors.disabled.withValues(alpha: Opacities.mediumHigh),
        ),
        padding: const EdgeInsets.symmetric(horizontal: Spacing.xl, vertical: Spacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadii.mdAll,
        ),
      ),
    );
  }
}

class AtmosphericCalibrationOverlay extends StatelessWidget {
  final double progress;
  final VoidCallback? onCancel;
  
  const AtmosphericCalibrationOverlay({
    super.key,
    required this.progress,
    this.onCancel,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final remainingSeconds = ((1.0 - progress) * 3).ceil();
    
    return Container(
      color: OverlayColors.darkOverlay.withValues(alpha: Opacities.veryHigh),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(Spacing.section),
          padding: const EdgeInsets.all(Spacing.section),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadii.xxlAll,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: Opacities.low),
                blurRadius: Shadows.blurLarge,
                offset: const Offset(0, Spacing.smPlus),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(Spacing.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: Opacities.veryLow),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.air,
                  size: IconSizes.display,
                  color: theme.colorScheme.primary,
                ),
              ),
              Spacing.verticalXl,
              
              Text(
                l10n.atmosphericCalibrating,
                style: TextStyle(
                  fontSize: FontSizes.headline,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Spacing.verticalMd,
              
              Text(
                l10n.atmosphericKeepSensorStill,
                style: TextStyle(
                  fontSize: FontSizes.bodyLg,
                  color: theme.colorScheme.onSurface.withValues(alpha: Opacities.veryHigh),
                ),
                textAlign: TextAlign.center,
              ),
              Spacing.verticalXl,
              
              SizedBox(
                width: WidgetSizes.containerWide,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadii.mdAll,
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: Dimensions.progressBarLarge,
                        backgroundColor: theme.colorScheme.primary.withValues(alpha: Opacities.low),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Spacing.verticalMd,
                    Text(
                      l10n.secondsRemaining(remainingSeconds),
                      style: TextStyle(
                        fontSize: FontSizes.titleSm,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              
              if (onCancel != null) ...[
                Spacing.verticalXl,
                TextButton(
                  onPressed: onCancel,
                  child: Text(
                    l10n.cancel,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: Opacities.high),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusIndicatorWithL10n extends StatelessWidget {
  final bool isConnected;
  final bool isScanning;
  
  const _StatusIndicatorWithL10n({
    required this.isConnected,
    required this.isScanning,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    final label = isScanning
        ? l10n.searching
        : isConnected
            ? l10n.deviceConnected
            : l10n.deviceNotConnected;
    final color = theme.colorScheme.secondary;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.xsPlus),
      decoration: BoxDecoration(
        color: isConnected
            ? color.withValues(alpha: Opacities.mediumLow)
            : theme.colorScheme.outline.withValues(alpha: Opacities.veryLow),
        borderRadius: BorderRadii.smAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Spacing.sm,
            height: Spacing.sm,
            decoration: BoxDecoration(
              color: isConnected ? color : theme.colorScheme.outline,
              shape: BoxShape.circle,
            ),
          ),
          Spacing.horizontalSm,
          Text(
            label,
            style: TextStyle(
              fontSize: FontSizes.bodySm,
              fontWeight: FontWeight.bold,
              letterSpacing: LetterSpacings.wide,
              color: isConnected ? color : theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

class ConnectionButton extends StatelessWidget {
  final bool isConnected;
  final bool isScanning;
  final VoidCallback? onPressed;
  
  const ConnectionButton({
    super.key,
    required this.isConnected,
    required this.isScanning,
    this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return SizedBox(
      width: double.infinity,
      height: Dimensions.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: isScanning ? null : onPressed,
        icon: Icon(
          isScanning
              ? Icons.hourglass_empty
              : isConnected
                  ? Icons.power_settings_new
                  : Icons.usb,
          size: IconSizes.lg,
        ),
        label: Text(
          isScanning
              ? l10n.searching
              : isConnected
                  ? l10n.disconnect
                  : l10n.connectDevice,
          style: const TextStyle(
            fontSize: FontSizes.titleSm,
            fontWeight: FontWeight.bold,
            letterSpacing: LetterSpacings.wide,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isConnected
              ? ScoreColors.poor
              : theme.colorScheme.primary,
          foregroundColor: OverlayColors.whiteContent,
          elevation: isConnected ? Elevations.none : Elevations.low,
          shadowColor: theme.colorScheme.primary.withValues(alpha: Opacities.high),
        ),
      ),
    );
  }
}

class ConnectionHelpText extends StatelessWidget {
  const ConnectionHelpText({super.key});
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Text(
      l10n.makeSureDevicePowered,
      style: TextStyle(
        fontSize: FontSizes.body,
        color: StatusColors.tertiaryText,
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// Sensor Error Banner - Shows when BMP280 sensor is not connected
class SensorErrorBanner extends StatelessWidget {
  const SensorErrorBanner({super.key});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadii.lgAll,
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: Opacities.moderate),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.sensors_off,
            color: theme.colorScheme.error,
            size: IconSizes.lg,
          ),
          Spacing.horizontalMd,
              Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.sensorError,
                  style: TextStyle(
                    fontSize: FontSizes.md,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  l10n.sensorErrorDescription,
                  style: TextStyle(
                    fontSize: FontSizes.body,
                    color: theme.colorScheme.onErrorContainer.withValues(alpha: Opacities.high),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
/// Authentication Warning Banner - shown when device is not verified
class AuthenticationWarningBanner extends StatelessWidget {
  const AuthenticationWarningBanner({super.key});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: ScoreColors.warning.withValues(alpha: Opacities.mediumLow),
        borderRadius: BorderRadii.lgAll,
        border: Border.all(
          color: ScoreColors.warning.withValues(alpha: Opacities.high),
          width: ChartDimensions.lineWidthSmall,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: ScoreColors.warning.withValues(alpha: Opacities.medium),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.gpp_bad_outlined,
              color: ScoreColors.warning,
              size: IconSizes.md,
            ),
          ),
          Spacing.horizontalMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.counterfeitWarning,
                  style: const TextStyle(
                    fontSize: FontSizes.md,
                    fontWeight: FontWeight.w600,
                    color: ScoreColors.warning,
                  ),
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  l10n.deviceNotAuthenticated,
                  style: TextStyle(
                    fontSize: FontSizes.bodySm,
                    color: theme.colorScheme.onSurface.withValues(alpha: Opacities.high),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
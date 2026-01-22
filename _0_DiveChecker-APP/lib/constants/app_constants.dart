// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// Application-wide constants and configuration values
/// 
/// Contains theme colors, measurement settings, and UI constants
/// to maintain consistency across the application.
library;

import 'package:flutter/material.dart';

/// App Configuration
class AppConfig {
  static const String appName = 'DiveChecker';
  static const String version = '1.1.0';
  static const String build = '5';
  static const String versionDisplay = '$version (Build $build)';
  
  /// Device product info
  static const String productNameV1 = 'DiveChecker V1';
  static const String productIdV1 = 'DC-V1';
  static const String defaultFirmwareVersion = '4.5.0';
}

/// Status indicator colors
class StatusColors {
  /// Connected/authenticated/success state
  static const Color connected = ScoreColors.excellent;  // Green
  /// Warning/pending state
  static const Color warning = ScoreColors.warning;  // Orange
  /// Error/disconnected state
  static const Color error = ScoreColors.poor;  // Red
  /// Disabled/inactive state
  static const Color disabled = Color(0xFF9E9E9E);  // Grey
  /// Neutral/unknown state
  static const Color neutral = Color(0xFF6B7280);  // Grey
  /// Secondary text/icon color
  static const Color secondaryText = Color(0xFF757575);  // Grey 600
  /// Tertiary text/icon color
  static const Color tertiaryText = Color(0xFF9E9E9E);  // Grey 500
}

/// Overlay colors
class OverlayColors {
  /// Dark overlay background
  static const Color darkOverlay = Color(0xFF000000);
  /// White content background
  static const Color whiteContent = Color(0xFFFFFFFF);
}

/// App Theme Colors - Black & Blue Accent Theme
class AppColors {
  // Light Theme - Better contrast
  static const lightPrimary = Color(0xFF1E40AF);       // Deep blue accent
  static const lightSecondary = Color(0xFF3B82F6);    // Blue accent
  static const lightSurface = Color(0xFFFFFFFF);      // Pure white for cards
  static const lightBackground = Color(0xFFE2E8F0);   // More visible gray background
  static const lightError = Color(0xFFDC2626);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightOnSecondary = Color(0xFFFFFFFF);
  static const lightOnSurface = Color(0xFF111827);    // Near black text
  static const lightOnBackground = Color(0xFF111827);
  static const lightOutline = Color(0xFFB0BEC5);      // More visible gray border
  static const lightOnSurfaceVariant = Color(0xFF546E7A);  // Darker gray for secondary text

  // Dark Theme - Black with Blue Accent
  static const darkPrimary = Color(0xFF3B82F6);       // Blue accent only
  static const darkSecondary = Color(0xFF60A5FA);     // Light blue accent
  static const darkSurface = Color(0xFF111111);       // Pure dark
  static const darkBackground = Color(0xFF000000);    // Pure black
  static const darkError = Color(0xFFF87171);
  static const darkOnPrimary = Color(0xFF000000);
  static const darkOnSecondary = Color(0xFF000000);
  static const darkOnSurface = Color(0xFFE5E7EB);     // Light gray text
  static const darkOnBackground = Color(0xFFE5E7EB);
  static const darkOutline = Color(0xFF374151);       // Dark gray border
  static const darkOnSurfaceVariant = Color(0xFF9CA3AF);  // Muted gray
}

/// Measurement Configuration
class MeasurementConfig {
  /// Maximum data points to keep in memory (30 seconds at 100 Hz)
  static const int maxDataPoints = 3000;
  
  /// Pressure range (hPa - hectopascal, same as mbar)
  /// Negative pressure for suction, positive for blowing
  static const double minPressure = -10.0;
  static const double maxPressure = 25.0;
}

/// UI Constants
class UIConstants {
  /// Border radius
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
  static const double statusBadgeRadius = 8.0;
  
  /// Padding
  static const double screenPadding = 16.0;
  static const double cardPadding = 24.0;
  static const double sectionSpacing = 32.0;
  
  /// Icon sizes
  static const double smallIconSize = 16.0;
  static const double mediumIconSize = 20.0;
  static const double largeIconSize = 28.0;
  static const double xlIconSize = 48.0;
  
  /// Font sizes
  static const double smallFontSize = 11.0;
  static const double mediumFontSize = 14.0;
  static const double largeFontSize = 18.0;
  static const double xlFontSize = 24.0;
  static const double displayFontSize = 68.0;
  
  /// Elevation
  static const double cardElevation = 0.0;
  
  /// Border width
  static const double borderWidth = 2.0;
  static const double thinBorderWidth = 1.5;
}

/// Animation Durations
class AnimationDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration snackBar = Duration(seconds: 2);
}

/// Score-based Colors - Used for performance indicators
class ScoreColors {
  /// Excellent (80+)
  static const Color excellent = Color(0xFF22C55E);  // Green
  static const Color excellentLight = Color(0xFF4ADE80);
  
  /// Good (60-79)
  static const Color good = Color(0xFFF97316);  // Orange
  static const Color goodLight = Color(0xFFFB923C);
  
  /// Warning - alias for good
  static const Color warning = good;
  
  /// Needs Improvement (<60)
  static const Color poor = Color(0xFFEF4444);  // Red
  static const Color poorLight = Color(0xFFF87171);
  
  /// Training phase colors
  static const Color advanced = Color(0xFF22C55E);  // Green
  static const Color intermediate = Color(0xFF3B82F6);  // Blue
  static const Color basic = Color(0xFFF97316);  // Orange
  
  /// Trend colors
  static const Color increasing = Color(0xFF3B82F6);  // Blue
  static const Color stable = Color(0xFF22C55E);  // Green
  static const Color decreasing = Color(0xFFF97316);  // Orange
  
  /// Get color based on score threshold
  static Color fromScore(double score) {
    if (score >= 80) return excellent;
    if (score >= 60) return good;
    return poor;
  }
  
  /// Get color for fatigue level
  static Color fromFatigue(double fatigue) {
    if (fatigue <= 20) return excellent;
    if (fatigue <= 50) return good;
    return poor;
  }
  
  /// Get grade label (S, A, B, C, D, F) based on score
  static String gradeLabel(double score) {
    if (score >= 90) return 'S';
    if (score >= 80) return 'A';
    if (score >= 70) return 'B';
    if (score >= 60) return 'C';
    if (score >= 50) return 'D';
    return 'F';
  }
}

/// Spacing constants - Consistent spacing throughout the app
class Spacing {
  /// Extra extra small spacing (2px)
  static const double xxs = 2.0;
  /// Extra small spacing
  static const double xs = 4.0;
  /// Extra small plus (6px) - xs + 2
  static const double xsPlus = 6.0;
  /// Small spacing
  static const double sm = 8.0;
  /// Small plus (10px) - sm + 2
  static const double smPlus = 10.0;
  /// Medium spacing
  static const double md = 12.0;
  /// Medium plus (14px) - md + 2
  static const double mdPlus = 14.0;
  /// Large spacing
  static const double lg = 16.0;
  /// Extra large spacing
  static const double xl = 20.0;
  /// Extra extra large spacing
  static const double xxl = 24.0;
  /// Section spacing
  static const double section = 32.0;
  
  /// Common SizedBox widgets for convenience
  static const SizedBox verticalXs = SizedBox(height: xs);
  static const SizedBox verticalSm = SizedBox(height: sm);
  static const SizedBox verticalMd = SizedBox(height: md);
  static const SizedBox verticalLg = SizedBox(height: lg);
  static const SizedBox verticalXl = SizedBox(height: xl);
  static const SizedBox verticalXxl = SizedBox(height: xxl);
  
  static const SizedBox horizontalXs = SizedBox(width: xs);
  static const SizedBox horizontalSm = SizedBox(width: sm);
  static const SizedBox horizontalMd = SizedBox(width: md);
  static const SizedBox horizontalLg = SizedBox(width: lg);
  static const SizedBox horizontalXl = SizedBox(width: xl);
  static const SizedBox horizontalXxl = SizedBox(width: xxl);
  
  // Alias for consistency
  static const SizedBox verticalXxs = SizedBox(height: xs);
  static const SizedBox horizontalXxs = SizedBox(width: xs);
  
  /// Pre-built padding constants
  static const EdgeInsets screenPadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(vertical: xxl);
}

/// Border Radius constants
class BorderRadii {
  /// Small radius (4px) - for small elements
  static const double xs = 4.0;
  /// Small radius (6px) - for badges, chips
  static const double sm = 6.0;
  /// Medium radius (8px) - for small cards
  static const double md = 8.0;
  /// Large radius (12px) - for buttons, containers
  static const double lg = 12.0;
  /// Extra large radius (16px) - for cards
  static const double xl = 16.0;
  /// Extra extra large radius (20px) - for large cards
  static const double xxl = 20.0;
  /// Circular radius (999px) - for pills
  static const double circular = 999.0;
  
  /// Pre-built BorderRadius objects
  static final BorderRadius xsAll = BorderRadius.circular(xs);
  static final BorderRadius smAll = BorderRadius.circular(sm);
  static final BorderRadius mdAll = BorderRadius.circular(md);
  static final BorderRadius lgAll = BorderRadius.circular(lg);
  static final BorderRadius xlAll = BorderRadius.circular(xl);
  static final BorderRadius xxlAll = BorderRadius.circular(xxl);
  static final BorderRadius circularAll = BorderRadius.circular(circular);
}

/// Font Size constants
class FontSizes {
  /// Tiny (8px) - markers, annotations
  static const double tiny = 8.0;
  /// Extra extra small (9px) - tiny labels
  static const double xxs = 9.0;
  /// Extra small (10px) - badges, small labels  
  static const double xs = 10.0;
  /// Small (11px) - small labels
  static const double sm = 11.0;
  /// Body (12px) - secondary text
  static const double body = 12.0;
  /// Medium (14px) - primary text
  static const double md = 14.0;
  /// Large (16px) - titles
  static const double lg = 16.0;
  /// Extra large (18px) - headers
  static const double xl = 18.0;
  /// Title large (20px)
  static const double titleLg = 20.0;
  /// Headline (24px)
  static const double headline = 24.0;
  /// Display (28px)
  static const double display = 28.0;
  /// Display large (32px)
  static const double displayLg = 32.0;
  /// Display extra large (68px)
  static const double displayXl = 68.0;
  
  /// Aliases for backward compatibility
  static const double bodySm = sm;
  static const double bodyMd = body;
  static const double bodyLg = md;
  static const double titleSm = lg;
  static const double title = xl;
}

/// Icon Size constants  
class IconSizes {
  /// Tiny (12px)
  static const double tiny = 12.0;
  /// Small (16px)
  static const double sm = 16.0;
  /// Medium (20px)
  static const double md = 20.0;
  /// Large (24px)
  static const double lg = 24.0;
  /// Extra large (28px)
  static const double xl = 28.0;
  /// Extra extra large (32px)
  static const double xxl = 32.0;
  /// Huge (48px)
  static const double huge = 48.0;
  /// Extra huge (56px)
  static const double xHuge = 56.0;
  /// Display (64px)
  static const double display = 64.0;
}

/// Common TextStyles for consistency
class AppTextStyles {
  /// Semi-bold weight - used for list tile titles, section headers
  static const TextStyle semiBold = TextStyle(fontWeight: FontWeight.w600);
  
  /// Bold weight
  static const TextStyle bold = TextStyle(fontWeight: FontWeight.bold);
  
  /// Monospace font - used for values, numbers
  static const TextStyle monospace = TextStyle(fontFamily: 'monospace');
  
  /// App bar title style
  static const TextStyle appBarTitle = TextStyle(
    fontSize: FontSizes.titleSm,
    fontWeight: FontWeight.bold,
    letterSpacing: LetterSpacings.widest,
  );
}

/// Elevation constants
class Elevations {
  /// No elevation
  static const double none = 0.0;
  /// Low elevation
  static const double low = 1.0;
  /// Medium elevation
  static const double medium = 2.0;
  /// High elevation
  static const double high = 4.0;
}

/// Opacity constants
class Opacities {
  /// Subtle opacity (0.02)
  static const double subtle = 0.02;
  /// Faint opacity (0.03)
  static const double faint = 0.03;
  /// Soft opacity (0.04)
  static const double soft = 0.04;
  /// Very low opacity (0.05)
  static const double veryLow = 0.05;
  /// Light opacity (0.08)
  static const double light = 0.08;
  /// Low opacity (0.1)
  static const double low = 0.1;
  /// Medium low opacity (0.15)
  static const double mediumLow = 0.15;
  /// Medium opacity (0.2)
  static const double medium = 0.2;
  /// Medium high opacity (0.3)
  static const double mediumHigh = 0.3;
  /// Moderate opacity (0.4)
  static const double moderate = 0.4;
  /// High opacity (0.5)
  static const double high = 0.5;
  /// Strong opacity (0.6)
  static const double strong = 0.6;
  /// Very high opacity (0.7)
  static const double veryHigh = 0.7;
  /// Almost full opacity (0.8)
  static const double almostFull = 0.8;
  /// Near full opacity (0.9)
  static const double nearFull = 0.9;
}

/// Common widget dimensions
class Dimensions {
  /// Score circle sizes
  static const double scoreCircleSmall = 50.0;
  static const double scoreCircleMedium = 70.0;
  static const double scoreCircleLarge = 90.0;
  static const double scoreCircleXL = 100.0;
  
  /// Aliases for convenience
  static const double scoreCircleSm = scoreCircleSmall;
  static const double scoreCircleMd = scoreCircleMedium;
  static const double scoreCircleLg = scoreCircleMedium;  // 70px - commonly used
  static const double scoreCircleXl = scoreCircleXL;
  
  /// Progress bar heights
  static const double progressBarThin = 4.0;
  static const double progressBarSmall = 6.0;
  static const double progressBarMedium = 8.0;
  static const double progressBarLarge = 10.0;
  
  /// Card minimum heights
  static const double cardMinHeight = 80.0;
  
  /// Heatmap cell size
  static const double heatmapCell = 12.0;
  
  /// Legend indicator size
  static const double legendIndicator = 14.0;
  
  /// Button heights
  static const double buttonHeight = 56.0;
  
  /// Divider height
  static const double dividerHeight = 1.0;
  
  /// Indicator sizes
  static const double indicatorSmall = 20.0;
  static const double indicatorMedium = 24.0;
  static const double indicatorLarge = 28.0;
  static const double indicatorXl = 32.0;
  static const double indicatorXxl = 40.0;
}

/// Letter spacing constants
class LetterSpacings {
  /// Tight (0.3)
  static const double tight = 0.3;
  /// Normal (0.5)
  static const double normal = 0.5;
  /// Wide (1.0)
  static const double wide = 1.0;
  /// Wider (1.2)
  static const double wider = 1.2;
  /// Widest (1.5)
  static const double widest = 1.5;
}

/// Shadow/blur constants
class Shadows {
  /// Small blur
  static const double blurSmall = 2.0;
  /// Medium blur
  static const double blurMedium = 8.0;
  /// Large blur
  static const double blurLarge = 20.0;
  /// Extra large blur
  static const double blurXl = 24.0;
  /// Spread small
  static const double spreadSmall = 2.0;
}

/// Chart-specific dimensions
class ChartDimensions {
  /// Reserved size for left Y-axis labels
  static const double reservedSizeSmall = 25.0;
  static const double reservedSizeMd = 28.0;
  static const double reservedSizeMedium = 30.0;
  static const double reservedSizeLarge = 35.0;
  static const double reservedSizeXl = 40.0;
  static const double reservedSizeXxl = 42.0;
  static const double reservedSizeXxxl = 45.0;
  static const double reservedSizeMax = 50.0;
  
  /// Bar widths
  static const double barWidthThin = 1.0;
  static const double barWidthSmThin = 1.5;
  static const double barWidthSmall = 2.0;
  static const double barWidthMedium = 3.0;
  static const double barWidthLarge = 20.0;
  static const double barWidthXl = 30.0;
  
  /// Stroke widths
  static const double strokeNone = 0.0;
  static const double strokeThin = 0.5;
  static const double strokeNormal = 1.0;
  static const double strokeSmMedium = 1.5;
  static const double strokeMedium = 2.0;
  static const double strokeThick = 4.0;
  static const double strokeBold = 10.0;
  
  /// Chart intervals
  static const double intervalSmall = 5.0;
  static const double intervalMedium = 20.0;
  static const double intervalLarge = 2000.0;
  
  /// Chart line width
  static const double lineWidthThin = 1.0;
  static const double lineWidthSmThin = 1.5;
  static const double lineWidthSmall = 2.0;
  static const double lineWidthMedium = 3.0;
  
  /// Dash array patterns
  static const List<int> dashShort = [5, 3];
  static const List<int> dashMedium = [5, 5];
  static const List<int> dashLong = [8, 4];
  
  /// Dot radius for FlDotCirclePainter
  static const double dotRadiusSmall = 3.0;
  static const double dotRadiusMedium = 4.0;
}

/// Common constraints and sizes for widgets
class WidgetSizes {
  /// Container widths
  static const double containerSmall = 12.0;
  static const double containerMedium = 20.0;
  static const double containerMediumLarge = 24.0;
  static const double containerLarge = 28.0;
  static const double containerXl = 30.0;
  static const double containerXxl = 32.0;
  static const double containerXxxl = 35.0;
  static const double containerHuge = 40.0;
  static const double containerXHuge = 50.0;
  static const double containerLegend = 80.0;
  static const double containerWide = 200.0;
  
  /// Box constraints
  static const double minSize = 6.0;
  static const double minSizeSmall = 10.0;
  static const double minSizeButton = 36.0;
  static const double maxHeightCard = 280.0;
  static const double maxSizeDialog = 600.0;
  
  /// Divider indent
  static const double dividerIndent = 72.0;
  
  /// App bar heights
  static const double expandedAppBarHeight = 200.0;
  
  /// Chart/graph heights
  static const double histogramHeight = 150.0;
  static const double boxplotHeight = 60.0;
  static const double intensityBarHeight = 32.0;
  static const double markerHeight = 45.0;
  static const double boxplotElementHeight = 30.0;
}

/// Text line height constants
class LineHeights {
  /// Normal line height
  static const double normal = 1.5;
  /// Relaxed line height
  static const double relaxed = 1.6;
}

/// Responsive breakpoints for different screen sizes
class Breakpoints {
  /// Compact phone (< 360dp)
  static const double compactPhone = 360;
  /// Standard phone (360-600dp)
  static const double phone = 600;
  /// Small tablet / Large phone (600-840dp)
  static const double tablet = 840;
  /// Large tablet / Desktop (840-1200dp)
  static const double desktop = 1200;
  /// Extra large desktop (> 1200dp)
  static const double desktopXl = 1440;
}

/// Device type enumeration for responsive design
enum DeviceType { compactPhone, phone, tablet, desktop, desktopXl }

/// Responsive utilities for adaptive UI
class Responsive {
  /// Get device type based on screen width
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < Breakpoints.compactPhone) return DeviceType.compactPhone;
    if (width < Breakpoints.phone) return DeviceType.phone;
    if (width < Breakpoints.tablet) return DeviceType.tablet;
    if (width < Breakpoints.desktop) return DeviceType.desktop;
    return DeviceType.desktopXl;
  }
  
  /// Check if device is mobile (phone)
  static bool isMobile(BuildContext context) {
    final type = getDeviceType(context);
    return type == DeviceType.compactPhone || type == DeviceType.phone;
  }
  
  /// Check if device is tablet or larger
  static bool isTabletOrLarger(BuildContext context) {
    final type = getDeviceType(context);
    return type == DeviceType.tablet || type == DeviceType.desktop || type == DeviceType.desktopXl;
  }
  
  /// Check if device is desktop
  static bool isDesktop(BuildContext context) {
    final type = getDeviceType(context);
    return type == DeviceType.desktop || type == DeviceType.desktopXl;
  }
  
  /// Get responsive value based on device type
  static T value<T>(BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final type = getDeviceType(context);
    switch (type) {
      case DeviceType.compactPhone:
      case DeviceType.phone:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
      case DeviceType.desktopXl:
        return desktop ?? tablet ?? mobile;
    }
  }
  
  /// Get responsive padding
  static EdgeInsets padding(BuildContext context) {
    return value(
      context,
      mobile: const EdgeInsets.all(Spacing.md),
      tablet: const EdgeInsets.all(Spacing.lg),
      desktop: const EdgeInsets.all(Spacing.xl),
    );
  }
  
  /// Get responsive font scale
  static double fontScale(BuildContext context) {
    return value(context, mobile: 1.0, tablet: 1.1, desktop: 1.15);
  }
  
  /// Get responsive chart height (percentage of screen)
  static double chartHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final ratio = value(context, mobile: 0.45, tablet: 0.55, desktop: 0.6);
    return (screenHeight * ratio).clamp(250.0, 700.0);
  }
  
  /// Get responsive grid column count
  static int gridColumns(BuildContext context) {
    return value(context, mobile: 1, tablet: 2, desktop: 3);
  }
  
  /// Get max content width (for centering on large screens)
  static double maxContentWidth(BuildContext context) {
    return value(context, mobile: double.infinity, tablet: 720.0, desktop: 1200.0);
  }
  
  /// Get responsive icon size
  static double iconSize(BuildContext context, {double base = IconSizes.md}) {
    return base * fontScale(context);
  }
  
  /// Get screen size info
  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
  
  /// Check if screen is in landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }
}

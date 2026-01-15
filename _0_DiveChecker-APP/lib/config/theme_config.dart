// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

ThemeData createLightTheme() {
  return ThemeData(
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightSurface,
      error: AppColors.lightError,
      onPrimary: AppColors.lightOnPrimary,
      onSecondary: AppColors.lightOnSecondary,
      onSurface: AppColors.lightOnSurface,
      onSurfaceVariant: AppColors.lightOnSurfaceVariant,
      outline: AppColors.lightOutline,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.lightBackground,
    cardTheme: CardThemeData(
      elevation: UIConstants.cardElevation,
      color: AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.cardBorderRadius),
        side: const BorderSide(color: AppColors.lightOutline),
      ),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: Elevations.none,
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightOnSurface,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: Elevations.none,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.xxl, vertical: Spacing.lg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.buttonBorderRadius),
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.lightOnSurface),
      bodyMedium: TextStyle(color: AppColors.lightOnSurface),
      bodySmall: TextStyle(color: AppColors.lightOnSurfaceVariant),
      labelLarge: TextStyle(color: AppColors.lightOnSurface),
      labelMedium: TextStyle(color: AppColors.lightOnSurfaceVariant),
      labelSmall: TextStyle(color: AppColors.lightOnSurfaceVariant),
    ),
  );
}

ThemeData createDarkTheme() {
  return ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      surface: AppColors.darkSurface,
      error: AppColors.darkError,
      onPrimary: AppColors.darkOnPrimary,
      onSecondary: AppColors.darkOnSecondary,
      onSurface: AppColors.darkOnSurface,
      onSurfaceVariant: AppColors.darkOnSurfaceVariant,
      outline: AppColors.darkOutline,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardTheme: CardThemeData(
      elevation: UIConstants.cardElevation,
      color: AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.cardBorderRadius),
        side: const BorderSide(color: AppColors.darkOutline),
      ),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: Elevations.none,
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkOnSurface,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: Elevations.none,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.xxl, vertical: Spacing.lg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.buttonBorderRadius),
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkOnSurface),
      bodyMedium: TextStyle(color: AppColors.darkOnSurface),
      bodySmall: TextStyle(color: AppColors.darkOnSurfaceVariant),
      labelLarge: TextStyle(color: AppColors.darkOnSurface),
      labelMedium: TextStyle(color: AppColors.darkOnSurfaceVariant),
      labelSmall: TextStyle(color: AppColors.darkOnSurfaceVariant),
    ),
  );
}

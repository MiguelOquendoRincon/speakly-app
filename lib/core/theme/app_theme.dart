// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_dimensions.dart';

abstract final class AppTheme {
  static ThemeData get defaultTheme => _buildTheme(
    brightness: Brightness.light,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    primary: AppColors.primary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
  );

  static ThemeData get highContrastTheme => _buildTheme(
    brightness: Brightness.dark,
    surface: AppColors.hcSurface,
    onSurface: AppColors.hcOnSurface,
    primary: AppColors.hcPrimary,
    primaryContainer: AppColors.hcPrimaryContainer,
    onPrimaryContainer: AppColors.hcOnPrimaryContainer,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color surface,
    required Color onSurface,
    required Color primary,
    required Color primaryContainer,
    required Color onPrimaryContainer,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: Colors.white,
        secondary: primary,
        onSecondary: Colors.white,
        error: AppColors.emergency,
        onError: Colors.white,
        surface: surface,
        onSurface: onSurface,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: onSurface),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: onSurface),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: onSurface),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: onSurface),
        labelSmall: AppTextStyles.labelSmall,
      ),

      // Accessibility: ensure focus ring is always visible
      focusColor: primary.withValues(alpha: 0.2),
      highlightColor: primary.withValues(alpha: 0.1),

      // Enforce minimum touch targets via ButtonTheme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(
            AppDimensions.kMinTouchTarget,
            AppDimensions.kMinTouchTarget,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(
            AppDimensions.kMinTouchTarget,
            AppDimensions.kMinTouchTarget,
          ),
        ),
      ),
    );
  }
}

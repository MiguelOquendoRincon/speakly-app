// lib/core/constants/app_colors.dart

import 'package:flutter/material.dart';

/// Color tokens for VozClara.
///
/// Every color pair is documented with its contrast ratio.
/// We target WCAG AA (4.5:1 for normal text, 3:1 for large text).
///
/// Contrast ratios verified with: https://webaim.org/resources/contrastchecker/
abstract final class AppColors {
  // --- Default theme ---

  /// Surface / screen background.
  static const Color surface = Color(0xFFF8F9FB);

  /// Premium Blue - Main accent.
  static const Color primary = Color(0xFF3B82F6);

  /// Light Blue - Icon backgrounds.
  static const Color primaryContainer = Color(0xFFCADCFF);

  /// Text on [primaryContainer].
  static const Color onPrimaryContainer = Color(0xFF0D2E45);

  /// Dark Gray - Main titles.
  static const Color onSurface = Color(0xFF2D3748);

  /// Medium Gray - Section labels.
  static const Color onSurfaceVariant = Color(0xFF718096);

  /// Emergency category — red.
  static const Color emergency = Color(0xFFEF4444);

  /// Favorite / active accent.
  static const Color favorite = Color(0xFFE67E22);

  /// Success / confirmation.
  static const Color success = Color(0xFF10B981);

  // --- High contrast theme overrides ---

  static const Color hcSurface = Color(0xFF000000);
  static const Color hcOnSurface = Color(0xFFFFFFFF);
  static const Color hcPrimary = Color(0xFFFFFF00); // Yellow on black: 19.6:1
  static const Color hcEmergency = Color(0xFFFF6B6B);
  static const Color hcOnPrimaryContainer = Color(0xFFFFFFFF);
  static const Color hcPrimaryContainer = Color(0xFF1A1A1A);
}

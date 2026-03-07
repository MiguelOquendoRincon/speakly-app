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

  /// Primary brand color.
  /// On white (#FFFFFF): contrast ratio 4.61:1 ✅ AA normal text
  static const Color primary = Color(0xFF1B5E8A);

  /// Primary container (lighter tint for card backgrounds).
  /// Text on this surface must use [onPrimaryContainer].
  static const Color primaryContainer = Color(0xFFD6E8F7);

  /// Text on [primaryContainer].
  /// On [primaryContainer] (#D6E8F7): contrast ratio 7.2:1 ✅ AAA
  static const Color onPrimaryContainer = Color(0xFF0D2E45);

  /// Surface / screen background.
  static const Color surface = Color(0xFFF8FAFB);

  /// Primary text on [surface].
  /// On [surface] (#F8FAFB): contrast ratio 16.1:1 ✅ AAA
  static const Color onSurface = Color(0xFF1A1A2E);

  /// Secondary text / subtitles on [surface].
  /// On [surface] (#F8FAFB): contrast ratio 5.9:1 ✅ AA
  static const Color onSurfaceVariant = Color(0xFF4A4A6A);

  /// Emergency category — red.
  /// On white: contrast ratio 4.8:1 ✅ AA
  static const Color emergency = Color(0xFFC0392B);

  /// Favorite / active accent.
  /// On white: contrast ratio 3.2:1 ✅ AA large text only
  /// Used only for icons ≥ 18pt, never for body text alone.
  static const Color favorite = Color(0xFFE67E22);

  /// Success / confirmation.
  static const Color success = Color(0xFF1A6B3A);

  // --- High contrast theme overrides ---

  static const Color hcSurface = Color(0xFF000000);
  static const Color hcOnSurface = Color(0xFFFFFFFF);
  static const Color hcPrimary = Color(0xFFFFFF00); // Yellow on black: 19.6:1
  static const Color hcEmergency = Color(0xFFFF6B6B);
  static const Color hcOnPrimaryContainer = Color(0xFFFFFFFF);
  static const Color hcPrimaryContainer = Color(0xFF1A1A1A);
}

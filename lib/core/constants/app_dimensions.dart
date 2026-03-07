// lib/core/constants/app_dimensions.dart

/// All spacing, sizing, and touch target constants for VozClara.
///
/// Accessibility note: kMinTouchTarget (48dp) is the minimum
/// interactive element size per WCAG 2.5.5 and both Material/HIG
/// guidelines. Primary navigation elements use kPrimaryTouchTarget.
abstract final class AppDimensions {
  // Touch targets
  static const double kMinTouchTarget = 48.0;
  static const double kPrimaryTouchTarget = 80.0; // Category cards

  // Spacing
  static const double kSpacingXS = 4.0;
  static const double kSpacingS = 8.0;
  static const double kSpacingM = 16.0;
  static const double kSpacingL = 24.0;
  static const double kSpacingXL = 32.0;

  // Border radius
  static const double kRadiusS = 8.0;
  static const double kRadiusM = 12.0;
  static const double kRadiusL = 16.0;

  // Category grid
  static const double kCategoryCardMinHeight = 100.0;
  static const int kCategoryGridColumns = 2;

  // Phrase cards
  static const double kPhraseCardMinHeight = 72.0;
}

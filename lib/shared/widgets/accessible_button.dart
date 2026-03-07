import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';

/// A base accessible button enforcing WCAG 2.5.5 minimum touch target.
///
/// Accessibility decisions:
/// - Minimum size is always [AppDimensions.kMinTouchTarget] x
///   [AppDimensions.kMinTouchTarget] (48x48dp). WCAG 2.5.5.
/// - [semanticLabel] is required — no button may be unlabeled.
/// - [hint] describes what happens on activation, not what the button is.
///   Example: label = "Favorito", hint = "Doble toque para agregar a favoritos".
/// - [isEnabled] drives both the visual disabled state and
///   Semantics(enabled:), so screen readers announce unavailability.
/// - Focus ring is always visible via theme's focusColor. Never suppressed.
class AccessibleButton extends StatelessWidget {
  const AccessibleButton({
    super.key,
    required this.onPressed,
    required this.semanticLabel,
    required this.child,
    this.hint,
    this.isEnabled = true,
    this.minSize = AppDimensions.kMinTouchTarget,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.elevation = 0,
  });

  final VoidCallback? onPressed;
  final String semanticLabel;
  final String? hint;
  final bool isEnabled;
  final double minSize;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      hint: hint,
      button: true,
      enabled: isEnabled,
      // excludeSemantics: true prevents child widgets from adding
      // redundant nodes beneath this explicit semantic declaration.
      excludeSemantics: true,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(minSize, minSize),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: elevation,
          padding:
              padding ??
              const EdgeInsets.symmetric(
                horizontal: AppDimensions.kSpacingM,
                vertical: AppDimensions.kSpacingS,
              ),
          shape: RoundedRectangleBorder(
            borderRadius:
                borderRadius ?? BorderRadius.circular(AppDimensions.kRadiusM),
          ),
        ),
        child: child,
      ),
    );
  }
}

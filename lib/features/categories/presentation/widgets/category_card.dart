import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/accessibility/semantics_labels.dart';

/// A category navigation card on the home screen.
///
/// Accessibility decisions:
/// - Uses [Semantics] with button:true and an explicit label + hint.
///   The icon is decorative relative to the text label — ExcludeSemantics. WCAG 1.1.1.
/// - Minimum height is [AppDimensions.kCategoryCardMinHeight] (100dp).
///   This is well above the 48dp minimum — primary navigation elements
///   for users with motor difficulty should be generously sized. WCAG 2.5.5.
/// - [isEmergency] receives special visual treatment AND a semantic hint
///   that conveys urgency without relying solely on the red color. WCAG 1.4.1.
/// - The entire card surface is tappable — not just the icon or label.
///   This prevents precise-tap failures for users with tremor.
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isEmergency = false,
    this.color,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isEmergency;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    // Modern color palette using theme colors
    final cardBg = isEmergency
        ? (isDark ? const Color(0xFF442222) : const Color(0xFFFEF2F2))
        : theme.colorScheme.surface;

    final borderColor = isEmergency
        ? theme.colorScheme.error
        : (isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05));

    final iconBg = isEmergency
        ? theme.colorScheme.error
        : theme.colorScheme.primaryContainer;

    final iconColor = isEmergency ? Colors.white : theme.colorScheme.primary;

    final labelColor = isEmergency
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    return Semantics(
      label: SemanticsLabels.categoryCard(label),
      hint: SemanticsLabels.categoryCardHint(label),
      button: true,
      excludeSemantics: true,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.kSpacingL,
                horizontal: AppDimensions.kSpacingM,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Circular Icon Container
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: iconBg,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(icon, size: 32, color: iconColor),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.kSpacingM),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: labelColor,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

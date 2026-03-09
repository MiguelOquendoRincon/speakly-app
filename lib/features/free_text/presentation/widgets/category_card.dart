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

    final bgColor = isEmergency
        ? const Color(0xFFFFEBEB) // light red tint — emergency distinction
        : theme.colorScheme.primaryContainer;

    final iconColor = isEmergency
        ? const Color(0xFFC0392B)
        : theme.colorScheme.primary;

    final labelColor = isEmergency
        ? const Color(0xFFC0392B)
        : theme.colorScheme.onPrimaryContainer;

    return Semantics(
      label: SemanticsLabels.categoryCard(label),
      hint: SemanticsLabels.categoryCardHint(label),
      button: true,
      // excludeSemantics prevents child Text and Icon widgets from
      // creating redundant nodes in the semantic tree.
      excludeSemantics: true,
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppDimensions.kCategoryCardMinHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.kSpacingM),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ExcludeSemantics(
                    child: Icon(icon, size: 36, color: iconColor),
                  ),
                  const SizedBox(height: AppDimensions.kSpacingS),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: labelColor,
                      fontWeight: FontWeight.w600,
                    ),
                    // Allow text to scale — never clamp or overflow-hide
                    // category labels. They are the primary navigation.
                    overflow: TextOverflow.visible,
                    softWrap: true,
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

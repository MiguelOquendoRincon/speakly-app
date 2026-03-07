import 'package:flutter/material.dart';
import '../../core/accessibility/semantics_labels.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_colors.dart';

/// A phrase card with a primary speak action and a secondary favorite toggle.
///
/// Semantic structure (from Phase 1 ADR-001):
///
///   MergeSemantics             ← merges icon + text into one focus node
///     InkWell (primary tap)
///       icon (ExcludeSemantics)
///       phrase text
///   Semantics (favorite toggle) ← separate focus node, separate action
///     IconButton
///
/// Why two separate nodes?
/// If we merged everything into one, screen reader users could only
/// activate one action (the primary). The favorite toggle is a distinct,
/// persistent action that deserves its own focus stop.
///
/// WCAG: 4.1.2, 1.1.1, 2.5.5, 1.4.1
class PhraseCard extends StatelessWidget {
  const PhraseCard({
    super.key,
    required this.phraseText,
    required this.onSpeak,
    required this.onFavoriteToggle,
    required this.isFavorite,
    this.isEmergency = false,
    this.icon,
    this.subtitle,
  });

  final String phraseText;
  final VoidCallback onSpeak;
  final VoidCallback onFavoriteToggle;
  final bool isFavorite;
  final bool isEmergency;
  final IconData? icon;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final cardColor = isEmergency
        ? AppColors.emergency
        : theme.colorScheme.surface;

    final textColor = isEmergency ? Colors.white : theme.colorScheme.onSurface;

    return Card(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.kRadiusM),
        side: isEmergency
            ? BorderSide.none
            : BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppDimensions.kPhraseCardMinHeight,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.kSpacingM,
            vertical: AppDimensions.kSpacingS,
          ),
          child: Row(
            children: [
              // PRIMARY ACTION — merged icon + text
              Expanded(
                child: MergeSemantics(
                  child: InkWell(
                    onTap: onSpeak,
                    borderRadius: BorderRadius.circular(AppDimensions.kRadiusS),
                    child: Semantics(
                      label: phraseText,
                      hint: SemanticsLabels.phraseCardHint(phraseText),
                      button: true,
                      // excludeSemantics on the InkWell's subtree because
                      // MergeSemantics + explicit Semantics above already
                      // declare the full accessible description.
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.kSpacingS,
                        ),
                        child: Row(
                          children: [
                            if (icon != null) ...[
                              ExcludeSemantics(
                                child: Icon(
                                  icon,
                                  size: 28,
                                  color: isEmergency
                                      ? Colors.white
                                      : theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: AppDimensions.kSpacingM),
                            ],
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    phraseText,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: textColor,
                                      fontWeight: isEmergency
                                          ? FontWeight.w800
                                          : FontWeight.w600,
                                    ),
                                  ),
                                  if (subtitle != null) ...[
                                    const SizedBox(height: 2),
                                    ExcludeSemantics(
                                      // Subtitle is decorative context.
                                      // The phrase text is the accessible name.
                                      child: Text(
                                        subtitle!,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: isEmergency
                                                  ? Colors.white70
                                                  : theme
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                            ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // SECONDARY ACTION — favorite toggle (separate focus node)
              Semantics(
                label: isFavorite
                    ? SemanticsLabels.removeFromFavorites(phraseText)
                    : SemanticsLabels.addToFavorites(phraseText),
                button: true,
                // 'checked' is for checkboxes; 'toggled' is for
                // on/off states like favorites. ADR-003.
                toggled: isFavorite,
                excludeSemantics: true,
                child: SizedBox(
                  width: AppDimensions.kMinTouchTarget,
                  height: AppDimensions.kMinTouchTarget,
                  child: IconButton(
                    onPressed: onFavoriteToggle,
                    icon: Icon(
                      // Shape change conveys state — not color alone. WCAG 1.4.1.
                      isFavorite
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: isFavorite
                          ? AppColors.favorite
                          : (isEmergency
                                ? Colors.white54
                                : theme.colorScheme.onSurfaceVariant),
                    ),
                    tooltip: null, // suppressed — Semantics label handles this
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

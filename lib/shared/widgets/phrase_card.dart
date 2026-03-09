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
    this.isSpeaking = false,
    this.icon,
    this.subtitle,
  });

  final String phraseText;
  final VoidCallback onSpeak;
  final VoidCallback onFavoriteToggle;
  final bool isFavorite;
  final bool isEmergency;
  final bool isSpeaking;
  final IconData? icon;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseCardColor = isEmergency
        ? AppColors.emergency
        : (isDark ? theme.colorScheme.surface : Colors.white);

    final textColor = isEmergency ? Colors.white : theme.colorScheme.onSurface;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: baseCardColor,
        borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
        border: Border.all(
          color: isSpeaking
              ? theme.colorScheme.primary
              : (isEmergency
                    ? Colors.transparent
                    : theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
          width: isSpeaking ? 2 : 1,
        ),
        boxShadow: isSpeaking
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSpeak,
          borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 80),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.kSpacingM,
                vertical: AppDimensions.kSpacingS,
              ),
              child: Row(
                children: [
                  // PRIMARY ACTION CONTENT
                  Expanded(
                    child: MergeSemantics(
                      child: Semantics(
                        label: phraseText,
                        hint: SemanticsLabels.phraseCardHint(phraseText),
                        button: true,
                        child: Row(
                          children: [
                            if (icon != null) ...[
                              Container(
                                padding: const EdgeInsets.all(
                                  AppDimensions.kSpacingS,
                                ),
                                decoration: BoxDecoration(
                                  color: isEmergency
                                      ? Colors.white.withValues(alpha: 0.2)
                                      : theme.colorScheme.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  icon,
                                  size: 24,
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
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: textColor,
                                          fontWeight: isEmergency
                                              ? FontWeight.w900
                                              : FontWeight.w700,
                                        ),
                                  ),
                                  if (subtitle != null) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      subtitle!,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: isEmergency
                                                ? Colors.white70
                                                : theme
                                                      .colorScheme
                                                      .onSurfaceVariant,
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

                  // SECONDARY ACTION — favorite toggle
                  Semantics(
                    label: isFavorite
                        ? SemanticsLabels.removeFromFavorites(phraseText)
                        : SemanticsLabels.addToFavorites(phraseText),
                    button: true,
                    toggled: isFavorite,
                    excludeSemantics: true,
                    child: IconButton(
                      onPressed: onFavoriteToggle,
                      icon: Icon(
                        isFavorite
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: isFavorite
                            ? AppColors.favorite
                            : (isEmergency
                                  ? Colors.white70
                                  : theme.colorScheme.onSurfaceVariant),
                        size: 28,
                      ),
                    ),
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

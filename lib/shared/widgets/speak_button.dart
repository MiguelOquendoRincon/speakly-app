import 'package:flutter/material.dart';
import '../../core/accessibility/semantics_labels.dart';
import '../../core/constants/app_dimensions.dart';
import 'accessible_button.dart';

/// The primary TTS trigger button used throughout VozClara.
///
/// Accessibility decisions:
/// - Label changes based on [isSpeaking] state so screen readers
///   announce the current action available, not a static label.
/// - [isEnabled] is false when there is no text to speak, which
///   causes Semantics to announce the button as unavailable.
///   This satisfies WCAG 4.1.2 (Name, Role, Value).
/// - The icon is excluded from semantics — the label carries
///   all meaning. WCAG 1.1.1.
/// - Width is full by default to maximize touch target on small screens.
class SpeakButton extends StatelessWidget {
  const SpeakButton({
    super.key,
    required this.onPressed,
    this.isSpeaking = false,
    this.isEnabled = true,
    this.phraseText,
    this.fullWidth = true,
  });

  final VoidCallback onPressed;
  final bool isSpeaking;
  final bool isEnabled;

  /// When provided, the semantic hint includes the phrase for context.
  final String? phraseText;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = isSpeaking
        ? SemanticsLabels.ttsSpeaking
        : SemanticsLabels.speakButtonLabel;
    final hint = phraseText != null
        ? SemanticsLabels.phraseCardHint(phraseText!)
        : SemanticsLabels.speakButtonHint;

    final button = AccessibleButton(
      onPressed: onPressed,
      semanticLabel: label,
      hint: hint,
      isEnabled: isEnabled,
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.kSpacingL,
        vertical: AppDimensions.kSpacingM,
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSpeaking ? Icons.stop_rounded : Icons.volume_up_rounded,
            size: 22,
          ),
          const SizedBox(width: AppDimensions.kSpacingS),
          Text(
            isSpeaking ? 'Detener' : 'Reproducir',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (fullWidth) return SizedBox(width: double.infinity, child: button);
    return button;
  }
}

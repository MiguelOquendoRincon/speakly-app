import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../../../../core/accessibility/semantics_labels.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/speak_button.dart';
import '../../../../shared/widgets/accessible_button.dart';

/// Free text / Message Composer screen.
///
/// Semantic structure (from Phase 1 contract):
///
///   Header: "Escribe tu mensaje" (header: true)
///   TextField: visible label "Mensaje a reproducir" (not placeholder only)
///   Live region: character count — announced on change
///   Speak button: disabled when empty, label changes when speaking
///   Clear button: disabled when empty
///
/// Key accessibility decisions on this screen:
///
/// 1. VISIBLE LABEL on TextField (ADR-004):
///    InputDecoration.labelText persists above the field when focused.
///    hintText alone disappears on input — unusable for users who type slowly
///    or pause mid-message. WCAG 3.3.2.
///
/// 2. CHARACTER COUNT as live region:
///    SemanticsService.announce() is called when count crosses
///    meaningful thresholds (not on every keystroke — that would be
///    overwhelming for screen reader users). WCAG 4.1.3.
///
/// 3. SPEAK BUTTON disabled state communicated semantically:
///    Semantics(enabled: false) causes TalkBack to announce "indisponible"
///    so users know why the button is not activatable. WCAG 4.1.2.
///
/// 4. TTS + screen reader coexistence (Phase 4 full implementation):
///    The TtsService will handle audio channel coordination.
///    This screen prepares the Speak button state correctly.
class FreeTextPage extends StatefulWidget {
  const FreeTextPage({super.key});

  @override
  State<FreeTextPage> createState() => _FreeTextPageState();
}

class _FreeTextPageState extends State<FreeTextPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  bool _isSpeaking = false;
  static const int _maxLength = 300;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
    // Only announce count at meaningful thresholds to avoid spamming
    // screen reader users on every keystroke.
    final remaining = _maxLength - _controller.text.length;
    if (remaining == 50 || remaining == 20 || remaining == 10) {
      SemanticsService.announce(
        SemanticsLabels.characterCount(remaining),
        TextDirection.ltr,
      );
    }
  }

  Future<void> _onSpeak() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() => _isSpeaking = true);

    // Phase 4: sl<TtsService>().speak(_controller.text)
    // Simulated delay for Phase 3 UI development:
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) setState(() => _isSpeaking = false);
  }

  void _onClear() {
    _controller.clear();
    // Return focus to text field after clearing so the user
    // doesn't lose their place in the navigation flow. WCAG 2.4.3.
    _textFieldFocus.requestFocus();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _textFieldFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasText = _controller.text.trim().isNotEmpty;
    final remaining = _maxLength - _controller.text.length;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        // Back button — explicit label for screen readers.
        leading: Semantics(
          label: SemanticsLabels.backToCategories,
          button: true,
          excludeSemantics: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
        title: Text(
          'Compositor de mensajes',
          style: theme.textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.kSpacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.kSpacingL),

              // Screen heading — announced as header for screen readers.
              Semantics(
                header: true,
                child: Text(
                  '¿Qué quieres decir?',
                  style: theme.textTheme.displayLarge,
                ),
              ),
              const SizedBox(height: AppDimensions.kSpacingS),

              // Subtitle — decorative instruction, excluded from semantics
              // because the TextField's label already communicates purpose.
              ExcludeSemantics(
                child: Text(
                  'Escribe tu mensaje y toca Reproducir',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.kSpacingXL),

              // TEXT FIELD
              // Explicit Semantics wrapper provides label + hint even when
              // Flutter's built-in TextField semantics might not be enough.
              Semantics(
                label: SemanticsLabels.freeTextFieldLabel,
                hint: SemanticsLabels.freeTextFieldHint,
                textField: true,
                child: TextField(
                  controller: _controller,
                  focusNode: _textFieldFocus,
                  maxLines: 5,
                  minLines: 3,
                  maxLength: _maxLength,
                  // counterText hides the default counter — we provide
                  // our own accessible version below.
                  decoration: InputDecoration(
                    // ADR-004: labelText persists above the field.
                    // Never use hintText alone for a required field context.
                    labelText: SemanticsLabels.freeTextFieldLabel,
                    hintText: 'Empieza a escribir...',
                    counterText: '',
                    filled: true,
                    fillColor: theme.colorScheme.primaryContainer.withOpacity(
                      0.3,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.kRadiusM,
                      ),
                      borderSide: BorderSide(
                        // Border must have 3:1 contrast against background.
                        // WCAG 1.4.11.
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.kRadiusM,
                      ),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  style: theme.textTheme.phraseText,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _onSpeak(),
                ),
              ),

              const SizedBox(height: AppDimensions.kSpacingS),

              // CHARACTER COUNT — right-aligned, announced as live region
              // at thresholds (see _onTextChanged). Not announced on every
              // keystroke to avoid overwhelming screen reader users.
              Align(
                alignment: Alignment.centerRight,
                child: Semantics(
                  // liveRegion: true would announce on every change —
                  // too noisy. We use SemanticsService.announce() instead
                  // at specific thresholds in _onTextChanged.
                  liveRegion: false,
                  label: SemanticsLabels.characterCount(remaining),
                  child: Text(
                    '$remaining caracteres restantes',
                    style: theme.textTheme.labelSmall,
                  ),
                ),
              ),

              const Spacer(),

              // SPEAK BUTTON
              SpeakButton(
                onPressed: _onSpeak,
                isSpeaking: _isSpeaking,
                isEnabled: hasText,
              ),

              const SizedBox(height: AppDimensions.kSpacingM),

              // CLEAR BUTTON — secondary action, outline style
              SizedBox(
                width: double.infinity,
                child: AccessibleButton(
                  onPressed: _onClear,
                  semanticLabel: SemanticsLabels.clearButtonLabel,
                  hint: 'Doble toque para borrar el mensaje escrito',
                  isEnabled: hasText,
                  backgroundColor: Colors.transparent,
                  foregroundColor: theme.colorScheme.primary,
                  elevation: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ExcludeSemantics(
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: hasText
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.kSpacingS),
                      Text(
                        'Borrar mensaje',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: hasText
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.kSpacingM),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension to expose phraseText style via theme
extension on TextTheme {
  TextStyle? get phraseText => titleLarge;
}

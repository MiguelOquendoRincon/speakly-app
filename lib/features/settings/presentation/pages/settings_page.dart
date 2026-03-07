import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voz_clara/features/settings/presentation/cubit/settings_cubit_cubit.dart';
import '../../../../core/accessibility/semantics_labels.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Accessibility Settings screen.
///
/// Semantic structure (from Phase 1 contract):
///
///   Header: "Accesibilidad" (header: true)
///   Section: "Preferencias visuales"
///     - High contrast toggle (toggled: isOn)
///     - Large text toggle (toggled: isOn)
///     - Reduce motion toggle (toggled: isOn)
///   Section: "Preferencias de audio"
///     - Voice speed slider (slider role, value, increasedValue, decreasedValue)
///     - Test voice speed button
///
/// Key accessibility decisions:
///
/// 1. TOGGLED vs CHECKED (ADR-003):
///    SwitchListTile uses 'toggled' semantics, not 'checked'.
///    toggled → announces as "activado/desactivado" (switch role)
///    checked → announces as "marcado/desmarcado" (checkbox role)
///    Using the wrong one causes VoiceOver/TalkBack to announce
///    the wrong control type. WCAG 4.1.2.
///
/// 2. SLIDER SEMANTICS:
///    The Slider widget must provide value, increasedValue, and
///    decreasedValue so screen reader users can understand the
///    current state and what gestures will change it. WCAG 4.1.2.
///
/// 3. SECTION HEADERS:
///    Visual section labels use Semantics(header: true) so screen
///    reader users can jump between sections. WCAG 2.4.6.
///
/// 4. SETTINGS DO NOT NAVIGATE:
///    Toggling a setting changes state only. No unexpected navigation
///    or context change on input. WCAG 3.2.2.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: Semantics(
          label: 'Volver',
          button: true,
          excludeSemantics: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
        title: Text('Configuración', style: theme.textTheme.headlineMedium),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          final cubit = context.read<SettingsCubit>();
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.kSpacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SECTION: Visual preferences
                  _SectionHeader(label: 'Preferencias visuales'),
                  const SizedBox(height: AppDimensions.kSpacingS),

                  _AccessibleSwitchTile(
                    label: SemanticsLabels.highContrastLabel,
                    description: 'Aumenta la diferenciación de colores',
                    icon: Icons.contrast,
                    value: settings.isHighContrast,
                    onChanged: (_) => cubit.toggleHighContrast(),
                  ),

                  _AccessibleSwitchTile(
                    label: SemanticsLabels.reduceMotionLabel,
                    description: 'Minimiza los efectos de animación',
                    icon: Icons.motion_photos_off_outlined,
                    value: settings.reduceMotion,
                    onChanged: (_) => cubit.toggleReduceMotion(),
                  ),

                  const SizedBox(height: AppDimensions.kSpacingXL),

                  // SECTION: Audio preferences
                  _SectionHeader(label: 'Preferencias de audio'),
                  const SizedBox(height: AppDimensions.kSpacingM),

                  _VoiceSpeedControl(
                    rate: settings.ttsSpeechRate,
                    onChanged: cubit.setSpeechRate,
                  ),

                  const SizedBox(height: AppDimensions.kSpacingXL),

                  // Info note — decorative, excluded from semantics.
                  // It provides no actionable information.
                  ExcludeSemantics(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimensions.kSpacingM),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withOpacity(
                          0.5,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.kRadiusM,
                        ),
                      ),
                      child: Text(
                        'Estos ajustes personalizan tu experiencia en VozClara. '
                        'Los cambios se guardan automáticamente.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private sub-widgets
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      header: true,
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _AccessibleSwitchTile extends StatelessWidget {
  const _AccessibleSwitchTile({
    required this.label,
    required this.description,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String description;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // SwitchListTile automatically applies toggled semantics (not checked).
    // We wrap with explicit Semantics to also provide a contextual hint
    // that announces the current state and available action. ADR-003.
    return Semantics(
      label: label,
      hint: value
          ? 'Activado. Doble toque para desactivar'
          : 'Desactivado. Doble toque para activar',
      toggled: value,
      // excludeSemantics: true here would suppress SwitchListTile's own
      // semantics. We DON'T exclude — SwitchListTile's semantics are
      // correct; we only add the hint via the outer wrapper.
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(label, style: theme.textTheme.titleLarge),
        subtitle: Text(description, style: theme.textTheme.bodyMedium),
        secondary: Icon(icon, color: theme.colorScheme.primary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.kSpacingM,
          vertical: AppDimensions.kSpacingXS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.kRadiusM),
        ),
        tileColor: theme.colorScheme.surface,
      ),
    );
  }
}

class _VoiceSpeedControl extends StatelessWidget {
  const _VoiceSpeedControl({required this.rate, required this.onChanged});

  final double rate;
  final ValueChanged<double> onChanged;

  // Discrete steps for the slider — more predictable for motor-impaired users.
  static const _min = 0.1;
  static const _max = 1.0;
  static const _divisions = 9;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rateLabel = SemanticsLabels.ttsSpeechRateValue(rate);
    final fasterRate = (rate + 0.1).clamp(_min, _max);
    final slowerRate = (rate - 0.1).clamp(_min, _max);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.kSpacingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.kRadiusM),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.record_voice_over_outlined,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppDimensions.kSpacingM),
              Text(
                SemanticsLabels.ttsSpeechRateLabel,
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.kSpacingM),

          // Slider with full semantic context.
          // value, increasedValue, decreasedValue allow screen reader users
          // to know current state + what gestures will do. WCAG 4.1.2.
          Semantics(
            label: SemanticsLabels.ttsSpeechRateLabel,
            hint: SemanticsLabels.ttsSpeechRateHint,
            slider: true,
            value: rateLabel,
            increasedValue: SemanticsLabels.ttsSpeechRateValue(fasterRate),
            decreasedValue: SemanticsLabels.ttsSpeechRateValue(slowerRate),
            excludeSemantics: true,
            child: Slider(
              value: rate,
              min: _min,
              max: _max,
              divisions: _divisions,
              onChanged: onChanged,
            ),
          ),

          // Speed labels below slider — decorative (excluded from semantics
          // because the Slider's value/increasedValue/decreasedValue already
          // communicates this to screen reader users).
          ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.kSpacingXS,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Lento', style: theme.textTheme.labelSmall),
                  Text('Normal', style: theme.textTheme.labelSmall),
                  Text('Rápido', style: theme.textTheme.labelSmall),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.kSpacingM),

          // Test button — gives immediate feedback on current speed setting.
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Phase 4: sl<TtsService>().speak('Esta es la velocidad seleccionada')
              },
              icon: ExcludeSemantics(
                child: const Icon(Icons.play_circle_outline_rounded),
              ),
              label: const Text('Probar velocidad de voz'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(
                  double.infinity,
                  AppDimensions.kMinTouchTarget,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.kRadiusM),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

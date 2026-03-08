import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voz_clara/features/settings/presentation/cubit/settings_cubit_cubit.dart';
import '../../../../core/accessibility/semantics_labels.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Pantalla de Configuración de Accesibilidad.
///
/// Mejorada siguiendo la guía visual premium:
/// - Tarjetas con iconos circulares.
/// - Secciones claramente divididas.
/// - Control de velocidad de voz con slider y etiquetas de escala.
/// - Nota informativa al final.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          final cubit = context.read<SettingsCubit>();
          return SafeArea(
            child: Column(
              children: [
                // CUSTOM HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.kSpacingM,
                    vertical: AppDimensions.kSpacingS,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_rounded),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                      ),
                      Text(
                        'Ajustes de Accesibilidad',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimensions.kSpacingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SECTION: Preferencias Visuales
                        _SectionHeader(label: 'PREFERENCIAS VISUALES'),
                        const SizedBox(height: AppDimensions.kSpacingM),

                        _SettingSwitchCard(
                          label: 'Modo alto contraste',
                          description: 'Aumenta la diferenciación de colores',
                          icon: Icons.contrast_rounded,
                          value: settings.isHighContrast,
                          onChanged: (_) => cubit.toggleHighContrast(),
                        ),
                        const SizedBox(height: AppDimensions.kSpacingM),

                        _SettingSwitchCard(
                          label: 'Texto grande',
                          description:
                              'Aumenta el tamaño de la fuente del sistema',
                          icon: Icons.text_fields_rounded,
                          value:
                              false, // Placeholder para futura implementación
                          onChanged: (_) {},
                        ),
                        const SizedBox(height: AppDimensions.kSpacingM),

                        _SettingSwitchCard(
                          label: 'Movimiento reducido',
                          description: 'Minimiza los efectos de animación',
                          icon: Icons.motion_photos_off_rounded,
                          value: settings.reduceMotion,
                          onChanged: (_) => cubit.toggleReduceMotion(),
                        ),

                        const SizedBox(height: AppDimensions.kSpacingXL),

                        // SECTION: Preferencias de Audio
                        _SectionHeader(label: 'PREFERENCIAS DE AUDIO'),
                        const SizedBox(height: AppDimensions.kSpacingM),

                        _VoiceSpeedCard(
                          rate: settings.ttsSpeechRate,
                          onChanged: cubit.setSpeechRate,
                        ),

                        const SizedBox(height: AppDimensions.kSpacingXL),

                        // FOOTER INFO
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(
                            AppDimensions.kSpacingL,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.kRadiusL,
                            ),
                          ),
                          child: Text(
                            'Estos ajustes ayudan a personalizar tu experiencia en VozClara. Los cambios se guardan automáticamente.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.kSpacingXL),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      header: true,
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _SettingSwitchCard extends StatelessWidget {
  const _SettingSwitchCard({
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

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.05),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.kSpacingM),
        child: Row(
          children: [
            // Circular Icon Background
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.5,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 24),
            ),
            const SizedBox(width: AppDimensions.kSpacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _VoiceSpeedCard extends StatelessWidget {
  const _VoiceSpeedCard({required this.rate, required this.onChanged});

  final double rate;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.05),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppDimensions.kSpacingM),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.5,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.record_voice_over_rounded,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppDimensions.kSpacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Velocidad de voz',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Ajusta el ritmo al que se reproduce el texto',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.kSpacingL),

          // Labels for Scale
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.kSpacingM,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ScaleLabel(label: 'LENTO'),
                _ScaleLabel(label: 'NORMAL'),
                _ScaleLabel(label: 'RÁPIDO'),
              ],
            ),
          ),

          Slider(
            value: rate,
            min: 0.1,
            max: 1.0,
            divisions: 9,
            activeColor: theme.colorScheme.primary,
            onChanged: onChanged,
          ),

          const SizedBox(height: AppDimensions.kSpacingS),

          // Test Button
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                // Phase 4: trigger test speak
              },
              icon: const Icon(Icons.play_circle_filled_rounded),
              label: const Text('PROBAR VELOCIDAD DE VOZ'),
              style: TextButton.styleFrom(
                backgroundColor: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.3,
                ),
                foregroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.kSpacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
                ),
                textStyle: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScaleLabel extends StatelessWidget {
  final String label;
  const _ScaleLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        fontWeight: FontWeight.w900,
        fontSize: 10,
        letterSpacing: 0.8,
      ),
    );
  }
}

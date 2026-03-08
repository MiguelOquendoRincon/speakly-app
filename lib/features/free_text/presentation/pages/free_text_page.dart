import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voz_clara/features/favorites/presentation/cubit/favorites_cubit.dart';
import '../../../../core/accessibility/semantics_labels.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/speak_button.dart';
import '../../../../shared/widgets/accessible_button.dart';
import '../../../../shared/widgets/voz_clara_app_bar.dart';

/// Pantalla del Compositor de Mensajes.
class FreeTextPage extends StatefulWidget {
  const FreeTextPage({super.key});

  @override
  State<FreeTextPage> createState() => _FreeTextPageState();
}

class _FreeTextPageState extends State<FreeTextPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  bool _isSpeaking = false;
  String? _accessibilityAnnouncement;
  static const int _maxLength = 300;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      final remaining = _maxLength - _controller.text.length;
      if (remaining == 50 || remaining == 20 || remaining == 10) {
        _accessibilityAnnouncement = SemanticsLabels.characterCount(remaining);
        // Limpiar el anuncio brevemente para que el sistema detecte el cambio de texto si ocurre de nuevo
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) setState(() => _accessibilityAnnouncement = null);
        });
      }
    });
  }

  Future<void> _onSpeak() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() => _isSpeaking = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isSpeaking = false);
  }

  void _onClear() {
    _controller.clear();
    _textFieldFocus.requestFocus();
  }

  void _onSave() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<FavoritesCubit>().addFavorite(text, isCustom: true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Frase guardada en favoritos'),
        duration: Duration(seconds: 2),
      ),
    );
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
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const VozClaraAppBar(title: 'ESCRIBIR'),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.kSpacingL),
                child: Column(
                  children: [
                    const SizedBox(height: AppDimensions.kSpacingL),

                    Semantics(
                      header: true,
                      child: Text(
                        '¿Qué quieres decir?',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.kSpacingS),

                    Text(
                      'Escribe tu mensaje y toca Reproducir',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: AppDimensions.kSpacingXL),

                    TextField(
                      controller: _controller,
                      focusNode: _textFieldFocus,
                      maxLines: 5,
                      minLines: 3,
                      maxLength: _maxLength,
                      decoration: InputDecoration(
                        hintText: 'Empieza a escribir...',
                        counterText: '',
                        filled: true,
                        fillColor: isDark
                            ? theme.colorScheme.surface
                            : Colors.white,
                        contentPadding: const EdgeInsets.all(
                          AppDimensions.kSpacingL,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                      style: theme.textTheme.titleLarge,
                    ),

                    const SizedBox(height: AppDimensions.kSpacingS),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Semantics(
                        liveRegion: true,
                        label: _accessibilityAnnouncement,
                        child: Text(
                          '${_controller.text.length} caracteres',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    SpeakButton(
                      onPressed: _onSpeak,
                      isSpeaking: _isSpeaking,
                      isEnabled: hasText,
                    ),

                    const SizedBox(height: AppDimensions.kSpacingM),

                    // BOTÓN GUARDAR FRASE (Conectado a FavoritesCubit)
                    SizedBox(
                      width: double.infinity,
                      child: AccessibleButton(
                        onPressed: _onSave,
                        semanticLabel: 'Guardar frase en favoritos',
                        hint:
                            'Doble toque para agregar esta frase a tus favoritos',
                        isEnabled: hasText,
                        backgroundColor: isDark ? Colors.white10 : Colors.white,
                        foregroundColor: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.kRadiusL,
                        ),
                        side: BorderSide(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.kSpacingM,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.bookmark_add_rounded),
                            const SizedBox(width: AppDimensions.kSpacingS),
                            Text(
                              'GUARDAR FRASE',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.kSpacingM),

                    if (hasText)
                      TextButton.icon(
                        onPressed: _onClear,
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: const Text('BORRAR MENSAJE'),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

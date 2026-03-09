import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voz_clara/app/service_locator.dart';
import 'package:voz_clara/features/phrases/presentation/cubit/tts_cubit.dart';
import 'package:voz_clara/features/free_text/presentation/cubit/free_text_cubit.dart';
import 'package:voz_clara/features/favorites/presentation/cubit/favorites_cubit.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/speak_button.dart';
import '../../../../shared/widgets/accessible_button.dart';
import '../../../../shared/widgets/voz_clara_app_bar.dart';

/// Pantalla del Compositor de Mensajes.
class FreeTextPage extends StatelessWidget {
  const FreeTextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FreeTextCubit>(),
      child: const _FreeTextSelectionView(),
    );
  }
}

class _FreeTextSelectionView extends StatefulWidget {
  const _FreeTextSelectionView();

  @override
  State<_FreeTextSelectionView> createState() => _FreeTextSelectionViewState();
}

class _FreeTextSelectionViewState extends State<_FreeTextSelectionView> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      context.read<FreeTextCubit>().onTextChanged(_controller.text);
    });
  }

  void _onSpeak() {
    context.read<TtsCubit>().speakFreeText(_controller.text);
  }

  void _onClear() {
    _controller.clear();
    context.read<FreeTextCubit>().clearText();
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
    _controller.dispose();
    _textFieldFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                child: BlocBuilder<FreeTextCubit, FreeTextState>(
                  builder: (context, state) {
                    return Column(
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
                          maxLength: state.maxLength,
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
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
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
                            label: state.announcement,
                            child: Text(
                              state.text.isEmpty
                                  ? ''
                                  : '${state.currentLength} caracteres',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        BlocBuilder<TtsCubit, TtsState>(
                          builder: (context, ttsState) {
                            return SizedBox(
                              height: 70,
                              child: SpeakButton(
                                onPressed: _onSpeak,
                                isSpeaking: ttsState.isSpeaking,
                                isEnabled: !state.isEmpty,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppDimensions.kSpacingM),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: AccessibleButton(
                            onPressed: _onSave,
                            semanticLabel: 'Guardar frase en favoritos',
                            hint:
                                'Doble toque para agregar esta frase a tus favoritos',
                            isEnabled: !state.isEmpty,
                            backgroundColor: theme.colorScheme.primaryContainer,
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
                                const Icon(
                                  Icons.bookmark_add_rounded,
                                  size: 25.0,
                                ),
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
                        if (!state.isEmpty)
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: TextButton.icon(
                              onPressed: _onClear,
                              icon: const Icon(
                                CupertinoIcons.delete_solid,
                                size: 22.0,
                              ),
                              label: Text(
                                'BORRAR MENSAJE',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.onError,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.onError,
                                backgroundColor: theme.colorScheme.error,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.kRadiusL,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

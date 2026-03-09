import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voz_clara/app/service_locator.dart';
import 'package:voz_clara/core/constants/app_dimensions.dart';
import 'package:voz_clara/features/phrases/presentation/cubit/phrases_cubit.dart';
import 'package:voz_clara/features/phrases/presentation/cubit/tts_cubit.dart';
import 'package:voz_clara/shared/widgets/phrase_card.dart';
import 'package:voz_clara/shared/widgets/voz_clara_app_bar.dart';

/// Category detail screen — lists all phrases for a given category.
///
/// Receives [categoryId] and [categoryLabel] via constructor
/// (passed from the home grid navigation).
///
/// Cubit wiring:
/// - [PhrasesCubit]: loads phrases + manages favorite state for this category
/// - [TtsCubit]: singleton from GetIt — manages playback state app-wide
///
/// Accessibility: each PhraseCard handles its own semantics.
/// This screen only needs to declare its own header and focus context.
class PhrasesPage extends StatelessWidget {
  const PhrasesPage({
    super.key,
    required this.categoryId,
    required this.categoryLabel,
  });

  final String categoryId;
  final String categoryLabel;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PhrasesCubit>(
          create: (_) => sl<PhrasesCubit>()..loadPhrases(categoryId),
        ),
        // TtsCubit is a singleton — we provide the existing instance,
        // not a new one. BlocProvider.value for pre-existing instances.
        BlocProvider.value(value: sl<TtsCubit>()),
      ],
      child: _PhrasesView(categoryLabel: categoryLabel),
    );
  }
}

class _PhrasesView extends StatelessWidget {
  const _PhrasesView({required this.categoryLabel});
  final String categoryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            VozClaraAppBar(title: categoryLabel),

            Expanded(
              child: BlocBuilder<PhrasesCubit, PhrasesState>(
                builder: (context, phrasesState) {
                  if (phrasesState.status == PhrasesStatus.loading ||
                      phrasesState.status == PhrasesStatus.initial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (phrasesState.status == PhrasesStatus.error) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.kSpacingL),
                        child: Text(
                          phrasesState.errorMessage ??
                              'Error al cargar frases.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    );
                  }

                  if (phrasesState.phrases.isEmpty) {
                    return Center(
                      child: Text(
                        'No hay frases en esta categoría.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }

                  return BlocBuilder<TtsCubit, TtsState>(
                    builder: (context, ttsState) {
                      return ListView.separated(
                        padding: const EdgeInsets.all(AppDimensions.kSpacingM),
                        itemCount: phrasesState.phrases.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppDimensions.kSpacingM),
                        itemBuilder: (context, i) {
                          final phrase = phrasesState.phrases[i];
                          final isSpeaking = ttsState.isActivePhrase(phrase.id);
                          final isFavorite = phrasesState.isFavorite(phrase.id);

                          return PhraseCard(
                            phraseText: phrase.text,
                            subtitle: phrase.subtitle,
                            icon: phrase.icon,
                            isFavorite: isFavorite,
                            isEmergency: phrase.isEmergency,
                            isSpeaking: isSpeaking,
                            onSpeak: () {
                              if (isSpeaking) {
                                context.read<TtsCubit>().stop();
                              } else {
                                context.read<TtsCubit>().speakPhrase(phrase.id);
                              }
                            },
                            onFavoriteToggle: () {
                              context.read<PhrasesCubit>().toggleFavorite(
                                phrase.id,
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voz_clara/features/favorites/presentation/cubit/quick_phrases_cubit.dart';
import 'package:voz_clara/features/phrases/presentation/cubit/tts_cubit.dart';
import 'package:voz_clara/features/phrases/domain/entities/phrase.dart';
import '../../../../shared/widgets/voz_clara_app_bar.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Pantalla de Favoritos e Historial.
///
/// Refactorizada para incluir pestañas que permitan alternar entre
/// las frases guardadas y las recientemente utilizadas.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              const VozClaraAppBar(title: 'ACCESO RÁPIDO'),

              SizedBox(height: AppDimensions.kSpacingL),

              // TAB BAR
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.kSpacingL,
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.kSpacingS),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
                  ),
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.kRadiusM,
                      ),
                    ),
                    labelColor: theme.colorScheme.onPrimary,
                    unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                    labelStyle: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                    tabs: [
                      Semantics(
                        label: 'FAVORITOS',
                        hint: 'Tocar para seleccionar: FAVORITOS',
                        button: true,
                        child: Tab(text: 'FAVORITOS'),
                      ),
                      Semantics(
                        label: 'HISTORIAL',
                        hint: 'Tocar para seleccionar: HISTORIAL',
                        button: true,
                        child: Tab(text: 'HISTORIAL'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.kSpacingM),

              Expanded(
                child: BlocBuilder<QuickPhrasesCubit, QuickPhrasesState>(
                  builder: (context, state) {
                    if (state.status == QuickPhrasesStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return TabBarView(
                      children: [
                        // TAB 1: FAVORITOS
                        _PhraseListView(
                          phrases: state.favorites,
                          emptyTitle: 'Tu lista está vacía',
                          emptyDescription:
                              'Guarda frases desde el Compositor o el explorador para verlas aquí.',
                          emptyIcon: Icons.bookmark_outline_rounded,
                          onRemove: (phrase) => context
                              .read<QuickPhrasesCubit>()
                              .removeFavorite(phrase),
                        ),

                        // TAB 2: HISTORIAL
                        _PhraseListView(
                          phrases: state.recents,
                          emptyTitle: 'Sin historial',
                          emptyDescription:
                              'Las últimas 15 frases que reproduzcas aparecerán en esta lista.',
                          emptyIcon: Icons.history_rounded,
                          onClear: () =>
                              context.read<QuickPhrasesCubit>().clearHistory(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhraseListView extends StatelessWidget {
  final List<Phrase> phrases;
  final String emptyTitle;
  final String emptyDescription;
  final IconData emptyIcon;
  final Function(Phrase)? onRemove;
  final VoidCallback? onClear;

  const _PhraseListView({
    required this.phrases,
    required this.emptyTitle,
    required this.emptyDescription,
    required this.emptyIcon,
    this.onRemove,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (phrases.isEmpty) {
      return _EmptyStateView(
        theme: theme,
        title: emptyTitle,
        description: emptyDescription,
        icon: emptyIcon,
      );
    }

    return Column(
      children: [
        if (onClear != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.kSpacingL,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onClear,
                icon: const Icon(Icons.delete_sweep_rounded, size: 18),
                label: const Text('BORRAR TODO'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  textStyle: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppDimensions.kSpacingL),
            itemCount: phrases.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppDimensions.kSpacingM),
            itemBuilder: (context, index) {
              final phrase = phrases[index];
              return _QuickPhraseCard(
                phrase: phrase,
                onTap: () {
                  if (phrase.id.startsWith('custom_') || phrase.isCustom) {
                    context.read<TtsCubit>().speakFreeText(phrase.text);
                  } else {
                    context.read<TtsCubit>().speakPhrase(phrase.id);
                  }
                },
                onDelete: onRemove != null ? () => onRemove!(phrase) : null,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EmptyStateView extends StatelessWidget {
  final ThemeData theme;
  final String title;
  final String description;
  final IconData icon;

  const _EmptyStateView({
    required this.theme,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.kSpacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.kSpacingXL),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.5,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: AppDimensions.kSpacingXL),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppDimensions.kSpacingS),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickPhraseCard extends StatelessWidget {
  final Phrase phrase;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _QuickPhraseCard({
    required this.phrase,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: 'Frase: ${phrase.text}',
      hint: 'Doble toque para reproducir',
      button: true,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
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
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.kSpacingM),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        phrase.icon,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.kSpacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          phrase.text,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        if (phrase.subtitle != null &&
                            phrase.subtitle!.isNotEmpty)
                          Text(
                            phrase.subtitle!,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      color: theme.colorScheme.onSurfaceVariant,
                      onPressed: onDelete,
                      tooltip: 'Eliminar de favoritos',
                    )
                  else
                    Icon(
                      Icons.chevron_right_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voz_clara/features/favorites/presentation/cubit/favorites_cubit.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Pantalla de Favoritos — muestra las frases guardadas por el usuario.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER - Diseño premium consistente
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.kSpacingM,
                vertical: AppDimensions.kSpacingS,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      'MIS FAVORITOS',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  if (state is FavoritesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is FavoritesLoaded) {
                    final favorites = state.favorites;

                    if (favorites.isEmpty) {
                      return _EmptyFavoritesView(theme: theme);
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(AppDimensions.kSpacingL),
                      itemCount: favorites.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppDimensions.kSpacingM),
                      itemBuilder: (context, index) {
                        final phrase = favorites[index];
                        return _FavoriteItemCard(
                          phrase: phrase.text,
                          onTap: () {
                            // Phase 4: Integración real con TtsService
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Reproduciendo: ${phrase.text}'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          onDelete: () {
                            context.read<FavoritesCubit>().removeFavorite(
                              phrase.id,
                            );
                          },
                        );
                      },
                    );
                  }

                  if (state is FavoritesError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFavoritesView extends StatelessWidget {
  final ThemeData theme;
  const _EmptyFavoritesView({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.kSpacingXL),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_outline_rounded,
              size: 64,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppDimensions.kSpacingXL),
          Text(
            'Tu lista está vacía',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppDimensions.kSpacingS),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.kSpacingXL,
            ),
            child: Text(
              'Guarda tus frases más usadas desde el Compositor para acceder a ellas rápidamente.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteItemCard extends StatelessWidget {
  final String phrase;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _FavoriteItemCard({
    required this.phrase,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      label: 'Frase favorita: $phrase',
      hint: 'Doble toque para reproducir esta frase',
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
                  // Play Icon (Circular matching design)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.volume_up_rounded,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.kSpacingM),
                  Expanded(
                    child: Text(
                      phrase,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.kSpacingS),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded),
                    color: theme.colorScheme.error.withValues(alpha: 0.7),
                    onPressed: onDelete,
                    tooltip: 'Eliminar de favoritos',
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

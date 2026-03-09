import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voz_clara/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:voz_clara/features/phrases/domain/entities/phrase.dart';
import 'package:voz_clara/features/phrases/domain/repositories/phrases_repository.dart';

part 'quick_phrases_state.dart';

/// Loads favorites and recent history for the Quick Phrases screen.
///
/// Called on screen init and also after any favorite toggle in the
/// phrases screen, so the list stays in sync without manual refresh.
class QuickPhrasesCubit extends Cubit<QuickPhrasesState> {
  QuickPhrasesCubit({
    required PhrasesRepository phrasesRepository,
    required FavoritesRepository favoritesRepository,
  }) : _phrasesRepository = phrasesRepository,
       _favoritesRepository = favoritesRepository,
       super(const QuickPhrasesState());

  final PhrasesRepository _phrasesRepository;
  final FavoritesRepository _favoritesRepository;

  Future<void> load() async {
    emit(state.copyWith(status: QuickPhrasesStatus.loading));

    try {
      // 1. Cargar favoritos de ambas fuentes
      final favoriteIds = await _phrasesRepository.getFavoriteIds();
      final staticFavorites = _phrasesRepository.getPhrasesByIds(favoriteIds);
      final customFavorites = await _favoritesRepository.getFavorites();

      final allFavorites = [...customFavorites, ...staticFavorites];
      // Ordenar por fecha si es posible
      allFavorites.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // 2. Cargar historial
      final historyIds = await _phrasesRepository.getHistoryIds();
      final recents = _phrasesRepository.getPhrasesByIds(historyIds);

      emit(
        state.copyWith(
          status: QuickPhrasesStatus.loaded,
          favorites: allFavorites,
          recents: recents,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: QuickPhrasesStatus.loaded));
    }
  }

  Future<void> addFavorite(
    String text, {
    String? categoryId,
    bool isCustom = true,
  }) async {
    try {
      final phrase = Phrase(
        id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
        text: text,
        categoryId: categoryId ?? 'custom',
        createdAt: DateTime.now(),
        isCustom: isCustom,
        icon: Icons.chat_bubble_outline_rounded,
      );
      await _favoritesRepository.addFavorite(phrase);
      await load();
    } catch (e) {
      // Error silencioso por ahora
    }
  }

  Future<void> removeFavorite(Phrase phrase) async {
    if (phrase.isCustom) {
      await _favoritesRepository.removeFavorite(phrase.id);
    } else {
      await _phrasesRepository.removeFavorite(phrase.id);
    }
    await load();
  }

  Future<void> clearHistory() async {
    await _phrasesRepository.clearHistory();
    emit(state.copyWith(recents: []));
  }
}

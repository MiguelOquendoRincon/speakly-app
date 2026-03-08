import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:voz_clara/features/phrases/domain/entities/phrase.dart';
import 'package:voz_clara/features/phrases/domain/repositories/phrases_repository.dart';

part 'phrases_state.dart';

/// Manages phrase list for a single category + favorite state.
///
/// One instance is created per category detail screen.
/// Favorites are loaded from Hive on init so the star state
/// is accurate immediately without a loading flash.
class PhrasesCubit extends Cubit<PhrasesState> {
  PhrasesCubit(this._repository) : super(const PhrasesState());

  final PhrasesRepository _repository;

  Future<void> loadPhrases(String categoryId) async {
    emit(state.copyWith(status: PhrasesStatus.loading));
    try {
      final phrases = _repository.getPhrasesByCategory(categoryId);
      final favoriteIds = await _repository.getFavoriteIds();
      emit(
        state.copyWith(
          status: PhrasesStatus.loaded,
          phrases: phrases,
          favoriteIds: favoriteIds,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PhrasesStatus.error,
          errorMessage: 'No se pudieron cargar las frases.',
        ),
      );
    }
  }

  Future<void> toggleFavorite(String phraseId) async {
    final isFav = state.isFavorite(phraseId);
    // Optimistic update — update UI immediately, then persist.
    // If persistence fails, we revert. This avoids a visible lag
    // on the favorite toggle for users with slow storage.
    final updated = List<String>.from(state.favoriteIds);
    if (isFav) {
      updated.remove(phraseId);
    } else {
      updated.add(phraseId);
    }
    emit(state.copyWith(favoriteIds: updated));

    try {
      if (isFav) {
        await _repository.removeFavorite(phraseId);
      } else {
        await _repository.addFavorite(phraseId);
      }
    } catch (_) {
      // Revert on failure
      emit(state.copyWith(favoriteIds: state.favoriteIds));
    }
  }
}

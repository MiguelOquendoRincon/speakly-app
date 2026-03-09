import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voz_clara/features/phrases/domain/entities/phrase.dart';
import 'package:voz_clara/features/phrases/domain/repositories/phrases_repository.dart';

part 'quick_phrases_state.dart';

/// Loads favorites and recent history for the Quick Phrases screen.
///
/// Called on screen init and also after any favorite toggle in the
/// phrases screen, so the list stays in sync without manual refresh.
class QuickPhrasesCubit extends Cubit<QuickPhrasesState> {
  QuickPhrasesCubit(this._repository) : super(const QuickPhrasesState());

  final PhrasesRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(status: QuickPhrasesStatus.loading));

    final favoriteIds = await _repository.getFavoriteIds();
    final historyIds = await _repository.getHistoryIds();

    final favorites = _repository.getPhrasesByIds(favoriteIds);
    final recents = _repository.getPhrasesByIds(historyIds);

    emit(
      state.copyWith(
        status: QuickPhrasesStatus.loaded,
        favorites: favorites,
        recents: recents,
      ),
    );
  }

  Future<void> clearHistory() async {
    await _repository.clearHistory();
    emit(state.copyWith(recents: []));
  }
}

part of 'quick_phrases_cubit.dart';

/// Lifecycle status for the [QuickPhrasesCubit] data load.
enum QuickPhrasesStatus { initial, loading, loaded }

/// Immutable state for the Quick Phrases / Favorites screen.
final class QuickPhrasesState extends Equatable {
  const QuickPhrasesState({
    this.status = QuickPhrasesStatus.initial,
    this.favorites = const [],
    this.recents = const [],
  });

  final QuickPhrasesStatus status;
  final List<Phrase> favorites;
  final List<Phrase> recents;

  bool get hasFavorites => favorites.isNotEmpty;
  bool get hasRecents => recents.isNotEmpty;

  QuickPhrasesState copyWith({
    QuickPhrasesStatus? status,
    List<Phrase>? favorites,
    List<Phrase>? recents,
  }) => QuickPhrasesState(
    status: status ?? this.status,
    favorites: favorites ?? this.favorites,
    recents: recents ?? this.recents,
  );

  @override
  List<Object?> get props => [status, favorites, recents];
}

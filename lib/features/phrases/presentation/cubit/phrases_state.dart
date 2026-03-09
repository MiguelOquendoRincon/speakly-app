part of 'phrases_cubit.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

enum PhrasesStatus { initial, loading, loaded, error }

final class PhrasesState extends Equatable {
  const PhrasesState({
    this.status = PhrasesStatus.initial,
    this.phrases = const [],
    this.favoriteIds = const [],
    this.errorMessage,
  });

  final PhrasesStatus status;
  final List<Phrase> phrases;
  final List<String> favoriteIds;
  final String? errorMessage;

  bool isFavorite(String phraseId) => favoriteIds.contains(phraseId);

  PhrasesState copyWith({
    PhrasesStatus? status,
    List<Phrase>? phrases,
    List<String>? favoriteIds,
    String? errorMessage,
  }) => PhrasesState(
    status: status ?? this.status,
    phrases: phrases ?? this.phrases,
    favoriteIds: favoriteIds ?? this.favoriteIds,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [status, phrases, favoriteIds, errorMessage];
}

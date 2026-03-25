import 'package:voz_clara/features/phrases/domain/entities/phrase.dart';

/// Contract for managing user-created (custom) favorite phrases.
///
/// Custom favorites are distinct from static phrase favorites tracked by
/// [PhrasesRepository]. Implementations are responsible for persistence.
abstract class FavoritesRepository {
  /// Returns all saved favorite phrases, ordered by most recently added.
  Future<List<Phrase>> getFavorites();

  /// Persists [phrase] as a favorite. Implementations should deduplicate by text.
  Future<void> addFavorite(Phrase phrase);

  /// Removes the favorite identified by [phraseId].
  Future<void> removeFavorite(String phraseId);

  /// Returns `true` if a phrase with the given [text] is already saved.
  Future<bool> isFavorite(String text);
}

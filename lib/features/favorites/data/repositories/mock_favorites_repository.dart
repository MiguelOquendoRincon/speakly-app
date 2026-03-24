import 'package:voz_clara/features/phrases/domain/entities/phrase.dart';
import '../../domain/repositories/favorites_repository.dart';

/// In-memory implementation of [FavoritesRepository].
///
/// Intended for use during development and testing. State is not persisted
/// across app restarts. Duplicates are deduplicated by phrase text (case-insensitive).
class MockFavoritesRepository implements FavoritesRepository {
  final List<Phrase> _favorites = [];

  @override
  Future<void> addFavorite(Phrase phrase) async {
    // Evitar duplicados por texto
    if (!_favorites.any(
      (p) => p.text.toLowerCase() == phrase.text.toLowerCase(),
    )) {
      _favorites.add(phrase);
    }
  }

  @override
  Future<List<Phrase>> getFavorites() async {
    return List.unmodifiable(
      _favorites..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
    );
  }

  @override
  Future<bool> isFavorite(String text) async {
    return _favorites.any((p) => p.text.toLowerCase() == text.toLowerCase());
  }

  @override
  Future<void> removeFavorite(String phraseId) async {
    _favorites.removeWhere((p) => p.id == phraseId);
  }
}

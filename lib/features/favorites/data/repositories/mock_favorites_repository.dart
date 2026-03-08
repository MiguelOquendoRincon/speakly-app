import '../../domain/entities/phrase.dart';
import '../../domain/repositories/favorites_repository.dart';

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

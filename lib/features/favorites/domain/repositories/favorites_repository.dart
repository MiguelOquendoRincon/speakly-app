import 'package:voz_clara/features/phrases/domain/entities/phrase.dart';

abstract class FavoritesRepository {
  Future<List<Phrase>> getFavorites();
  Future<void> addFavorite(Phrase phrase);
  Future<void> removeFavorite(String phraseId);
  Future<bool> isFavorite(String text);
}

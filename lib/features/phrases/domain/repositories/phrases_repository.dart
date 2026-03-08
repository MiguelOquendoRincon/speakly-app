import '../entities/phrase.dart';
import '../../../categories/domain/entities/category.dart';

/// Contract for phrase and category data access.
///
/// The UI and Cubits depend on this abstraction, never on the
/// concrete implementation. This is what makes the data source
/// swappable (static → remote) without touching presentation layer.
abstract class PhrasesRepository {
  List<Category> getCategories();
  List<Phrase> getPhrasesByCategory(String categoryId);
  List<Phrase> getPhrasesByIds(List<String> ids);

  // Favorites — persisted via Hive
  Future<List<String>> getFavoriteIds();
  Future<void> addFavorite(String phraseId);
  Future<void> removeFavorite(String phraseId);

  // History — persisted via Hive, capped at 20 items
  Future<List<String>> getHistoryIds();
  Future<void> addToHistory(String phraseId);
  Future<void> clearHistory();
}

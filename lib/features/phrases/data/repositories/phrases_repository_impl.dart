import 'package:hive_flutter/hive_flutter.dart';
import 'package:voz_clara/features/categories/domain/entities/category.dart';
import 'package:voz_clara/features/phrases/data/datasource/phrases_static_datasource.dart';
import 'package:voz_clara/features/phrases/domain/entities/phrase.dart';
import 'package:voz_clara/features/phrases/domain/repositories/phrases_repository.dart';

/// Concrete implementation of [PhrasesRepository].
///
/// Static phrase data comes from [PhrasesStaticDatasource].
/// Mutable state (favorites, history) is persisted in Hive boxes.
///
/// Box keys are constants to prevent typo-driven bugs.
class PhrasesRepositoryImpl implements PhrasesRepository {
  PhrasesRepositoryImpl({Box? favBox, Box? histBox})
    : _favBoxOverride = favBox,
      _histBoxOverride = histBox;

  static const _favoritesBoxKey = 'favorites';
  static const _historyBoxKey = 'history';
  static const _favoritesKey = 'favorite_ids';
  static const _historyKey = 'history_ids';
  static const _historyMaxLength = 20;

  final Box? _favBoxOverride;
  final Box? _histBoxOverride;

  Box get _favBox => _favBoxOverride ?? Hive.box(_favoritesBoxKey);
  Box get _histBox => _histBoxOverride ?? Hive.box(_historyBoxKey);

  // Called once in main() before runApp.
  static Future<void> openBoxes() async {
    await Hive.openBox(_favoritesBoxKey);
    await Hive.openBox(_historyBoxKey);
  }

  // ---------------------------------------------------------------------------
  // Static data — synchronous, no persistence needed
  // ---------------------------------------------------------------------------

  @override
  List<Category> getCategories() => PhrasesStaticDatasource.getCategories();

  @override
  List<Phrase> getPhrasesByCategory(String categoryId) =>
      PhrasesStaticDatasource.getPhrasesByCategory(categoryId);

  @override
  List<Phrase> getPhrasesByIds(List<String> ids) =>
      PhrasesStaticDatasource.getPhrasesById(ids);

  // ---------------------------------------------------------------------------
  // Favorites — persisted
  // ---------------------------------------------------------------------------

  @override
  Future<List<String>> getFavoriteIds() async {
    final raw = _favBox.get(_favoritesKey);
    if (raw == null) return [];
    return List<String>.from(raw as List);
  }

  @override
  Future<void> addFavorite(String phraseId) async {
    final ids = await getFavoriteIds();
    if (!ids.contains(phraseId)) {
      ids.add(phraseId);
      await _favBox.put(_favoritesKey, ids);
    }
  }

  @override
  Future<void> removeFavorite(String phraseId) async {
    final ids = await getFavoriteIds();
    ids.remove(phraseId);
    await _favBox.put(_favoritesKey, ids);
  }

  // ---------------------------------------------------------------------------
  // History — persisted, capped at [_historyMaxLength]
  // ---------------------------------------------------------------------------

  @override
  Future<List<String>> getHistoryIds() async {
    final raw = _histBox.get(_historyKey);
    if (raw == null) return [];
    return List<String>.from(raw as List);
  }

  @override
  Future<void> addToHistory(String phraseId) async {
    final ids = await getHistoryIds();
    // Remove if already present to re-insert at front (most recent first).
    ids.remove(phraseId);
    ids.insert(0, phraseId);
    // Cap history length.
    final capped = ids.take(_historyMaxLength).toList();
    await _histBox.put(_historyKey, capped);
  }

  @override
  Future<void> clearHistory() async {
    await _histBox.put(_historyKey, <String>[]);
  }
}

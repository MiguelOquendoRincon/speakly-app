import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voz_clara/features/favorites/data/repositories/mock_favorites_repository.dart';
import 'package:voz_clara/features/phrases/domain/entities/phrase.dart';

void main() {
  late MockFavoritesRepository repository;

  setUp(() {
    repository = MockFavoritesRepository();
  });

  group('MockFavoritesRepository', () {
    final tPhrase = Phrase(
      id: '1',
      text: 'Test phrase',
      categoryId: 'custom',
      createdAt: DateTime.now(),
      icon: Icons.star,
    );

    test('getFavorites returns empty list initially', () async {
      final favorites = await repository.getFavorites();
      expect(favorites, isEmpty);
    });

    test('addFavorite adds phrase to list', () async {
      await repository.addFavorite(tPhrase);
      final favorites = await repository.getFavorites();
      expect(favorites.length, 1);
      expect(favorites.first.text, 'Test phrase');
    });

    test(
      'addFavorite prevents duplicate phrases by text (case insensitive)',
      () async {
        final tPhraseDuplicate = Phrase(
          id: '2',
          text: 'TEST PHRASE',
          categoryId: 'custom',
          createdAt: DateTime.now(),
          icon: Icons.star,
        );

        await repository.addFavorite(tPhrase);
        await repository.addFavorite(tPhraseDuplicate);

        final favorites = await repository.getFavorites();
        expect(favorites.length, 1);
      },
    );

    test('isFavorite returns true for existing phrase text', () async {
      await repository.addFavorite(tPhrase);
      final isFav = await repository.isFavorite('test phrase');
      expect(isFav, true);
    });

    test('removeFavorite removes correct phrase by id', () async {
      await repository.addFavorite(tPhrase);
      await repository.removeFavorite(tPhrase.id);
      final favorites = await repository.getFavorites();
      expect(favorites, isEmpty);
    });

    test(
      'getFavorites returns list sorted by createdAt (newest first)',
      () async {
        final tPhrase1 = Phrase(
          id: '1',
          text: 'Oldest',
          categoryId: 'custom',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          icon: Icons.star,
        );
        final tPhrase2 = Phrase(
          id: '2',
          text: 'Newest',
          categoryId: 'custom',
          createdAt: DateTime.now(),
          icon: Icons.star,
        );

        await repository.addFavorite(tPhrase1);
        await repository.addFavorite(tPhrase2);

        final favorites = await repository.getFavorites();
        expect(favorites.first.text, 'Newest');
        expect(favorites.last.text, 'Oldest');
      },
    );
  });
}

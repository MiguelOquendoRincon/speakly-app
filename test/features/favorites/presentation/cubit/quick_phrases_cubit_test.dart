import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:voz_clara/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:voz_clara/features/favorites/presentation/cubit/quick_phrases_cubit.dart';
import 'package:voz_clara/features/phrases/domain/entities/phrase.dart';
import 'package:voz_clara/features/phrases/domain/repositories/phrases_repository.dart';

class MockPhrasesRepository extends Mock implements PhrasesRepository {}

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late QuickPhrasesCubit cubit;
  late MockPhrasesRepository mockPhrasesRepository;
  late MockFavoritesRepository mockFavoritesRepository;

  setUp(() {
    mockPhrasesRepository = MockPhrasesRepository();
    mockFavoritesRepository = MockFavoritesRepository();
    cubit = QuickPhrasesCubit(
      phrasesRepository: mockPhrasesRepository,
      favoritesRepository: mockFavoritesRepository,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('QuickPhrasesCubit', () {
    final tPhrase = Phrase(
      id: '1',
      text: 'Test phrase',
      categoryId: 'cat',
      createdAt: DateTime.now(),
      icon: Icons.star,
    );

    test('initial state has empty lists and initial status', () {
      expect(cubit.state.status, QuickPhrasesStatus.initial);
      expect(cubit.state.favorites, isEmpty);
      expect(cubit.state.recents, isEmpty);
    });

    test('load emits [loading, loaded] with data from repository', () async {
      // Arrange
      when(
        () => mockFavoritesRepository.getFavorites(),
      ).thenAnswer((_) async => []);
      when(
        () => mockPhrasesRepository.getFavoriteIds(),
      ).thenAnswer((_) async => ['1']);
      when(
        () => mockPhrasesRepository.getHistoryIds(),
      ).thenAnswer((_) async => []);
      when(
        () => mockPhrasesRepository.getPhrasesByIds(['1']),
      ).thenReturn([tPhrase]);
      when(() => mockPhrasesRepository.getPhrasesByIds([])).thenReturn([]);

      // Act
      await cubit.load();

      // Assert
      expect(cubit.state.status, QuickPhrasesStatus.loaded);
      expect(cubit.state.favorites, [tPhrase]);
      expect(cubit.state.recents, isEmpty);
      verify(() => mockPhrasesRepository.getFavoriteIds()).called(1);
      verify(() => mockPhrasesRepository.getHistoryIds()).called(1);
    });

    test(
      'clearHistory calls repository and updates state immediately',
      () async {
        // Arrange
        when(
          () => mockPhrasesRepository.clearHistory(),
        ).thenAnswer((_) async => {});

        // Act
        await cubit.clearHistory();

        // Assert
        verify(() => mockPhrasesRepository.clearHistory()).called(1);
        expect(cubit.state.recents, isEmpty);
      },
    );
  });
}

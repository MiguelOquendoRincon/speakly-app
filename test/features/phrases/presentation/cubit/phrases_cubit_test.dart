import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:voz_clara/features/phrases/domain/entities/phrase.dart';
import 'package:voz_clara/features/phrases/domain/repositories/phrases_repository.dart';
import 'package:voz_clara/features/phrases/presentation/cubit/phrases_cubit.dart';
import 'package:flutter/material.dart';

class MockPhrasesRepository extends Mock implements PhrasesRepository {}

void main() {
  late PhrasesCubit cubit;
  late MockPhrasesRepository mockPhrasesRepository;

  setUp(() {
    mockPhrasesRepository = MockPhrasesRepository();
    cubit = PhrasesCubit(mockPhrasesRepository);
  });

  tearDown(() {
    cubit.close();
  });

  final tPhrase = Phrase(
    id: '1',
    categoryId: 'cat1',
    text: 'Hello',
    icon: Icons.abc,
    createdAt: DateTime.now(),
  );

  group('PhrasesCubit', () {
    test('initial state has empty list and initial status', () {
      expect(cubit.state.status, PhrasesStatus.initial);
      expect(cubit.state.phrases, isEmpty);
      expect(cubit.state.favoriteIds, isEmpty);
    });

    test('loadPhrases emits [loading, loaded] with correct data', () async {
      // Arrange
      when(
        () => mockPhrasesRepository.getPhrasesByCategory('cat1'),
      ).thenReturn([tPhrase]);
      when(
        () => mockPhrasesRepository.getFavoriteIds(),
      ).thenAnswer((_) async => ['1']);

      // Act
      final future = cubit.loadPhrases('cat1');

      // Assert
      expect(cubit.state.status, PhrasesStatus.loading);

      await future;

      expect(cubit.state.status, PhrasesStatus.loaded);
      expect(cubit.state.phrases, [tPhrase]);
      expect(cubit.state.favoriteIds, ['1']);
    });

    test('loadPhrases emits [loading, error] when exception occurs', () async {
      // Arrange
      when(
        () => mockPhrasesRepository.getPhrasesByCategory(any()),
      ).thenThrow(Exception());

      // Act
      await cubit.loadPhrases('cat1');

      // Assert
      expect(cubit.state.status, PhrasesStatus.error);
      expect(cubit.state.errorMessage, isNotNull);
    });

    test('toggleFavorite adds favorite and calls repository', () async {
      // Arrange
      when(
        () => mockPhrasesRepository.addFavorite(any()),
      ).thenAnswer((_) async => {});

      // Act
      await cubit.toggleFavorite('1');

      // Assert
      expect(cubit.state.favoriteIds, contains('1'));
      verify(() => mockPhrasesRepository.addFavorite('1')).called(1);
    });

    test('toggleFavorite removes favorite and calls repository', () async {
      // Arrange
      when(
        () => mockPhrasesRepository.getPhrasesByCategory('cat1'),
      ).thenReturn([tPhrase]);
      when(
        () => mockPhrasesRepository.getFavoriteIds(),
      ).thenAnswer((_) async => ['1']);
      await cubit.loadPhrases('cat1');

      when(
        () => mockPhrasesRepository.removeFavorite(any()),
      ).thenAnswer((_) async => {});

      // Act
      await cubit.toggleFavorite('1');

      // Assert
      expect(cubit.state.favoriteIds, isNot(contains('1')));
      verify(() => mockPhrasesRepository.removeFavorite('1')).called(1);
    });

    test('toggleFavorite reverts state on failure', () async {
      // Arrange
      when(
        () => mockPhrasesRepository.addFavorite(any()),
      ).thenThrow(Exception());

      // Act
      await cubit.toggleFavorite('1');

      // Assert - first it emits updated state, then reverts because of failure.
      // Since we check the final state, it should be empty again (reverted).
      expect(cubit.state.favoriteIds, isEmpty);
    });
  });
}

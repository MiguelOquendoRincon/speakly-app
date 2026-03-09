import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:voz_clara/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:voz_clara/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:voz_clara/features/phrases/domain/entities/phrase.dart';
import 'package:voz_clara/features/phrases/domain/repositories/phrases_repository.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

class MockPhrasesRepository extends Mock implements PhrasesRepository {}

void main() {
  late FavoritesCubit cubit;
  late MockFavoritesRepository mockFavoritesRepository;
  late MockPhrasesRepository mockPhrasesRepository;

  setUp(() {
    mockFavoritesRepository = MockFavoritesRepository();
    mockPhrasesRepository = MockPhrasesRepository();
    cubit = FavoritesCubit(
      favoritesRepository: mockFavoritesRepository,
      phrasesRepository: mockPhrasesRepository,
    );
  });

  tearDown(() {
    cubit.close();
  });

  // Fallback for mocktail when using any() with non-primitive types
  setUpAll(() {
    registerFallbackValue(
      Phrase(
        id: 'fake',
        text: 'fake',
        categoryId: 'fake',
        createdAt: DateTime.now(),
        icon: Icons.star,
      ),
    );
  });

  group('FavoritesCubit', () {
    final tPhraseCustom = Phrase(
      id: '1',
      text: 'Custom Text',
      categoryId: 'custom',
      createdAt: DateTime.now(),
      isCustom: true,
      icon: Icons.chat_bubble_outline_rounded,
    );

    final tPhraseStatic = Phrase(
      id: 'static_1',
      text: 'Static Text',
      categoryId: 'basic_needs',
      createdAt: DateTime.now(),
      isCustom: false,
      icon: Icons.water_drop_outlined,
    );

    test('initial state should be FavoritesInitial', () {
      expect(cubit.state, equals(FavoritesInitial()));
    });

    test('loadFavorites emits [Loading, Loaded] and combines lists', () async {
      // Arrange
      when(
        () => mockFavoritesRepository.getFavorites(),
      ).thenAnswer((_) async => [tPhraseCustom]);
      when(
        () => mockPhrasesRepository.getFavoriteIds(),
      ).thenAnswer((_) async => [tPhraseStatic.id]);
      when(
        () => mockPhrasesRepository.getPhrasesByIds([tPhraseStatic.id]),
      ).thenReturn([tPhraseStatic]);

      // Act
      final future = cubit.loadFavorites();

      // Assert - Check that it starts loading
      expect(cubit.state, isA<FavoritesLoading>());

      await future;

      expect(cubit.state, isA<FavoritesLoaded>());
      final state = cubit.state as FavoritesLoaded;
      expect(state.favorites.length, 2);
      expect(state.favorites, contains(tPhraseCustom));
      expect(state.favorites, contains(tPhraseStatic));
    });

    test(
      'loadFavorites emits FavoritesError when an exception occurs',
      () async {
        // Arrange
        when(
          () => mockFavoritesRepository.getFavorites(),
        ).thenThrow(Exception('database error'));

        // Act
        await cubit.loadFavorites();

        // Assert
        expect(cubit.state, isA<FavoritesError>());
        expect(
          (cubit.state as FavoritesError).message,
          contains('Error al cargar favoritos'),
        );
      },
    );

    test('addFavorite calls repository and reloads', () async {
      // Arrange
      when(
        () => mockFavoritesRepository.addFavorite(any()),
      ).thenAnswer((_) async {});
      when(
        () => mockFavoritesRepository.getFavorites(),
      ).thenAnswer((_) async => [tPhraseCustom]);
      when(
        () => mockPhrasesRepository.getFavoriteIds(),
      ).thenAnswer((_) async => []);
      when(() => mockPhrasesRepository.getPhrasesByIds(any())).thenReturn([]);

      // Act
      await cubit.addFavorite('Custom Text');

      // Assert
      verify(() => mockFavoritesRepository.addFavorite(any())).called(1);
      // verify loadFavorites was called (it emits FavoritesLoaded)
      expect(cubit.state, isA<FavoritesLoaded>());
    });

    test('removeFavorite removes a custom phrase correctly', () async {
      // Arrange
      when(
        () => mockFavoritesRepository.removeFavorite(any()),
      ).thenAnswer((_) async {});
      when(
        () => mockFavoritesRepository.getFavorites(),
      ).thenAnswer((_) async => []);
      when(
        () => mockPhrasesRepository.getFavoriteIds(),
      ).thenAnswer((_) async => []);
      when(() => mockPhrasesRepository.getPhrasesByIds(any())).thenReturn([]);

      // Act
      await cubit.removeFavorite(tPhraseCustom);

      // Assert
      verify(
        () => mockFavoritesRepository.removeFavorite(tPhraseCustom.id),
      ).called(1);
      verifyNever(() => mockPhrasesRepository.removeFavorite(any()));
    });

    test('removeFavorite removes a static phrase correctly', () async {
      // Arrange
      when(
        () => mockPhrasesRepository.removeFavorite(any()),
      ).thenAnswer((_) async {});
      when(
        () => mockFavoritesRepository.getFavorites(),
      ).thenAnswer((_) async => []);
      when(
        () => mockPhrasesRepository.getFavoriteIds(),
      ).thenAnswer((_) async => []);
      when(() => mockPhrasesRepository.getPhrasesByIds(any())).thenReturn([]);

      // Act
      await cubit.removeFavorite(tPhraseStatic);

      // Assert
      verify(
        () => mockPhrasesRepository.removeFavorite(tPhraseStatic.id),
      ).called(1);
      verifyNever(() => mockFavoritesRepository.removeFavorite(any()));
    });
  });
}

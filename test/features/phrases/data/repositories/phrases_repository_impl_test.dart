import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:voz_clara/features/phrases/data/repositories/phrases_repository_impl.dart';

class MockBox extends Mock implements Box {}

void main() {
  late PhrasesRepositoryImpl repository;
  late MockBox mockFavBox;
  late MockBox mockHistBox;

  setUp(() {
    mockFavBox = MockBox();
    mockHistBox = MockBox();
    repository = PhrasesRepositoryImpl(
      favBox: mockFavBox,
      histBox: mockHistBox,
    );
  });

  group('PhrasesRepositoryImpl', () {
    group('Favorites', () {
      test('getFavoriteIds returns empty list when box is empty', () async {
        when(() => mockFavBox.get('favorite_ids')).thenReturn(null);
        final result = await repository.getFavoriteIds();
        expect(result, isEmpty);
      });

      test('getFavoriteIds returns list from box', () async {
        when(() => mockFavBox.get('favorite_ids')).thenReturn(['1', '2']);
        final result = await repository.getFavoriteIds();
        expect(result, ['1', '2']);
      });

      test('addFavorite adds id to box if not present', () async {
        when(() => mockFavBox.get('favorite_ids')).thenReturn(['1']);
        when(
          () => mockFavBox.put('favorite_ids', any()),
        ).thenAnswer((_) async => {});

        await repository.addFavorite('2');

        verify(() => mockFavBox.put('favorite_ids', ['1', '2'])).called(1);
      });

      test('addFavorite does not add duplicate id', () async {
        when(() => mockFavBox.get('favorite_ids')).thenReturn(['1', '2']);

        await repository.addFavorite('1');

        verifyNever(() => mockFavBox.put('favorite_ids', any()));
      });

      test('removeFavorite removes id from box', () async {
        when(() => mockFavBox.get('favorite_ids')).thenReturn(['1', '2']);
        when(
          () => mockFavBox.put('favorite_ids', any()),
        ).thenAnswer((_) async => {});

        await repository.removeFavorite('1');

        verify(() => mockFavBox.put('favorite_ids', ['2'])).called(1);
      });
    });

    group('History', () {
      test('getHistoryIds returns ids from box', () async {
        when(() => mockHistBox.get('history_ids')).thenReturn(['p1', 'p2']);
        final result = await repository.getHistoryIds();
        expect(result, ['p1', 'p2']);
      });

      test('addToHistory moves phrase to front and caps length', () async {
        final initialHistory = List.generate(15, (i) => 'old_$i');
        when(() => mockHistBox.get('history_ids')).thenReturn(initialHistory);
        when(
          () => mockHistBox.put('history_ids', any()),
        ).thenAnswer((_) async => {});

        await repository.addToHistory('new_phrase');

        // Should have 'new_phrase' at index 0, and total length 20
        final verification =
            verify(
                  () => mockHistBox.put('history_ids', captureAny()),
                ).captured.first
                as List<String>;
        expect(verification.first, 'new_phrase');
        expect(verification.length, 15);
        expect(verification.contains('old_19'), isFalse); // Last one dropped
      });

      test('clearHistory sets empty list in box', () async {
        when(
          () => mockHistBox.put('history_ids', any()),
        ).thenAnswer((_) async => {});
        await repository.clearHistory();
        verify(() => mockHistBox.put('history_ids', <String>[])).called(1);
      });
    });
  });
}

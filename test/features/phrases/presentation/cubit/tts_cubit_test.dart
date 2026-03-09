import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:voz_clara/features/phrases/domain/entities/phrase.dart';
import 'package:voz_clara/features/phrases/domain/repositories/phrases_repository.dart';
import 'package:voz_clara/features/phrases/presentation/cubit/tts_cubit.dart';
import 'package:voz_clara/shared/services/tts_service.dart';
import 'package:flutter/material.dart';

class MockTtsService extends Mock implements TtsService {}

class MockPhrasesRepository extends Mock implements PhrasesRepository {}

void main() {
  late TtsCubit cubit;
  late MockTtsService mockTtsService;
  late MockPhrasesRepository mockPhrasesRepository;

  setUp(() {
    mockTtsService = MockTtsService();
    mockPhrasesRepository = MockPhrasesRepository();
    cubit = TtsCubit(mockTtsService, mockPhrasesRepository);
  });

  tearDown(() {
    cubit.close();
  });

  final tPhrase = Phrase(
    id: '1',
    categoryId: 'cat1',
    text: 'Hello world',
    icon: Icons.abc,
    createdAt: DateTime.now(),
  );

  group('TtsCubit', () {
    test('initial state has no active phrase and idle status', () {
      expect(cubit.state.status, TtsStatus.idle);
      expect(cubit.state.activePhraseId, isNull);
      expect(cubit.state.isSpeaking, false);
    });

    test('speakPhrase calls TTS service and adds to history', () async {
      // Arrange
      when(
        () => mockPhrasesRepository.getPhrasesByIds(['1']),
      ).thenReturn([tPhrase]);
      when(
        () => mockPhrasesRepository.addToHistory(any()),
      ).thenAnswer((_) async => {});
      when(
        () => mockTtsService.speak(
          any(),
          onComplete: any(named: 'onComplete'),
          onError: any(named: 'onError'),
        ),
      ).thenAnswer((invocation) async {
        final onComplete =
            invocation.namedArguments[#onComplete] as VoidCallback?;
        onComplete?.call();
      });
      when(() => mockTtsService.stop()).thenAnswer((_) async => {});

      // Act
      await cubit.speakPhrase('1');

      // Assert
      expect(
        cubit.state.status,
        TtsStatus.idle,
      ); // returns to idle after onComplete
      verify(() => mockPhrasesRepository.getPhrasesByIds(['1'])).called(1);
      verify(() => mockPhrasesRepository.addToHistory('1')).called(1);
      verify(
        () => mockTtsService.speak(
          'Hello world',
          onComplete: any(named: 'onComplete'),
          onError: any(named: 'onError'),
        ),
      ).called(1);
    });

    test('speakFreeText calls TTS service', () async {
      // Arrange
      when(
        () => mockTtsService.speak(
          any(),
          onComplete: any(named: 'onComplete'),
          onError: any(named: 'onError'),
        ),
      ).thenAnswer((invocation) async {
        final onComplete =
            invocation.namedArguments[#onComplete] as VoidCallback?;
        onComplete?.call();
      });
      when(() => mockTtsService.stop()).thenAnswer((_) async => {});

      // Act
      await cubit.speakFreeText('Test text');

      // Assert
      verify(
        () => mockTtsService.speak(
          'Test text',
          onComplete: any(named: 'onComplete'),
          onError: any(named: 'onError'),
        ),
      ).called(1);
    });

    test('stop calls TTS service stop', () async {
      // Arrange
      when(() => mockTtsService.stop()).thenAnswer((_) async => {});

      // Act
      await cubit.stop();

      // Assert
      verify(() => mockTtsService.stop()).called(1);
      expect(cubit.state.status, TtsStatus.idle);
    });

    test('emits error status when TTS service fails', () async {
      // Arrange
      when(
        () => mockPhrasesRepository.getPhrasesByIds(['1']),
      ).thenReturn([tPhrase]);
      when(
        () => mockPhrasesRepository.addToHistory(any()),
      ).thenAnswer((_) async => {});
      when(
        () => mockTtsService.speak(
          any(),
          onComplete: any(named: 'onComplete'),
          onError: any(named: 'onError'),
        ),
      ).thenAnswer((invocation) async {
        final onError =
            invocation.namedArguments[#onError] as Function(String)?;
        onError?.call('error');
      });
      when(() => mockTtsService.stop()).thenAnswer((_) async => {});

      // Act
      await cubit.speakPhrase('1');

      // Assert
      expect(cubit.state.status, TtsStatus.error);
    });
  });
}

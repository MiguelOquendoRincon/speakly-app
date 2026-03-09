import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:voz_clara/shared/services/tts_service.dart';

class MockFlutterTts extends Mock implements FlutterTts {}

void main() {
  setUpAll(() {
    registerFallbackValue(IosTextToSpeechAudioCategory.playback);
    registerFallbackValue(IosTextToSpeechAudioMode.defaultMode);
  });

  late MockFlutterTts mockTts;
  late TtsService ttsService;

  setUp(() {
    mockTts = MockFlutterTts();

    // Stub common initialization methods to avoid unhandled calls.
    when(() => mockTts.setLanguage(any())).thenAnswer((_) async => 1);
    when(() => mockTts.setSpeechRate(any())).thenAnswer((_) async => 1);
    when(() => mockTts.setVolume(any())).thenAnswer((_) async => 1);
    when(() => mockTts.setPitch(any())).thenAnswer((_) async => 1);
    when(() => mockTts.setSharedInstance(any())).thenAnswer((_) async => 1);
    when(
      () => mockTts.setIosAudioCategory(any(), any(), any()),
    ).thenAnswer((_) async => 1);
    when(() => mockTts.stop()).thenAnswer((_) async => 1);
    when(() => mockTts.speak(any())).thenAnswer((_) async => 1);

    ttsService = TtsService(tts: mockTts);
  });

  group('TtsService', () {
    test('Initialization should set correct defaults', () async {
      // Due to constructor starting async _init(), we wait a bit
      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => mockTts.setLanguage('es-ES')).called(1);
      verify(() => mockTts.setSpeechRate(0.5)).called(1);
      verify(() => mockTts.setVolume(1.0)).called(1);
      verify(() => mockTts.setPitch(1.0)).called(1);
    });

    test(
      'speak() should call tts.speak after stopping current speech',
      () async {
        await Future.delayed(const Duration(milliseconds: 100)); // wait init
        const text = 'Hola mundo';

        await ttsService.speak(text);

        verify(() => mockTts.stop()).called(1);
        verify(() => mockTts.speak(text)).called(1);
      },
    );

    test('speak() should call onComplete if text is empty', () async {
      await Future.delayed(const Duration(milliseconds: 100)); // wait init
      bool completed = false;

      await ttsService.speak('', onComplete: () => completed = true);

      expect(completed, isTrue);
      // Ensure it didn't call stop/speak if text is empty
      verifyNever(() => mockTts.speak(any()));
    });

    test('stop() should call tts.stop', () async {
      await Future.delayed(const Duration(milliseconds: 100)); // wait init
      await ttsService.stop();
      verify(() => mockTts.stop()).called(1);
    });

    test('setSpeechRate() should clamp and update tts rate', () async {
      await Future.delayed(const Duration(milliseconds: 100)); // wait init

      await ttsService.setSpeechRate(1.5); // Should clamp to 1.0
      verify(() => mockTts.setSpeechRate(1.0)).called(1);

      await ttsService.setSpeechRate(0.01); // Should clamp to 0.1
      verify(() => mockTts.setSpeechRate(0.1)).called(1);
    });
  });
}

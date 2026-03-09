import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:voz_clara/features/settings/presentation/cubit/settings_cubit_cubit.dart';
import 'package:voz_clara/shared/services/tts_service.dart';

class MockTtsService extends Mock implements TtsService {}

void main() {
  late SettingsCubit cubit;
  late MockTtsService mockTtsService;

  setUp(() {
    mockTtsService = MockTtsService();
    cubit = SettingsCubit(mockTtsService);
  });

  tearDown(() {
    cubit.close();
  });

  group('SettingsCubit', () {
    test('initial state has default values', () {
      expect(cubit.state.isHighContrast, false);
      expect(cubit.state.reduceMotion, false);
      expect(cubit.state.useLargeText, false);
      expect(cubit.state.ttsSpeechRate, 0.5);
    });

    test('toggleHighContrast toggles the value', () {
      cubit.toggleHighContrast();
      expect(cubit.state.isHighContrast, true);

      cubit.toggleHighContrast();
      expect(cubit.state.isHighContrast, false);
    });

    test('toggleReduceMotion toggles the value', () {
      cubit.toggleReduceMotion();
      expect(cubit.state.reduceMotion, true);

      cubit.toggleReduceMotion();
      expect(cubit.state.reduceMotion, false);
    });

    test('toggleLargeText toggles the value', () {
      cubit.toggleLargeText();
      expect(cubit.state.useLargeText, true);

      cubit.toggleLargeText();
      expect(cubit.state.useLargeText, false);
    });

    test('setSpeechRate updates state and calls TtsService', () async {
      // Arrange
      when(
        () => mockTtsService.setSpeechRate(any()),
      ).thenAnswer((_) async => {});

      // Act
      await cubit.setSpeechRate(0.8);

      // Assert
      expect(cubit.state.ttsSpeechRate, 0.8);
      verify(() => mockTtsService.setSpeechRate(0.8)).called(1);
    });

    test('setSpeechRate clamps the rate between 0.1 and 1.0', () async {
      // Arrange
      when(
        () => mockTtsService.setSpeechRate(any()),
      ).thenAnswer((_) async => {});

      // Act & Assert for lower bound
      await cubit.setSpeechRate(0.0);
      expect(cubit.state.ttsSpeechRate, 0.1);
      verify(() => mockTtsService.setSpeechRate(0.1)).called(1);

      // Act & Assert for upper bound
      await cubit.setSpeechRate(1.5);
      expect(cubit.state.ttsSpeechRate, 1.0);
      verify(() => mockTtsService.setSpeechRate(1.0)).called(1);
    });
  });
}

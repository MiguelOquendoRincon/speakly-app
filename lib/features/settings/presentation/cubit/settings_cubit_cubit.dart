import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../shared/services/tts_service.dart';

part 'settings_cubit_state.dart';

/// Manages user accessibility preferences (high contrast, large text,
/// reduce motion, TTS speech rate).
///
/// Settings are in-memory only; persistence across launches is a future concern.
/// [TtsService] is notified immediately when the speech rate changes.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._ttsService) : super(const SettingsState());

  final TtsService _ttsService;

  /// Toggles the high-contrast theme on or off.
  void toggleHighContrast() =>
      emit(state.copyWith(isHighContrast: !state.isHighContrast));

  /// Toggles reduced-motion mode on or off.
  void toggleReduceMotion() =>
      emit(state.copyWith(reduceMotion: !state.reduceMotion));

  /// Toggles the global large-text scale factor on or off.
  void toggleLargeText() =>
      emit(state.copyWith(useLargeText: !state.useLargeText));

  /// Sets the TTS speech rate, clamped to [0.1, 1.0], and applies it to [TtsService].
  Future<void> setSpeechRate(double rate) async {
    final clampedRate = rate.clamp(0.1, 1.0);
    emit(state.copyWith(ttsSpeechRate: clampedRate));
    await _ttsService.setSpeechRate(clampedRate);
  }
}

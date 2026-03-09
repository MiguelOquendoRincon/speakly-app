import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../shared/services/tts_service.dart';

part 'settings_cubit_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._ttsService) : super(const SettingsState());

  final TtsService _ttsService;

  void toggleHighContrast() =>
      emit(state.copyWith(isHighContrast: !state.isHighContrast));

  void toggleReduceMotion() =>
      emit(state.copyWith(reduceMotion: !state.reduceMotion));

  Future<void> setSpeechRate(double rate) async {
    final clampedRate = rate.clamp(0.1, 1.0);
    emit(state.copyWith(ttsSpeechRate: clampedRate));
    await _ttsService.setSpeechRate(clampedRate);
  }
}

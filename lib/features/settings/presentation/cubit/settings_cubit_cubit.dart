import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'settings_cubit_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void toggleHighContrast() =>
      emit(state.copyWith(isHighContrast: !state.isHighContrast));

  void toggleReduceMotion() =>
      emit(state.copyWith(reduceMotion: !state.reduceMotion));

  void setSpeechRate(double rate) =>
      emit(state.copyWith(ttsSpeechRate: rate.clamp(0.1, 1.0)));
}

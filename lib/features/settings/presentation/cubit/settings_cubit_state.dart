part of 'settings_cubit_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.isHighContrast = false,
    this.reduceMotion = false,
    this.ttsSpeechRate = 0.5, // flutter_tts default: 0 (slow) to 1 (fast)
  });

  final bool isHighContrast;
  final bool reduceMotion;
  final double ttsSpeechRate;

  SettingsState copyWith({
    bool? isHighContrast,
    bool? reduceMotion,
    double? ttsSpeechRate,
  }) => SettingsState(
    isHighContrast: isHighContrast ?? this.isHighContrast,
    reduceMotion: reduceMotion ?? this.reduceMotion,
    ttsSpeechRate: ttsSpeechRate ?? this.ttsSpeechRate,
  );

  @override
  List<Object> get props => [isHighContrast, reduceMotion, ttsSpeechRate];
}

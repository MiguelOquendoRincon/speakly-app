import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Wrapper around flutter_tts.
///
/// Responsibilities:
/// - Initialize engine with correct locale
/// - Expose speak/stop with completion callbacks
/// - Apply speech rate from SettingsCubit
/// - Handle platform differences (Android audio focus, iOS AVSession)
///
/// Accessibility — audio focus on Android:
/// flutter_tts requests AudioFocus automatically on Android when speak()
/// is called. This causes media apps and TalkBack to duck (lower volume)
/// or pause while TTS is active, then resume when TTS completes.
/// We do not need to manage AudioFocus manually — flutter_tts handles it.
/// What we DO manage is the timing: see TtsCubit._speak() for the
/// SemanticsService.announce() delay pattern.
class TtsService {
  TtsService() {
    _init();
  }

  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  Future<void> _init() async {
    // Locale: es-ES for Spain Spanish.
    // If unavailable on device, flutter_tts falls back to default locale.
    // Phase 5 note: test on device to confirm correct Spanish pronunciation.
    await _tts.setLanguage('es-ES');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    // Android: request AudioFocus so TTS is not silenced by other audio.
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _tts.setSharedInstance(true);
    }

    // iOS: configure AVAudioSession to allow TTS to play over silent mode.
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _tts.setSharedInstance(true);
      await _tts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        ],
        IosTextToSpeechAudioMode.defaultMode,
      );
    }

    _isInitialized = true;
  }

  /// Speaks [text]. Calls [onComplete] when finished, [onError] on failure.
  ///
  /// Always stops any ongoing speech before starting new.
  Future<void> speak(
    String text, {
    VoidCallback? onComplete,
    ValueChanged<String>? onError,
  }) async {
    if (!_isInitialized || text.trim().isEmpty) {
      onComplete?.call();
      return;
    }

    await stop();

    _tts.setCompletionHandler(() => onComplete?.call());
    _tts.setErrorHandler((msg) => onError?.call(msg.toString()));

    await _tts.speak(text);
  }

  /// Stops ongoing speech immediately.
  Future<void> stop() async {
    await _tts.stop();
  }

  /// Updates speech rate. Called when SettingsCubit changes.
  Future<void> setSpeechRate(double rate) async {
    await _tts.setSpeechRate(rate.clamp(0.1, 1.0));
  }

  /// Diagnostic helper — logs available engines and languages.
  /// Use during development to verify TTS engine is installed.
  Future<void> diagnose() async {
    final engines = await _tts.getEngines;
    final languages = await _tts.getLanguages;
    debugPrint('TTS engines: $engines');
    debugPrint('TTS languages: $languages');
  }

  Future<void> dispose() async {
    await _tts.stop();
  }
}

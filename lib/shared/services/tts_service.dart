import 'package:flutter_tts/flutter_tts.dart';

/// Wrapper around flutter_tts providing a clean interface.
///
/// Accessibility note: This service is responsible for coordinating
/// TTS playback in a way that does not conflict with screen reader
/// audio. See Phase 4 for full TalkBack/VoiceOver coexistence handling.
class TtsService {
  TtsService() {
    _init();
  }

  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  Future<void> _init() async {
    await _tts.setLanguage('es-ES');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _isInitialized = true;
  }

  /// Speaks [text] aloud. Stops any ongoing speech first.
  Future<void> speak(String text) async {
    if (!_isInitialized || text.trim().isEmpty) return;
    await stop();
    await _tts.speak(text);
  }

  /// Stops ongoing speech immediately.
  Future<void> stop() async {
    await _tts.stop();
  }

  /// Updates the speech rate. Called when settings change.
  Future<void> setSpeechRate(double rate) async {
    await _tts.setSpeechRate(rate);
  }

  /// Releases TTS resources. Call from app lifecycle if needed.
  Future<void> dispose() async {
    await _tts.stop();
  }
}

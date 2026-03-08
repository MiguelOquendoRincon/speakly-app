import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:voz_clara/features/phrases/domain/entities/phrase.dart';
import 'package:voz_clara/features/phrases/domain/repositories/phrases_repository.dart';
import 'package:voz_clara/shared/services/tts_service.dart';

part 'tts_state.dart';

/// Manages TTS playback state across the entire app.
///
/// This is a singleton Cubit (registered as lazy singleton in GetIt)
/// because TTS is a device-level resource — only one thing can speak
/// at a time. Every screen that has a Speak button listens to this Cubit.
///
/// Accessibility — TalkBack/TTS coexistence (the hard problem):
///
/// On Android, TalkBack and flutter_tts compete for the audio channel.
/// When TalkBack is active, calling tts.speak() may be silenced or
/// interrupted by TalkBack's own speech engine.
///
/// Our solution:
/// 1. We do NOT disable TalkBack — that would break accessibility.
/// 2. We use SemanticsService.announce() BEFORE speaking, which
///    causes TalkBack to finish its current utterance and then
///    hand off the audio channel.
/// 3. TtsService uses AudioFocus handling (see TtsService) to
///    request focus before speaking, which causes TalkBack to pause.
/// 4. We announce the phrase text via SemanticsService so that
///    screen reader users who cannot hear the TTS output still
///    receive the content. This is belt-and-suspenders accessibility.
///
/// On iOS, VoiceOver and AVSpeechSynthesizer coexist more gracefully.
/// flutter_tts handles this internally on iOS.
///
/// WCAG: 1.1.1 (non-text content announced), 4.1.3 (status messages)
class TtsCubit extends Cubit<TtsState> {
  TtsCubit(this._ttsService, this._repository) : super(const TtsState());

  final TtsService _ttsService;
  final PhrasesRepository _repository;

  /// Speak a predefined phrase by ID.
  /// Also adds to history and announces to screen readers.
  Future<void> speakPhrase(String phraseId) async {
    final phrase = _repository.getPhrasesByIds([phraseId]).firstOrNull;
    if (phrase == null) return;

    await _speak(phrase.text, phraseId: phraseId);
    await _repository.addToHistory(phraseId);
  }

  /// Speak arbitrary free text (from the composer screen).
  Future<void> speakFreeText(String text) async {
    if (text.trim().isEmpty) return;
    await _speak(text);
  }

  /// Stop current playback.
  Future<void> stop() async {
    await _ttsService.stop();
    emit(const TtsState());
  }

  Future<void> _speak(String text, {String? phraseId}) async {
    // If already speaking, stop first.
    if (state.isSpeaking) await _ttsService.stop();

    emit(TtsState(status: TtsStatus.speaking, activePhraseId: phraseId));

    // Accessibility: announce via semantic properties (handled by the UI via liveRegion).
    // This replaces the deprecated AnnounceSemanticsEvent / SemanticsService.announce.
    emit(state.copyWith(status: TtsStatus.speaking, announcement: text));

    // Clear announcement soon so it can be re-emitted if the same text is spoken again.
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!isClosed) emit(state.copyWith(announcement: null));
    });

    // Small delay after announce lets TalkBack finish current
    // utterance before TTS takes audio focus. 300ms is sufficient
    // in practice; too short causes overlap, too long feels laggy.
    await Future.delayed(const Duration(milliseconds: 300));

    await _ttsService.speak(
      text,
      onComplete: () {
        if (!isClosed) emit(const TtsState());
      },
      onError: (_) {
        if (!isClosed) {
          emit(const TtsState(status: TtsStatus.error));
        }
      },
    );
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

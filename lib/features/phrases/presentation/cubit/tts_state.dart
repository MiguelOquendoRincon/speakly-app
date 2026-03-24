part of 'tts_cubit.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

/// Playback lifecycle for the TTS engine.
enum TtsStatus { idle, speaking, error }

/// Immutable state for [TtsCubit].
///
/// [activePhraseId] identifies which phrase is currently being spoken, enabling
/// per-card visual feedback. [announcement] is a transient string broadcast to
/// screen-reader live regions and cleared shortly after emission.
final class TtsState extends Equatable {
  const TtsState({
    this.status = TtsStatus.idle,
    this.activePhraseId,
    this.announcement,
  });

  final TtsStatus status;

  /// The ID of the phrase currently being spoken.
  /// Null when idle. Used by PhraseCard to show active visual state.
  final String? activePhraseId;

  /// Status announcement for screen readers (using liveRegion instead of Announce event).
  final String? announcement;

  bool get isSpeaking => status == TtsStatus.speaking;
  bool isActivePhrase(String id) => activePhraseId == id;

  TtsState copyWith({
    TtsStatus? status,
    String? activePhraseId,
    String? announcement,
  }) => TtsState(
    status: status ?? this.status,
    activePhraseId: status == TtsStatus.idle
        ? null
        : (activePhraseId ?? this.activePhraseId),
    announcement: announcement ?? this.announcement,
  );

  @override
  List<Object?> get props => [status, activePhraseId, announcement];
}

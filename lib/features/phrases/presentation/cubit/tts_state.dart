part of 'tts_cubit.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

enum TtsStatus { idle, speaking, error }

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

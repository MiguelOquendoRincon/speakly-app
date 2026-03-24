import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/accessibility/semantics_labels.dart';

part 'free_text_state.dart';

/// Manages text composition state for the free-text screen.
///
/// Tracks the current message and emits accessibility announcements
/// at character-count thresholds (50, 20, 10 remaining) via [FreeTextState.announcement].
class FreeTextCubit extends Cubit<FreeTextState> {
  FreeTextCubit() : super(const FreeTextState());

  /// Updates the composed text and triggers an accessibility announcement
  /// when character count crosses defined thresholds.
  void onTextChanged(String text) {
    String? announcement;
    final remaining = state.maxLength - text.length;

    // Accessibility announcements at specific thresholds
    if (remaining == 50 || remaining == 20 || remaining == 10) {
      announcement = SemanticsLabels.characterCount(remaining);
    }

    emit(state.copyWith(text: text, announcement: announcement));

    // Clear announcement after a brief delay so it can be re-emitted if needed
    if (announcement != null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!isClosed) {
          emit(state.copyWith(text: state.text, announcement: null));
        }
      });
    }
  }

  /// Clears the composed message and resets any pending announcement.
  void clearText() {
    emit(state.copyWith(text: '', announcement: null));
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/accessibility/semantics_labels.dart';

part 'free_text_state.dart';

class FreeTextCubit extends Cubit<FreeTextState> {
  FreeTextCubit() : super(const FreeTextState());

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

  void clearText() {
    emit(state.copyWith(text: '', announcement: null));
  }
}

part of 'free_text_cubit.dart';

class FreeTextState extends Equatable {
  const FreeTextState({
    this.text = '',
    this.announcement,
    this.maxLength = 300,
  });

  final String text;
  final String? announcement;
  final int maxLength;

  bool get isEmpty => text.trim().isEmpty;
  int get currentLength => text.length;

  FreeTextState copyWith({String? text, String? announcement}) {
    return FreeTextState(
      text: text ?? this.text,
      announcement: announcement,
      maxLength: maxLength,
    );
  }

  @override
  List<Object?> get props => [text, announcement, maxLength];
}

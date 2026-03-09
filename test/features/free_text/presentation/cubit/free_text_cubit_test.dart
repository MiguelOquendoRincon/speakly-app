import 'package:flutter_test/flutter_test.dart';
import 'package:voz_clara/features/free_text/presentation/cubit/free_text_cubit.dart';

void main() {
  late FreeTextCubit cubit;

  setUp(() {
    cubit = FreeTextCubit();
  });

  tearDown(() {
    cubit.close();
  });

  group('FreeTextCubit', () {
    test('initial state has empty text and maxLength 300', () {
      expect(cubit.state.text, '');
      expect(cubit.state.maxLength, 300);
      expect(cubit.state.isEmpty, true);
    });

    test('onTextChanged updates text correctly', () {
      cubit.onTextChanged('Hello world');
      expect(cubit.state.text, 'Hello world');
      expect(cubit.state.isEmpty, false);
      expect(cubit.state.currentLength, 11);
    });

    test('clearText resets text to empty', () {
      cubit.onTextChanged('Some text');
      cubit.clearText();
      expect(cubit.state.text, '');
      expect(cubit.state.isEmpty, true);
    });

    test('announces remaining characters at 50 threshold', () async {
      final text50Remaining = 'a' * 250;
      cubit.onTextChanged(text50Remaining);

      expect(cubit.state.announcement, contains('50'));

      // Should clear after delay
      await Future.delayed(const Duration(milliseconds: 150));
      expect(cubit.state.announcement, isNull);
    });

    test('announces remaining characters at 20 threshold', () {
      final text20Remaining = 'a' * 280;
      cubit.onTextChanged(text20Remaining);
      expect(cubit.state.announcement, contains('20'));
    });

    test('announces remaining characters at 10 threshold', () {
      final text10Remaining = 'a' * 290;
      cubit.onTextChanged(text10Remaining);
      expect(cubit.state.announcement, contains('10'));
    });

    test('does not announce at other lengths', () {
      cubit.onTextChanged('Short text');
      expect(cubit.state.announcement, isNull);
    });
  });
}

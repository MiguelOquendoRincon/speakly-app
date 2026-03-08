import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voz_clara/features/categories/domain/entities/category.dart';

void main() {
  group('Category Entity', () {
    test('should supports value equality via Equatable', () {
      const category1 = Category(
        id: 'test_id',
        label: 'Test Label',
        icon: Icons.abc,
      );

      const category2 = Category(
        id: 'test_id',
        label: 'Test Label',
        icon: Icons.abc,
      );

      expect(category1, equals(category2));
    });

    test('should consider categories with different IDs as NOT equal', () {
      const category1 = Category(
        id: 'id_1',
        label: 'Same Label',
        icon: Icons.abc,
      );

      const category2 = Category(
        id: 'id_2',
        label: 'Same Label',
        icon: Icons.abc,
      );

      expect(category1, isNot(equals(category2)));
    });

    test('should define its props correctly', () {
      const category = Category(
        id: 'test_id',
        label: 'Test Label',
        icon: Icons.abc,
        isEmergency: true,
      );

      expect(category.props, ['test_id', 'Test Label', true]);
    });
  });
}

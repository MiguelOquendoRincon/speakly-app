import 'package:flutter_test/flutter_test.dart';
import 'package:voz_clara/features/phrases/data/datasource/phrases_static_datasource.dart';

void main() {
  group('PhrasesStaticDatasource - Categories', () {
    test('should return all 6 default communication categories', () {
      final categories = PhrasesStaticDatasource.getCategories();

      expect(categories.length, 6);
      expect(
        categories.any((c) => c.id == 'basic_needs'),
        isTrue,
        reason: 'Basic needs category should exist',
      );
      expect(
        categories.any((c) => c.id == 'emergency'),
        isTrue,
        reason: 'Emergency category should exist',
      );
    });

    test('should mark at least one category as emergency', () {
      final categories = PhrasesStaticDatasource.getCategories();
      final emergencyCount = categories.where((c) => c.isEmergency).length;

      expect(emergencyCount, 1);
      expect(categories.firstWhere((c) => c.isEmergency).id, 'emergency');
    });

    test('should return all labels in Spanish to meet project standards', () {
      final categories = PhrasesStaticDatasource.getCategories();

      // Basic check for Spanish content
      expect(categories.any((c) => c.label.contains('Salud')), isTrue);
      expect(categories.any((c) => c.label.contains('Emergencia')), isTrue);
    });
  });
}

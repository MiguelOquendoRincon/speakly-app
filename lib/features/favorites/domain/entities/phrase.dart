import 'package:equatable/equatable.dart';

/// Representa una frase que el usuario puede reproducir.
/// Puede ser una frase predefinida de una categoría o una creada por el usuario.
class Phrase extends Equatable {
  final String id;
  final String text;
  final String? categoryId; // Opcional si es una frase libre
  final DateTime createdAt;
  final bool isCustom; // true si fue creada por el usuario en el Compositor

  const Phrase({
    required this.id,
    required this.text,
    this.categoryId,
    required this.createdAt,
    this.isCustom = false,
  });

  @override
  List<Object?> get props => [id, text, categoryId, createdAt, isCustom];

  Phrase copyWith({
    String? id,
    String? text,
    String? categoryId,
    DateTime? createdAt,
    bool? isCustom,
  }) {
    return Phrase(
      id: id ?? this.id,
      text: text ?? this.text,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}

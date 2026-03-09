import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// A single communicable phrase.
///
/// [isFavorite] and [usageCount] are the only mutable concerns —
/// they live in Hive, not in this entity. The entity itself is
/// always constructed as immutable from the data source.
///
/// Why [categoryId] on the entity and not only on the data model?
/// Because use cases that aggregate favorites or history need to
/// know which category a phrase belongs to without re-fetching.
class Phrase extends Equatable {
  const Phrase({
    required this.id,
    required this.categoryId,
    required this.text,
    required this.icon,
    this.subtitle,
    this.isEmergency = false,
    this.isCustom = false,
    required this.createdAt,
  });

  final String id;
  final String categoryId;
  final String text;
  final IconData icon;
  final String? subtitle;
  final bool isEmergency;
  final bool isCustom;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, categoryId, text];
}

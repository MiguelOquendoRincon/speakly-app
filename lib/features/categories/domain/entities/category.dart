import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// A communication category shown on the home grid.
///
/// Immutable value object — Equatable ensures two Category instances
/// with the same [id] are considered equal regardless of reference.
/// This matters for Cubit state comparisons.
class Category extends Equatable {
  const Category({
    required this.id,
    required this.label,
    required this.icon,
    this.isEmergency = false,
  });

  final String id;
  final String label;
  final IconData icon;
  final bool isEmergency;

  @override
  List<Object?> get props => [id, label, isEmergency];
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voz_clara/features/phrases/domain/entities/phrase.dart';
import '../../domain/repositories/favorites_repository.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository repository;

  FavoritesCubit({required this.repository}) : super(FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    try {
      final favorites = await repository.getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(const FavoritesError('Error al cargar favoritos'));
    }
  }

  Future<void> addFavorite(
    String text, {
    String? categoryId,
    bool isCustom = true,
  }) async {
    try {
      final phrase = Phrase(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        categoryId: categoryId ?? '',
        createdAt: DateTime.now(),
        isCustom: isCustom,
        icon: Icons.start,
      );
      await repository.addFavorite(phrase);
      await loadFavorites();
    } catch (e) {
      emit(const FavoritesError('Error al guardar favorito'));
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      await repository.removeFavorite(id);
      await loadFavorites();
    } catch (e) {
      emit(const FavoritesError('Error al eliminar favorito'));
    }
  }
}

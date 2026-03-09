import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voz_clara/features/phrases/domain/entities/phrase.dart';
import 'package:voz_clara/features/phrases/domain/repositories/phrases_repository.dart';
import '../../domain/repositories/favorites_repository.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository favoritesRepository;
  final PhrasesRepository phrasesRepository;

  FavoritesCubit({
    required this.favoritesRepository,
    required this.phrasesRepository,
  }) : super(FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    try {
      // 1. Cargar favoritos personalizados
      final customFavorites = await favoritesRepository.getFavorites();

      // 2. Cargar favoritos estáticos
      final favoriteIds = await phrasesRepository.getFavoriteIds();
      final staticFavorites = phrasesRepository.getPhrasesByIds(favoriteIds);

      // 3. Combinar ambos
      final allFavorites = [...customFavorites, ...staticFavorites];

      // 4. Ordenar (más recientes primero)
      allFavorites.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      emit(FavoritesLoaded(allFavorites));
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
        categoryId: categoryId ?? 'custom',
        createdAt: DateTime.now(),
        isCustom: isCustom,
        icon: Icons.chat_bubble_outline_rounded,
      );
      await favoritesRepository.addFavorite(phrase);
      await loadFavorites();
    } catch (e) {
      emit(const FavoritesError('Error al guardar favorito'));
    }
  }

  Future<void> removeFavorite(Phrase phrase) async {
    try {
      if (phrase.isCustom) {
        await favoritesRepository.removeFavorite(phrase.id);
      } else {
        await phrasesRepository.removeFavorite(phrase.id);
      }
      await loadFavorites();
    } catch (e) {
      emit(const FavoritesError('Error al eliminar favorito'));
    }
  }
}

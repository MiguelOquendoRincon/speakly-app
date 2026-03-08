import 'package:get_it/get_it.dart';
import 'package:voz_clara/features/settings/presentation/cubit/settings_cubit_cubit.dart';
import 'package:voz_clara/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:voz_clara/features/favorites/data/repositories/mock_favorites_repository.dart';
import 'package:voz_clara/features/favorites/presentation/cubit/favorites_cubit.dart';
import '../shared/services/tts_service.dart';

final GetIt sl = GetIt.instance;

/// Register all dependencies here before [runApp].
///
/// Convention:
/// - registerLazySingleton: services that live for the app's lifetime
/// - registerFactory: cubits (new instance per BlocProvider)
Future<void> setupServiceLocator() async {
  // Services — singletons
  sl.registerLazySingleton<TtsService>(() => TtsService());

  // Repositories
  sl.registerLazySingleton<FavoritesRepository>(
    () => MockFavoritesRepository(),
  );

  // Cubits — factories (BlocProvider creates them via sl<CubitName>())
  sl.registerFactory<SettingsCubit>(() => SettingsCubit());
  sl.registerFactory<FavoritesCubit>(
    () => FavoritesCubit(repository: sl<FavoritesRepository>()),
  );

  // Phase 3+: categories, phrases, history, favorites cubits added here
}

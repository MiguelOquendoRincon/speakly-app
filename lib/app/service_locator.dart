import 'package:get_it/get_it.dart';
import 'package:voz_clara/features/favorites/presentation/cubit/quick_phrases_cubit.dart';
import 'package:voz_clara/features/phrases/data/repositories/phrases_repository_impl.dart';
import 'package:voz_clara/features/phrases/domain/repositories/phrases_repository.dart';
import 'package:voz_clara/features/phrases/presentation/cubit/phrases_cubit.dart';
import 'package:voz_clara/features/phrases/presentation/cubit/tts_cubit.dart';
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
  // --- Repository (singleton — one source of truth for phrase data) ---
  sl.registerLazySingleton<PhrasesRepository>(() => PhrasesRepositoryImpl());

  // --- Cubits (factories — new instance per BlocProvider) ---
  // Exception: TtsCubit is a singleton because TTS is a device resource.
  // Only one instance should manage playback state app-wide.
  sl.registerLazySingleton<TtsCubit>(
    () => TtsCubit(sl<TtsService>(), sl<PhrasesRepository>()),
  );
  sl.registerFactory<SettingsCubit>(() => SettingsCubit());
  sl.registerFactory<FavoritesCubit>(
    () => FavoritesCubit(repository: sl<FavoritesRepository>()),
  );
  sl.registerFactory<PhrasesCubit>(() => PhrasesCubit(sl<PhrasesRepository>()));
  sl.registerFactory<QuickPhrasesCubit>(
    () => QuickPhrasesCubit(sl<PhrasesRepository>()),
  );
}

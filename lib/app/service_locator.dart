import 'package:get_it/get_it.dart';
import 'package:voz_clara/features/settings/presentation/cubit/settings_cubit_cubit.dart';
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

  // Cubits — factories (BlocProvider creates them via sl<CubitName>())
  sl.registerFactory<SettingsCubit>(() => SettingsCubit());

  // Phase 3+: categories, phrases, history, favorites cubits added here
}

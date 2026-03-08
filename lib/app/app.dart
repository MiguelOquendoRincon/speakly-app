// lib/app/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voz_clara/features/settings/presentation/cubit/settings_cubit_cubit.dart';
import 'package:voz_clara/features/favorites/presentation/cubit/favorites_cubit.dart';
import '../core/theme/app_theme.dart';
import 'router.dart';
import 'service_locator.dart';

class VozClaraApp extends StatelessWidget {
  const VozClaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>(create: (_) => sl<SettingsCubit>()),
        BlocProvider<FavoritesCubit>(
          create: (_) => sl<FavoritesCubit>()..loadFavorites(),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (prev, curr) => prev.isHighContrast != curr.isHighContrast,
        builder: (context, settings) {
          return MaterialApp.router(
            title: 'VozClara',
            debugShowCheckedModeBanner: false,

            // Accessibility: explicit locale for correct TTS pronunciation
            locale: const Locale('es', 'ES'),

            theme: AppTheme.defaultTheme,
            darkTheme: AppTheme.highContrastTheme,
            themeMode: settings.isHighContrast
                ? ThemeMode.dark
                : ThemeMode.light,

            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}

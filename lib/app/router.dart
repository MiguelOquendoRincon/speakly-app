// lib/app/router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voz_clara/app/main_shell.dart';
import 'package:voz_clara/features/settings/presentation/pages/settings_page.dart';
import 'package:voz_clara/features/phrases/presentation/pages/phrases_page/phrases_page.dart';

/// Named route constants — use these everywhere, never raw strings.
abstract final class AppRoutes {
  static const String home = '/';
  static const String categoryDetail = '/category/:id';
  static const String freeText = '/free-text';
  static const String quickPhrases = '/quick-phrases';
  static const String settings = '/settings';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const MainShell(), // replaced in Phase 3
    ),
    GoRoute(
      path: AppRoutes.categoryDetail,
      name: 'categoryDetail',
      builder: (context, state) {
        final categoryId = state.pathParameters['id']!;
        final categoryLabel = state.extra as String? ?? 'Categoría';
        return PhrasesPage(
          categoryId: categoryId,
          categoryLabel: categoryLabel,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.freeText,
      name: 'freeText',
      builder: (context, state) => const Placeholder(),
    ),
    GoRoute(
      path: AppRoutes.quickPhrases,
      name: 'quickPhrases',
      builder: (context, state) => const Placeholder(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);

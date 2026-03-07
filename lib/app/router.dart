// lib/app/router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      builder: (context, state) => const Placeholder(), // replaced in Phase 3
    ),
    GoRoute(
      path: AppRoutes.categoryDetail,
      name: 'categoryDetail',
      builder: (context, state) {
        final categoryId = state.pathParameters['id']!;
        return Placeholder(key: ValueKey(categoryId));
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
      builder: (context, state) => const Placeholder(),
    ),
  ],
);

// lib/app/router.dart

import 'package:go_router/go_router.dart';
import 'package:voz_clara/app/main_shell.dart';
import 'package:voz_clara/features/categories/presentation/pages/categories_page.dart';
import 'package:voz_clara/features/favorites/presentation/pages/favorites_page.dart';
import 'package:voz_clara/features/free_text/presentation/pages/free_text_page.dart';
import 'package:voz_clara/features/settings/presentation/pages/settings_page.dart';
import 'package:voz_clara/features/phrases/presentation/pages/phrases_page/phrases_page.dart';

/// Named route constants — use these everywhere, never raw strings.
abstract final class AppRoutes {
  static const String home = '/';
  static const String categoryDetail = 'category/:id'; // Sub-ruta de home
  static const String freeText = '/free-text';
  static const String favorites = '/favorites';
  static const String settings = '/settings';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        // RAMA 1: FRASES (Categorías)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: 'home',
              builder: (context, state) => const CategoriesPage(),
              routes: [
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
              ],
            ),
          ],
        ),
        // RAMA 2: ESCRIBIR
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.freeText,
              name: 'freeText',
              builder: (context, state) => const FreeTextPage(),
            ),
          ],
        ),
        // RAMA 3: FAVORITOS
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.favorites,
              name: 'favorites',
              builder: (context, state) => const FavoritesPage(),
            ),
          ],
        ),
        // RAMA 4: AJUSTES
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              name: 'settings',
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

import 'package:flutter/material.dart';
import '../core/accessibility/semantics_labels.dart';
import '../features/categories/presentation/pages/categories_page.dart';
import '../features/free_text/presentation/pages/free_text_page.dart';

/// Main shell with bottom navigation.
///
/// Accessibility decisions:
///
/// 1. BOTTOM NAV LABELS always visible (not icon-only).
///    Icon-only navigation is inaccessible for users with cognitive
///    disabilities and screen reader users who rely on text context.
///    WCAG 2.4.6.
///
/// 2. NavigationBar uses Semantics tab role automatically via Flutter.
///    Each destination is announced as "Tab X of 4" by TalkBack/VoiceOver.
///
/// 3. Selected state is communicated via the tab role's selected property —
///    not by color alone. WCAG 1.4.1.
///
/// 4. Page transitions respect reduceMotion setting (Phase 4 wiring).
///    When reduceMotion is true, transitions are instant. WCAG 2.3.3 (AAA).
///
/// 5. IndexedStack keeps all pages alive — avoids re-announcing the screen
///    on every tab switch, which is disorienting for screen reader users.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _destinations = [
    _NavDestination(
      icon: Icons.grid_view_rounded,
      selectedIcon: Icons.grid_view_rounded,
      label: 'Frases',
      semanticLabel: SemanticsLabels.bottomNavHome,
    ),
    _NavDestination(
      icon: Icons.edit_outlined,
      selectedIcon: Icons.edit_rounded,
      label: 'Compositor',
      semanticLabel: SemanticsLabels.bottomNavFreeText,
    ),
    _NavDestination(
      icon: Icons.star_outline_rounded,
      selectedIcon: Icons.star_rounded,
      label: 'Favoritos',
      semanticLabel: SemanticsLabels.bottomNavQuickPhrases,
    ),
    _NavDestination(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
      label: 'Ajustes',
      semanticLabel: SemanticsLabels.bottomNavSettings,
    ),
  ];

  // IndexedStack — all pages built once and kept alive.
  // Avoids re-triggering initState screen announcements on every tab switch.
  static final _pages = [
    const CategoriesPage(),
    const FreeTextPage(),
    const Placeholder(), // Phase 4: QuickPhrasesPage
    const Placeholder(), // Phase 4: SettingsPage (routed separately above)
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor: theme.colorScheme.surface,
        elevation: 8,
        destinations: _destinations.map((d) {
          return NavigationDestination(
            icon: Semantics(
              // NavigationDestination uses its label for accessibility.
              // We provide the semantic label directly on the destination.
              excludeSemantics: true,
              child: Icon(d.icon),
            ),
            selectedIcon: ExcludeSemantics(child: Icon(d.selectedIcon)),
            label: d.label,
            // tooltip carries the full semantic label for screen readers
            // when NavigationDestination doesn't expose semanticLabel directly.
            tooltip: d.semanticLabel,
          );
        }).toList(),
      ),
    );
  }
}

class _NavDestination {
  const _NavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.semanticLabel,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String semanticLabel;
}

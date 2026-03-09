import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voz_clara/features/phrases/presentation/cubit/tts_cubit.dart';
import 'package:voz_clara/features/favorites/presentation/cubit/quick_phrases_cubit.dart';
import '../core/accessibility/semantics_labels.dart';

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
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    _NavDestination(
      icon: CupertinoIcons.chat_bubble_2,
      selectedIcon: CupertinoIcons.chat_bubble_2_fill,
      label: 'Frases',
      semanticLabel: SemanticsLabels.bottomNavHome,
    ),
    _NavDestination(
      icon: CupertinoIcons.keyboard,
      selectedIcon: CupertinoIcons.keyboard,
      label: 'Escribir',
      semanticLabel: SemanticsLabels.bottomNavFreeText,
    ),
    _NavDestination(
      icon: CupertinoIcons.heart,
      selectedIcon: CupertinoIcons.heart_fill,
      label: 'Favoritos',
      semanticLabel: SemanticsLabels.bottomNavQuickPhrases,
    ),
    _NavDestination(
      icon: CupertinoIcons.settings,
      selectedIcon: CupertinoIcons.settings,
      label: 'Ajustes',
      semanticLabel: SemanticsLabels.bottomNavSettings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Global Accessibility Announcer — listens to TtsCubit for status/text announcements.
          // This replaces deprecated fire-and-forget Announce events with semantic properties.
          BlocBuilder<TtsCubit, TtsState>(
            builder: (context, state) {
              return Semantics(
                liveRegion: true,
                label: state.announcement,
                child: const SizedBox.shrink(),
              );
            },
          ),
          NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (i) {
              navigationShell.goBranch(
                i,
                initialLocation: i == navigationShell.currentIndex,
              );
              if (i == 2) {
                context.read<QuickPhrasesCubit>().load();
              }
            },
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
                selectedIcon: ExcludeSemantics(
                  child: Icon(d.selectedIcon, color: theme.colorScheme.surface),
                ),
                label: d.label,
                // tooltip carries the full semantic label for screen readers
                // when NavigationDestination doesn't expose semanticLabel directly.
                tooltip: d.semanticLabel,
              );
            }).toList(),
          ),
        ],
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

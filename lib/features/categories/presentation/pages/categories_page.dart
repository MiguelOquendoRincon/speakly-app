import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/accessibility/semantics_labels.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../widgets/category_card.dart';

/// Home screen — category selection grid.
///
/// Semantic structure (from Phase 1 contract):
///
///   Screen announcement on load: "VozClara, categorías de comunicación"
///   Header: "Categorías" (header: true)
///   Grid: 6 CategoryCards (each: button, label, hint)
///   Quick responses section header (header: true)
///   Quick phrase row
///
/// Focus traversal: Flutter's default top-to-bottom, left-to-right
/// traversal is correct here. No custom FocusTraversalGroup needed.
///
/// WCAG: 1.3.1, 1.3.2, 2.4.3, 2.4.6, 4.1.2
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
    // Announce screen identity when TalkBack/VoiceOver first lands here.
    // This gives screen reader users immediate orientation context.
    // WCAG 2.4.2 (Page Titled).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SemanticsService.announce(
        SemanticsLabels.categoriesScreenAnnouncement,
        TextDirection.ltr,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        // AppBar title has an implicit header role in the semantic tree.
        title: Text('VozClara', style: theme.textTheme.headlineMedium),
        actions: [
          Semantics(
            label: SemanticsLabels.bottomNavSettings,
            button: true,
            excludeSemantics: true,
            child: IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.go('/settings'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.kSpacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SECTION: Main categories
              Semantics(
                header: true,
                child: Text(
                  'Categorías',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.kSpacingM),

              // Category grid — 2 columns.
              // GridView.count is preferred over GridView.builder here
              // because the item count is fixed and known at build time.
              // shrinkWrap + NeverScrollableScrollPhysics because the
              // entire page is already in a SingleChildScrollView.
              GridView.count(
                crossAxisCount: AppDimensions.kCategoryGridColumns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppDimensions.kSpacingM,
                crossAxisSpacing: AppDimensions.kSpacingM,
                // childAspectRatio: slightly taller than wide for
                // comfortable touch targets at all text scales.
                childAspectRatio: 1.1,
                children: _categories.map((cat) {
                  return CategoryCard(
                    label: cat.label,
                    icon: cat.icon,
                    isEmergency: cat.isEmergency,
                    onTap: () {
                      // Phase 4: navigate to category detail
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: AppDimensions.kSpacingXL),

              // SECTION: Quick responses
              Semantics(
                header: true,
                child: Text(
                  'Respuestas rápidas',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.kSpacingM),

              // Quick response row — horizontal, fixed items.
              // Row of large buttons, not chips, to ensure touch target size.
              Row(
                children: _quickResponses.map((qr) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.kSpacingXS,
                      ),
                      child: _QuickResponseButton(
                        label: qr.label,
                        icon: qr.icon,
                        color: qr.color,
                        onTap: () {
                          // Phase 4: trigger TTS
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppDimensions.kSpacingXL),

              // Tip card — decorative, excluded from semantics to avoid
              // adding cognitive load to screen reader navigation.
              ExcludeSemantics(
                child: _TipCard(
                  text:
                      'Consejo: Las señales visuales ayudan a '
                      'comunicarse más rápido en entornos concurridos.',
                ),
              ),

              const SizedBox(height: AppDimensions.kSpacingL),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data models (will move to domain layer in Phase 4 when Cubit is wired)
// ---------------------------------------------------------------------------

class _CategoryData {
  const _CategoryData({
    required this.label,
    required this.icon,
    this.isEmergency = false,
  });
  final String label;
  final IconData icon;
  final bool isEmergency;
}

const _categories = [
  _CategoryData(label: 'Necesidades básicas', icon: Icons.restaurant_outlined),
  _CategoryData(label: 'Salud', icon: Icons.medical_services_outlined),
  _CategoryData(label: 'Emociones', icon: Icons.sentiment_satisfied_outlined),
  _CategoryData(label: 'Movilidad', icon: Icons.accessible_outlined),
  _CategoryData(label: 'Social', icon: Icons.chat_bubble_outline_rounded),
  _CategoryData(
    label: 'Emergencia',
    icon: Icons.warning_amber_rounded,
    isEmergency: true,
  ),
];

class _QuickResponseData {
  const _QuickResponseData({
    required this.label,
    required this.icon,
    required this.color,
  });
  final String label;
  final IconData icon;
  final Color color;
}

const _quickResponses = [
  _QuickResponseData(
    label: 'Sí',
    icon: Icons.check_circle_outline_rounded,
    color: Color(0xFF1A6B3A),
  ),
  _QuickResponseData(
    label: 'No',
    icon: Icons.cancel_outlined,
    color: Color(0xFFC0392B),
  ),
  _QuickResponseData(
    label: 'Por favor',
    icon: Icons.favorite_outline_rounded,
    color: Color(0xFF1B5E8A),
  ),
];

// ---------------------------------------------------------------------------
// Private sub-widgets
// ---------------------------------------------------------------------------

class _QuickResponseButton extends StatelessWidget {
  const _QuickResponseButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: label,
      hint: 'Doble toque para reproducir: $label',
      button: true,
      excludeSemantics: true,
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.kRadiusM),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.kRadiusM),
          child: Container(
            // Minimum height enforces touch target even at small widths.
            constraints: const BoxConstraints(
              minHeight: AppDimensions.kMinTouchTarget,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.kSpacingM,
              horizontal: AppDimensions.kSpacingS,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(AppDimensions.kRadiusM),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ExcludeSemantics(child: Icon(icon, color: color, size: 26)),
                const SizedBox(height: AppDimensions.kSpacingXS),
                Text(
                  label,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.kSpacingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          height: 1.6,
        ),
      ),
    );
  }
}

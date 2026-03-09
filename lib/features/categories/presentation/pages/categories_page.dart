import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../settings/presentation/cubit/settings_cubit_cubit.dart';
import '../../../phrases/presentation/cubit/tts_cubit.dart';
import '../../../../core/accessibility/semantics_labels.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/voz_clara_app_bar.dart';
import '../widgets/category_card.dart';

/// Pantalla principal — cuadrícula de selección de categorías.
///
/// Estructura semántica (del contrato Fase 1):
///
///   Anuncio de pantalla al cargar: "VozClara, categorías de comunicación"
///   Encabezado: "CATEGORÍAS PRINCIPALES" (header: true)
///   Cuadrícula: 6 CategoryCards (cada una: botón, etiqueta, pista)
///   Encabezado de respuestas rápidas (header: true)
///   Fila de respuestas rápidas
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
    // Identidad de pantalla manejada vía propiedades semánticas en el primer elemento del build.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Semantics(
          label: SemanticsLabels.categoriesScreenAnnouncement,
          child: Column(
            children: [
              const VozClaraAppBar(title: 'FRASES'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.kSpacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SECTION: Main categories title
                      Semantics(
                        header: true,
                        child: Text(
                          'CATEGORÍAS PRINCIPALES',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.kSpacingM),

                      // Category grid — 2 columns.
                      GridView.count(
                        crossAxisCount: AppDimensions.kCategoryGridColumns,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: AppDimensions.kSpacingM,
                        crossAxisSpacing: AppDimensions.kSpacingM,
                        childAspectRatio: 0.9, // Adjust for larger icon area
                        children: _categories.map((cat) {
                          return CategoryCard(
                            label: cat.label,
                            icon: cat.icon,
                            isEmergency: cat.isEmergency,
                            onTap: () {
                              context.pushNamed(
                                'categoryDetail',
                                pathParameters: {'id': cat.id},
                                extra: cat.label,
                              );
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: AppDimensions.kSpacingXL),

                      // SECTION: Quick responses title
                      Semantics(
                        header: true,
                        child: Text(
                          'RESPUESTAS RÁPIDAS',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.kSpacingM),

                      // Quick response row — horizontal, fixed items.
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
                                  context.read<TtsCubit>().speakFreeText(
                                    qr.label,
                                  );
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppDimensions.kSpacingXL),
                    ],
                  ),
                ),
              ),
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
    required this.id,
    required this.label,
    required this.icon,
    this.isEmergency = false,
  });
  final String id;
  final String label;
  final IconData icon;
  final bool isEmergency;
}

const _categories = [
  _CategoryData(
    id: 'basic_needs',
    label: 'NECESIDADES BÁSICAS',
    icon: Icons.restaurant_rounded,
  ),
  _CategoryData(
    id: 'health',
    label: 'SALUD',
    icon: Icons.medical_services_rounded,
  ),
  _CategoryData(
    id: 'emotions',
    label: 'EMOCIONES',
    icon: Icons.sentiment_satisfied_alt_rounded,
  ),
  _CategoryData(
    id: 'mobility',
    label: 'MOVILIDAD',
    icon: Icons.accessible_rounded,
  ),
  _CategoryData(id: 'social', label: 'SOCIAL', icon: Icons.chat_bubble_rounded),
  _CategoryData(
    id: 'emergency',
    label: 'EMERGENCIA',
    icon: Icons.warning_rounded,
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
  _QuickResponseData(label: 'SI', icon: Icons.check, color: Color(0xFF10B981)),
  _QuickResponseData(label: 'NO', icon: Icons.close, color: Color(0xFFEF4444)),
  _QuickResponseData(
    label: 'POR FAVOR',
    icon: Icons.favorite,
    color: Color(0xFF3B82F6),
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
    final isHC = context.select<SettingsCubit, bool>(
      (cubit) => cubit.state.isHighContrast,
    );
    final bool isDark = theme.brightness == Brightness.dark;

    final Color effectiveColor = isHC ? theme.colorScheme.primary : color;

    return Semantics(
      label: label,
      hint: 'Tocar para reproducir: $label',
      button: true,
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
          border: Border.all(
            color: isDark
                ? Colors.white12
                : Colors.black.withValues(alpha: 0.05),
            width: isHC ? 3.0 : 1.5,
          ),
          boxShadow: isHC
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimensions.kRadiusL),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.kSpacingL,
                horizontal: AppDimensions.kSpacingS,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Circular Icon (Match design)
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isHC
                          ? effectiveColor
                          : effectiveColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: isHC
                          ? null
                          : Border.all(
                              color: effectiveColor.withValues(alpha: 0.3),
                              width: 1,
                            ),
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        color: isHC ? Colors.black : effectiveColor,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.kSpacingS),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isHC ? Colors.white : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                      letterSpacing: isHC ? 1.2 : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

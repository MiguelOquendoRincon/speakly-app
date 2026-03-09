import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_dimensions.dart';

/// App bar compartido diseñado siguiendo el estilo premium de VozClara.
///
/// Características:
/// - Botón de retroceso con fondo circular suave.
/// - Título centrado y en negrita.
/// - Divisor inferior sutil.
/// - Navegación automática a la pantalla de inicio (Frases) al presionar atrás.
class VozClaraAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VozClaraAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
  });

  final String title;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.kSpacingM,
              vertical: AppDimensions.kSpacingS,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (showBackButton)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Semantics(
                      label: 'Volver a Frases',
                      button: true,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.08,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: theme.colorScheme.primary,
                            size: 22,
                          ),
                          onPressed: () {
                            // Si podemos hacer pop (p.ej. estamos en detalle de categoría), lo hacemos.
                            // Si no, forzamos la navegación a la raíz (Pestaña de Frases).
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              context.go('/');
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                Semantics(
                  header: true,
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

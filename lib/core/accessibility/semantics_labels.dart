// lib/core/accessibility/semantics_labels.dart

/// Centralized semantic label strings for VozClara.
///
/// Why centralized?
/// 1. Testable — unit tests can verify labels without rendering widgets.
/// 2. Consistent — the same phrase is never announced two different ways.
/// 3. Translatable — when we add i18n, this becomes the source of truth.
///
/// Convention: method names describe the element, parameters provide context.
abstract final class SemanticsLabels {
  // --- Navigation ---
  static const String backToCategories = 'Volver a categorías';
  static const String bottomNavHome = 'Inicio, categorías de comunicación';
  static const String bottomNavQuickPhrases =
      'Acceso rápido a frases favoritas';
  static const String bottomNavFreeText = 'Escribir mensaje personalizado';
  static const String bottomNavSettings = 'Configuración';

  // --- Categories screen ---
  static const String categoriesScreenAnnouncement =
      'VozClara, categorías de comunicación';

  static String categoryCard(String categoryName) => categoryName;

  static String categoryCardHint(String categoryName) =>
      'Doble toque para abrir $categoryName';

  // --- Phrases screen ---
  static String phrasesScreenTitle(String categoryName) =>
      '$categoryName, frases disponibles';

  static String phraseCardHint(String phraseText) =>
      'Doble toque para reproducir: $phraseText';

  static String addToFavorites(String phraseText) =>
      'Agregar a favoritos: $phraseText';

  static String removeFromFavorites(String phraseText) =>
      'Quitar de favoritos: $phraseText';

  // --- Free text screen ---
  static const String freeTextScreenTitle = 'Escribe tu mensaje';
  static const String freeTextFieldLabel = 'Mensaje a reproducir';
  static const String freeTextFieldHint =
      'Escribe el mensaje que quieres escuchar en voz alta';
  static const String speakButtonLabel = 'Reproducir mensaje';
  static const String speakButtonHint =
      'Doble toque para escuchar el mensaje en voz alta';
  static const String clearButtonLabel = 'Borrar mensaje';

  static String characterCount(int remaining) =>
      '$remaining caracteres restantes';

  // --- Settings screen ---
  static const String settingsScreenTitle = 'Configuración de accesibilidad';
  static const String highContrastLabel = 'Modo alto contraste';
  static const String reduceMotionLabel = 'Reducir animaciones';
  static const String ttsSpeechRateLabel = 'Velocidad de voz';
  static const String ttsSpeechRateHint =
      'Desliza para ajustar la velocidad de reproducción';

  static String ttsSpeechRateValue(double rate) =>
      '${rate.toStringAsFixed(1)}x';

  // --- Quick phrases screen ---
  static const String quickPhrasesScreenTitle = 'Acceso rápido';
  static const String favoritesSection = 'Favoritos';
  static const String recentsSection = 'Recientes';
  static const String emptyFavorites =
      'No tienes frases favoritas aún. Ve a categorías para agregarlas.';
  static const String emptyRecents =
      'No has reproducido ninguna frase todavía.';

  // --- TTS state announcements ---
  static const String ttsSpeaking = 'Reproduciendo mensaje';
  static const String ttsStopped = 'Reproducción detenida';
}

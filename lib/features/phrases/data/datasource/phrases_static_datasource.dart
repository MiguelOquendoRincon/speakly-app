import 'package:flutter/material.dart';
import '../../domain/entities/phrase.dart';
import '../../../categories/domain/entities/category.dart';

/// Static phrase bank — all predefined content for VozClara MVP.
///
/// Architecture note:
/// This is the data source, not the repository. The repository
/// calls this and maps results to domain entities. The UI never
/// touches this class directly.
///
/// Phrase design principles applied here:
/// - Short, direct, unambiguous text.
/// - First person where natural ("Tengo dolor") — the user is speaking.
/// - Emergency phrases use all-caps to visually signal urgency.
/// - Each phrase has a subtitle that provides context without
///   changing the spoken text. Subtitles are excluded from TTS.
class PhrasesStaticDatasource {
  // ---------------------------------------------------------------------------
  // Categories
  // ---------------------------------------------------------------------------

  static List<Category> getCategories() => [
    Category(
      id: 'basic_needs',
      label: 'Necesidades básicas',
      icon: Icons.restaurant_outlined,
    ),
    Category(
      id: 'health',
      label: 'Salud',
      icon: Icons.medical_services_outlined,
    ),
    Category(
      id: 'emotions',
      label: 'Emociones',
      icon: Icons.sentiment_satisfied_outlined,
    ),
    Category(
      id: 'mobility',
      label: 'Movilidad',
      icon: Icons.accessible_outlined,
    ),
    Category(
      id: 'social',
      label: 'Social',
      icon: Icons.chat_bubble_outline_rounded,
    ),
    Category(
      id: 'emergency',
      label: 'Emergencia',
      icon: Icons.warning_amber_rounded,
      isEmergency: true,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Phrases by category
  // ---------------------------------------------------------------------------

  static List<Phrase> getPhrasesByCategory(String categoryId) {
    return _allPhrases.where((p) => p.categoryId == categoryId).toList();
  }

  static List<Phrase> getPhrasesById(List<String> ids) {
    return _allPhrases.where((p) => ids.contains(p.id)).toList();
  }

  static Phrase? getPhraseById(String id) {
    try {
      return _allPhrases.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Full phrase bank
  // ---------------------------------------------------------------------------

  static final List<Phrase> _allPhrases = [
    // --- Necesidades básicas ---
    Phrase(
      id: 'bn_water',
      categoryId: 'basic_needs',
      text: 'Tengo sed',
      icon: Icons.water_drop_outlined,
      subtitle: 'Pedir agua',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'bn_food',
      categoryId: 'basic_needs',
      text: 'Tengo hambre',
      icon: Icons.restaurant_outlined,
      subtitle: 'Pedir comida',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'bn_bathroom',
      categoryId: 'basic_needs',
      text: 'Necesito ir al baño',
      icon: Icons.wc_outlined,
      subtitle: 'Necesidad fisiológica',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'bn_rest',
      categoryId: 'basic_needs',
      text: 'Quiero descansar',
      icon: Icons.bed_outlined,
      subtitle: 'Pedir descanso',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'bn_cold',
      categoryId: 'basic_needs',
      text: 'Tengo frío',
      icon: Icons.ac_unit_outlined,
      subtitle: 'Temperatura',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'bn_hot',
      categoryId: 'basic_needs',
      text: 'Tengo calor',
      icon: Icons.wb_sunny_outlined,
      subtitle: 'Temperatura',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'bn_repeat',
      categoryId: 'basic_needs',
      text: 'Por favor repite',
      icon: Icons.replay_outlined,
      subtitle: 'No entendí',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'bn_slower',
      categoryId: 'basic_needs',
      text: 'Habla más despacio',
      icon: Icons.slow_motion_video_outlined,
      subtitle: 'Ritmo de comunicación',
      createdAt: DateTime.now(),
      isCustom: false,
    ),

    // --- Salud ---
    Phrase(
      id: 'health_pain',
      categoryId: 'health',
      text: 'Tengo dolor',
      icon: Icons.medical_services_outlined,
      subtitle: 'Dolor general',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'health_head',
      categoryId: 'health',
      text: 'Me duele la cabeza',
      icon: Icons.psychology_outlined,
      subtitle: 'Dolor de cabeza',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'health_medicine',
      categoryId: 'health',
      text: 'Necesito mi medicamento',
      icon: Icons.medication_outlined,
      subtitle: 'Solicitar medicación',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'health_doctor',
      categoryId: 'health',
      text: 'Quiero ver a un médico',
      icon: Icons.local_hospital_outlined,
      subtitle: 'Atención médica',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'health_dizzy',
      categoryId: 'health',
      text: 'Me siento mareado',
      icon: Icons.rotate_right_outlined,
      subtitle: 'Mareo',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'health_nausea',
      categoryId: 'health',
      text: 'Tengo náuseas',
      icon: Icons.sick_outlined,
      subtitle: 'Malestar',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'health_breathe',
      categoryId: 'health',
      text: 'Me cuesta respirar',
      icon: Icons.air_outlined,
      subtitle: 'Dificultad respiratoria',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'health_allergy',
      categoryId: 'health',
      text: 'Tengo alergia',
      icon: Icons.warning_outlined,
      subtitle: 'Alerta de alergia',
      createdAt: DateTime.now(),
      isCustom: false,
    ),

    // --- Emociones ---
    Phrase(
      id: 'em_happy',
      categoryId: 'emotions',
      text: 'Estoy bien',
      icon: Icons.sentiment_satisfied_outlined,
      subtitle: 'Estado positivo',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'em_sad',
      categoryId: 'emotions',
      text: 'Estoy triste',
      icon: Icons.sentiment_dissatisfied_outlined,
      subtitle: 'Estado emocional',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'em_scared',
      categoryId: 'emotions',
      text: 'Tengo miedo',
      icon: Icons.sentiment_very_dissatisfied_outlined,
      subtitle: 'Miedo o ansiedad',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'em_frustrated',
      categoryId: 'emotions',
      text: 'Estoy frustrado',
      icon: Icons.mood_bad_outlined,
      subtitle: 'Frustración',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'em_calm',
      categoryId: 'emotions',
      text: 'Estoy tranquilo',
      icon: Icons.self_improvement_outlined,
      subtitle: 'Estado calmado',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'em_tired',
      categoryId: 'emotions',
      text: 'Estoy cansado',
      icon: Icons.bedtime_outlined,
      subtitle: 'Cansancio',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'em_uncomfortable',
      categoryId: 'emotions',
      text: 'Me siento incómodo',
      icon: Icons.do_not_disturb_outlined,
      subtitle: 'Incomodidad',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'em_grateful',
      categoryId: 'emotions',
      text: 'Gracias por tu ayuda',
      icon: Icons.favorite_outline_rounded,
      subtitle: 'Gratitud',
      createdAt: DateTime.now(),
      isCustom: false,
    ),

    // --- Movilidad ---
    Phrase(
      id: 'mob_help_move',
      categoryId: 'mobility',
      text: 'Necesito ayuda para moverme',
      icon: Icons.accessible_outlined,
      subtitle: 'Asistencia de movilidad',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'mob_wheelchair',
      categoryId: 'mobility',
      text: 'Necesito mi silla de ruedas',
      icon: Icons.accessible_forward_outlined,
      subtitle: 'Silla de ruedas',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'mob_sit',
      categoryId: 'mobility',
      text: 'Quiero sentarme',
      icon: Icons.chair_outlined,
      subtitle: 'Cambio de posición',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'mob_stand',
      categoryId: 'mobility',
      text: 'Quiero levantarme',
      icon: Icons.accessibility_new_outlined,
      subtitle: 'Cambio de posición',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'mob_walk',
      categoryId: 'mobility',
      text: 'Quiero caminar',
      icon: Icons.directions_walk_outlined,
      subtitle: 'Moverse a pie',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'mob_slow',
      categoryId: 'mobility',
      text: 'Más despacio por favor',
      icon: Icons.slow_motion_video_outlined,
      subtitle: 'Ritmo de desplazamiento',
      createdAt: DateTime.now(),
      isCustom: false,
    ),

    // --- Social ---
    Phrase(
      id: 'soc_yes',
      categoryId: 'social',
      text: 'Sí',
      icon: Icons.check_circle_outline_rounded,
      subtitle: 'Afirmación',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'soc_no',
      categoryId: 'social',
      text: 'No',
      icon: Icons.cancel_outlined,
      subtitle: 'Negación',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'soc_please',
      categoryId: 'social',
      text: 'Por favor',
      icon: Icons.favorite_outline_rounded,
      subtitle: 'Cortesía',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'soc_thanks',
      categoryId: 'social',
      text: 'Gracias',
      icon: Icons.thumb_up_outlined,
      subtitle: 'Agradecimiento',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'soc_wait',
      categoryId: 'social',
      text: 'Por favor espera',
      icon: Icons.hourglass_empty_outlined,
      subtitle: 'Pedir pausa',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'soc_understand',
      categoryId: 'social',
      text: 'No entiendo',
      icon: Icons.help_outline_rounded,
      subtitle: 'Pedir aclaración',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'soc_hello',
      categoryId: 'social',
      text: 'Hola',
      icon: Icons.waving_hand_outlined,
      subtitle: 'Saludo',
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'soc_goodbye',
      categoryId: 'social',
      text: 'Hasta luego',
      icon: Icons.directions_walk_outlined,
      subtitle: 'Despedida',
      createdAt: DateTime.now(),
      isCustom: false,
    ),

    // --- Emergencia ---
    Phrase(
      id: 'em_help',
      categoryId: 'emergency',
      text: 'NECESITO AYUDA',
      icon: Icons.sos_outlined,
      subtitle: 'Asistencia de emergencia',
      isEmergency: true,
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'em_call',
      categoryId: 'emergency',
      text: 'LLAMA AL 123',
      icon: Icons.emergency_outlined,
      subtitle: 'Servicios de emergencia',
      isEmergency: true,
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'em_alone',
      categoryId: 'emergency',
      text: 'ESTOY SOLO Y NECESITO AYUDA',
      icon: Icons.person_off_outlined,
      subtitle: 'Emergencia en soledad',
      isEmergency: true,
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'em_fall',
      categoryId: 'emergency',
      text: 'ME HE CAÍDO',
      icon: Icons.personal_injury_outlined,
      subtitle: 'Caída',
      isEmergency: true,
      createdAt: DateTime.now(),
      isCustom: false,
    ),
    Phrase(
      id: 'em_pain_severe',
      categoryId: 'emergency',
      text: 'DOLOR SEVERO',
      icon: Icons.warning_rounded,
      subtitle: 'Dolor urgente',
      isEmergency: true,
      createdAt: DateTime.now(),
      isCustom: false,
    ),
  ];
}

import 'package:flutter/material.dart';

class LanguageHelper {
  static final ValueNotifier<String> languageNotifier = ValueNotifier<String>('English');

  static String get currentLanguage => languageNotifier.value;

  static set currentLanguage(String lang) {
    languageNotifier.value = lang;
  }

  static String translate(String key, {Map<String, String>? placeholders}) {
    final translations = {
      'English': {
        'catalog_dashboard': 'Catalog / Dashboard',
        'profile': 'PROFILE',
        'average_progress': 'Average Progress',
        'test_performance': 'Test Performance',
        'topics': 'TOPICS',
        'workspace': 'WORKSPACE',
        'language': 'LANGUAGE',
        'logout': 'LOGOUT',
        'powered_by': 'Powered by eMe.world',
        'notifications': 'Notifications',
        'new_tutorials': '3 New',
        'level': 'Level 10',
        'avg_suffix': 'Avg',
        'new_tutorial_title': 'New Tutorial Available',
        'new_tutorial_body': 'Mathematical Competence 2 has been unlocked.',
        'achievement_title': 'Achievement Unlocked',
        'achievement_body': 'You completed 3 subject diagnostic tests.',
        'time_5m': '5m ago',
        'time_2h': '2h ago',
        'tutorials_count': '{count} tutorials',
        'days_to_go': 'days to go',
        'efficiency': 'efficiency',
        'moderate': 'Moderate',
        'last_updated': 'Last updated: {date}',
        'tutorials': 'Tutorials',
        'total_tutorials': 'TOTAL TUTORIALS',
        'active_tutorials': '{count} Active Tutorials',
        'tests_performance': 'TESTS PERFORMANCE',
        'average_score': '{progress}% Average Score',
        'overall_topic_progress': 'Overall Topic Progress',
        'finished': '{percent}% Finished',
      },
      'Español': {
        'catalog_dashboard': 'Catálogo / Tablero',
        'profile': 'PERFIL',
        'average_progress': 'Progreso Promedio',
        'test_performance': 'Rendimiento de Prueba',
        'topics': 'TEMAS',
        'workspace': 'ESPACIO DE TRABAJO',
        'language': 'IDIOMA',
        'logout': 'CERRAR SESIÓN',
        'powered_by': 'Desarrollado por eMe.world',
        'notifications': 'Notificaciones',
        'new_tutorials': '3 Nuevas',
        'level': 'Nivel 10',
        'avg_suffix': 'Promedio',
        'new_tutorial_title': 'Nuevo Tutorial Disponible',
        'new_tutorial_body': 'Competencia Matemática 2 ha sido desbloqueada.',
        'achievement_title': 'Logro Desbloqueado',
        'achievement_body': 'Completaste 3 pruebas de diagnóstico del tema.',
        'time_5m': 'Hace 5m',
        'time_2h': 'Hace 2h',
        'tutorials_count': '{count} tutoriales',
        'days_to_go': 'días restantes',
        'efficiency': 'eficiencia',
        'moderate': 'Moderado',
        'last_updated': 'Última actualización: {date}',
        'tutorials': 'Tutoriales',
        'total_tutorials': 'TUTORIALES TOTALES',
        'active_tutorials': '{count} Tutoriales Activos',
        'tests_performance': 'RENDIMIENTO DE PRUEBAS',
        'average_score': '{progress}% Puntaje Promedio',
        'overall_topic_progress': 'Progreso General del Tema',
        'finished': '{percent}% Finalizado',
      }
    };

    String value = translations[currentLanguage]?[key] ?? key;
    if (placeholders != null) {
      placeholders.forEach((placeholderKey, placeholderValue) {
        value = value.replaceAll('{$placeholderKey}', placeholderValue);
      });
    }
    return value;
  }
}

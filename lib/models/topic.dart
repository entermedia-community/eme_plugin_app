import 'tutorial.dart';

enum Efficiency { beginner, learner, expert }

class Topic {
  final String title;
  final String thumbnail;
  final int completedTutorials;
  final Efficiency efficiency;
  final double validityPeriod;
  final double reliability;
  final DateTime lastUpdated;
  final List<Tutorial> tutorial;

  const Topic({
    required this.title,
    required this.thumbnail,
    required this.completedTutorials,
    required this.efficiency,
    required this.validityPeriod,
    required this.reliability,
    required this.lastUpdated,
    required this.tutorial,
  });

  // Calculates the average progress of tutorials within this topic
  double get progress {
    if (tutorial.isEmpty) return 0.0;
    return completedTutorials / tutorial.length;
  }
}

// Mock topics grouping the original mockTutorials and adding additional detail tutorials
// Mock topics grouping the original mockTutorials and adding additional detail tutorials
final List<Topic> mockTopics = [
  Topic(
    title: 'Introducción a la Ciberseguridad',
    thumbnail:
        'https://minsur.testu.co/testu/mediadb/services/module/asset/generate/Web%20Content/Test%20Data%20for%20App/Ciberseguridad.png/image200x200.webp/CiberseguridadS.webp',
    completedTutorials: 1,
    efficiency: Efficiency.beginner,
    validityPeriod: 30.0,
    reliability: 7.0,
    lastUpdated: DateTime.now().subtract(Duration(days: 7)),
    tutorial: [
      mockTutorials[0],
      mockTutorials[1],
      mockTutorials[2],
      mockTutorials[3],
    ],
  ),
  Topic(
    title: 'Derechos Humanos DDHH en MinSUR',
    thumbnail:
        'https://minsur.testu.co/testu/mediadb/services/module/asset/generate/Web%20Content/Test%20Data%20for%20App/Humanos.png/image200x200.webp/HumanosS.webp',
    completedTutorials: 2,
    efficiency: Efficiency.expert,
    validityPeriod: 30.0,
    reliability: 28.0,
    lastUpdated: DateTime.now(),
    tutorial: [
      mockTutorials[4],
      mockTutorials[5],
      mockTutorials[6],
      mockTutorials[7],
    ],
  ),
  Topic(
    title: 'Prevención de Riesgos Laborales',
    thumbnail:
        'https://minsur.testu.co/testu/mediadb/services/module/asset/generate/Web%20Content/Test%20Data%20for%20App/Ciberseguridad.png/image200x200.webp/CiberseguridadS.webp',
    completedTutorials: 3,
    efficiency: Efficiency.expert,
    validityPeriod: 30.0,
    reliability: 88.0,
    lastUpdated: DateTime.now().subtract(Duration(days: 2)),
    tutorial: [
      mockTutorials[0],
      mockTutorials[1],
      mockTutorials[2],
      mockTutorials[3],
    ],
  ),
  Topic(
    title: 'Código de Conducta y Ética',
    thumbnail:
        'https://minsur.testu.co/testu/mediadb/services/module/asset/generate/Web%20Content/Test%20Data%20for%20App/Humanos.png/image200x200.webp/HumanosS.webp',
    completedTutorials: 4,
    efficiency: Efficiency.expert,
    validityPeriod: 30.0,
    reliability: 95.0,
    lastUpdated: DateTime.now().subtract(Duration(days: 1)),
    tutorial: [
      mockTutorials[4],
      mockTutorials[5],
      mockTutorials[6],
      mockTutorials[7],
    ],
  ),
  Topic(
    title: 'Seguridad de la Información',
    thumbnail:
        'https://minsur.testu.co/testu/mediadb/services/module/asset/generate/Web%20Content/Test%20Data%20for%20App/Ciberseguridad.png/image200x200.webp/CiberseguridadS.webp',
    completedTutorials: 4,
    efficiency: Efficiency.expert,
    validityPeriod: 30.0,
    reliability: 92.0,
    lastUpdated: DateTime.now(),
    tutorial: [
      mockTutorials[0],
      mockTutorials[1],
      mockTutorials[2],
      mockTutorials[3],
    ],
  ),
  Topic(
    title: 'Gestión Ambiental y Sostenibilidad',
    thumbnail:
        'https://minsur.testu.co/testu/mediadb/services/module/asset/generate/Web%20Content/Test%20Data%20for%20App/Humanos.png/image200x200.webp/HumanosS.webp',
    completedTutorials: 2,
    efficiency: Efficiency.learner,
    validityPeriod: 30.0,
    reliability: 74.0,
    lastUpdated: DateTime.now().subtract(Duration(days: 5)),
    tutorial: [
      mockTutorials[4],
      mockTutorials[5],
      mockTutorials[6],
      mockTutorials[7],
    ],
  ),
  Topic(
    title: 'Protección de Datos Personales',
    thumbnail:
        'https://minsur.testu.co/testu/mediadb/services/module/asset/generate/Web%20Content/Test%20Data%20for%20App/Ciberseguridad.png/image200x200.webp/CiberseguridadS.webp',
    completedTutorials: 3,
    efficiency: Efficiency.expert,
    validityPeriod: 30.0,
    reliability: 81.0,
    lastUpdated: DateTime.now().subtract(Duration(days: 3)),
    tutorial: [
      mockTutorials[0],
      mockTutorials[1],
      mockTutorials[2],
      mockTutorials[3],
    ],
  ),
  Topic(
    title: 'Primeros Auxilios',
    thumbnail:
        'https://minsur.testu.co/testu/mediadb/services/module/asset/generate/Web%20Content/Test%20Data%20for%20App/Humanos.png/image200x200.webp/HumanosS.webp',
    completedTutorials: 1,
    efficiency: Efficiency.beginner,
    validityPeriod: 30.0,
    reliability: 42.0,
    lastUpdated: DateTime.now().subtract(Duration(days: 10)),
    tutorial: [
      mockTutorials[4],
      mockTutorials[5],
      mockTutorials[6],
      mockTutorials[7],
    ],
  ),
  Topic(
    title: 'Salud y Bienestar Ocupacional',
    thumbnail:
        'https://minsur.testu.co/testu/mediadb/services/module/asset/generate/Web%20Content/Test%20Data%20for%20App/Ciberseguridad.png/image200x200.webp/CiberseguridadS.webp',
    completedTutorials: 2,
    efficiency: Efficiency.learner,
    validityPeriod: 30.0,
    reliability: 61.0,
    lastUpdated: DateTime.now().subtract(Duration(days: 4)),
    tutorial: [
      mockTutorials[0],
      mockTutorials[1],
      mockTutorials[2],
      mockTutorials[3],
    ],
  ),
  Topic(
    title: 'Liderazgo y Trabajo en Equipo',
    thumbnail:
        'https://minsur.testu.co/testu/mediadb/services/module/asset/generate/Web%20Content/Test%20Data%20for%20App/Humanos.png/image200x200.webp/HumanosS.webp',
    completedTutorials: 3,
    efficiency: Efficiency.expert,
    validityPeriod: 30.0,
    reliability: 85.0,
    lastUpdated: DateTime.now().subtract(Duration(days: 1)),
    tutorial: [
      mockTutorials[4],
      mockTutorials[5],
      mockTutorials[6],
      mockTutorials[7],
    ],
  ),
  Topic(
    title: 'Resolución de Conflictos',
    thumbnail:
        'https://minsur.testu.co/testu/mediadb/services/module/asset/generate/Web%20Content/Test%20Data%20for%20App/Ciberseguridad.png/image200x200.webp/CiberseguridadS.webp',
    completedTutorials: 2,
    efficiency: Efficiency.learner,
    validityPeriod: 30.0,
    reliability: 53.0,
    lastUpdated: DateTime.now().subtract(Duration(days: 8)),
    tutorial: [
      mockTutorials[0],
      mockTutorials[1],
      mockTutorials[2],
      mockTutorials[3],
    ],
  ),
];

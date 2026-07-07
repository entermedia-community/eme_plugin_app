import 'tutorial.dart';

class Topic {
  final String title;
  final String thumbnail;
  final int completedTutorials;
  final String efficiency;
  final int validityPeriod;
  final int expiresIn;
  final DateTime lastUpdated;
  final List<Tutorial> tutorial;

  const Topic({
    required this.title,
    required this.thumbnail,
    required this.completedTutorials,
    required this.efficiency,
    required this.validityPeriod,
    required this.expiresIn,
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
final List<Topic> mockTopics = [
  Topic(
    title: 'Introducción a la Ciberseguridad',
    thumbnail:
        'https://minsur.testu.co/testu/mediadb/services/module/asset/generate/Web%20Content/Test%20Data%20for%20App/Ciberseguridad.png/image200x200.webp/CiberseguridadS.webp',
    completedTutorials: 1,
    efficiency: 'Moderate',
    validityPeriod: 30,
    expiresIn: 7,
    lastUpdated: DateTime.now(),
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
    efficiency: 'Excelent',
    validityPeriod: 30,
    expiresIn: 29,
    lastUpdated: DateTime.now(),
    tutorial: [
      mockTutorials[4],
      mockTutorials[5],
      mockTutorials[6],
      mockTutorials[7],
    ],
  ),
];


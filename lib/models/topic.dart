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
];

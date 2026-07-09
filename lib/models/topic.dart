import 'dart:math';
import 'dart:typed_data';

import 'tutorial.dart';

enum Efficiency { beginner, competent, expert }

class Topic {
  final String title;
  final String thumbnail;
  final int completedTutorials;
  final double validityPeriod;
  final double reliability;
  final List<Tutorial> tutorial;

  const Topic({
    required this.title,
    required this.thumbnail,
    required this.completedTutorials,
    required this.validityPeriod,
    required this.reliability,
    required this.tutorial,
  });

  // Efficiency calculations
  TutorialProgress get progress {
    if (tutorial.isEmpty) {
      return TutorialProgress(
        beginnerProgress: 0,
        competentProgress: 0,
        expertProgress: 0,
      );
    }
    double beginnerProgress = 0;
    double competentProgress = 0;
    double expertProgress = 0;
    //
    for (var t in tutorial) {
      beginnerProgress += t.progress.beginnerProgress;
      competentProgress += t.progress.competentProgress;
      expertProgress += t.progress.expertProgress;
    }

    return TutorialProgress(
      beginnerProgress: beginnerProgress / tutorial.length,
      competentProgress: competentProgress / tutorial.length,
      expertProgress: expertProgress / tutorial.length,
    );
  }

  double get answersForgotten {
    if (tutorial.isEmpty) {
      return 0;
    }
    double answersForgotten = 0;
    for (var t in tutorial) {
      answersForgotten += t.answersForgotten;
    }
    return (answersForgotten / tutorial.length);
  }

  int get forgottenPeriod {
    int days = 0;
    for (var t in tutorial) {
      days = max(days, t.forgottenPeriod);
    }
    return days;
  }

  int get lastReviewedDays {
    int days = 0;
    for (var t in tutorial) {
      days = min(days, t.forgottenPeriod);
    }
    return days;
  }
}

// Mock topics grouping the original mockTutorials and adding additional detail tutorials
// Mock topics grouping the original mockTutorials and adding additional detail tutorials
final List<Topic> mockTopics = [
  Topic(
    title: 'Introducción a la Ciberseguridad',
    thumbnail:
        'https://eme.world/mediadb/services/module/asset/generated/Entity%20Assets/Ciberseguridad/Ciberseguridad.png/image200x200.webp',
    completedTutorials: 1,
    validityPeriod: 30.0,
    reliability: 7.0,
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
        'https://eme.world/mediadb/services/module/asset/generated/Entity%20Assets/Humanos/Humanos.png/image200x200.webp',
    completedTutorials: 2,

    validityPeriod: 30.0,
    reliability: 28.0,
    tutorial: [
      mockTutorials[4],
      mockTutorials[5],
      mockTutorials[6],
      mockTutorials[7],
    ],
  ),
];

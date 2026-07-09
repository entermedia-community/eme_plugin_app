import 'package:flutter/material.dart';
import 'package:testu_cl/models/topic.dart';

class TutorialProgress {
  final double beginnerProgress;
  final double competentProgress;
  final double expertProgress;

  TutorialProgress({
    required this.beginnerProgress,
    required this.competentProgress,
    required this.expertProgress,
  });

  double getAverageProgress() {
    return (beginnerProgress + competentProgress + expertProgress) / 3;
  }

  Efficiency getEfficiency() {
    double avg = getAverageProgress();
    if (avg < 0.5) return Efficiency.beginner;
    if (avg < 0.9) return Efficiency.competent;
    return Efficiency.expert;
  }

  Color getStatusColor() {
    if (getEfficiency() == Efficiency.beginner) {
      return const Color(0xFFF50057);
    } else if (getEfficiency() == Efficiency.competent) {
      return const Color(0xFF2196F3);
    } else {
      return const Color(0xFF38EF7D);
    }
  }
}

class Tutorial {
  final String title;
  final String category;
  final TutorialProgress progress;
  final double answersForgotten;
  final DateTime lastReviewed;

  Tutorial({
    required this.title,
    required this.category,
    required this.progress,
    required this.answersForgotten,
    required this.lastReviewed,
  });

  int get forgottenPeriod {
    final normalizedFrom = DateTime(
      lastReviewed.year,
      lastReviewed.month,
      lastReviewed.day,
    );
    final now = DateTime.now();
    final normalizedNow = DateTime(now.year, now.month, now.day);

    return normalizedNow.difference(normalizedFrom).inDays;
  }
}

// Mock Data
final List<Tutorial> mockTutorials = [
  // Ciberseguridad Tutorials (Indices 0 - 3)
  Tutorial(
    title: 'Conceptos Básicos de Ciberseguridad',
    category: 'Ciberseguridad',
    progress: TutorialProgress(
      beginnerProgress: 0.8,
      competentProgress: 0.7,
      expertProgress: 0.6,
    ),
    answersForgotten: 0.15,

    lastReviewed: DateTime.now(),
  ),
  Tutorial(
    title: 'Ingeniería Social y Phishing',
    category: 'Ciberseguridad',
    progress: TutorialProgress(
      beginnerProgress: 0.5,
      competentProgress: 0.2,
      expertProgress: 0.1,
    ),
    answersForgotten: 0.2,

    lastReviewed: DateTime.now(),
  ),
  Tutorial(
    title: 'Buenas Prácticas de Contraseñas',
    category: 'Ciberseguridad',

    progress: TutorialProgress(
      beginnerProgress: 1.0,
      competentProgress: 1.0,
      expertProgress: 1.0,
    ),
    answersForgotten: 0.30,

    lastReviewed: DateTime.now(),
  ),
  Tutorial(
    title: 'Seguridad en Dispositivos Móviles',
    category: 'Ciberseguridad',

    progress: TutorialProgress(
      beginnerProgress: 0.7,
      competentProgress: 0.5,
      expertProgress: 0.3,
    ),
    answersForgotten: 0.7,

    lastReviewed: DateTime.now(),
  ),

  // Derechos Humanos Tutorials (Indices 4 - 7)
  Tutorial(
    title: 'Fundamentos de los Derechos Humanos',
    category: 'Derechos Humanos',

    progress: TutorialProgress(
      beginnerProgress: 1.0,
      competentProgress: 1.0,
      expertProgress: 1.0,
    ),
    answersForgotten: 0.45,

    lastReviewed: DateTime.now(),
  ),
  Tutorial(
    title: 'Derechos Humanos en el Entorno Laboral',
    category: 'Derechos Humanos',

    progress: TutorialProgress(
      beginnerProgress: 0.8,
      competentProgress: 0.7,
      expertProgress: 0.6,
    ),
    answersForgotten: 0.12,

    lastReviewed: DateTime.now(),
  ),
  Tutorial(
    title: 'Diversidad, Equidad e Inclusión',
    category: 'Derechos Humanos',

    progress: TutorialProgress(
      beginnerProgress: 1.0,
      competentProgress: 1.0,
      expertProgress: 1.0,
    ),
    answersForgotten: 0.30,

    lastReviewed: DateTime.now(),
  ),
  Tutorial(
    title: 'Prevención del Acoso y Canales de Denuncia',
    category: 'Derechos Humanos',

    progress: TutorialProgress(
      beginnerProgress: 0.5,
      competentProgress: 0.4,
      expertProgress: 0.3,
    ),
    answersForgotten: 0.5,

    lastReviewed: DateTime.now(),
  ),
];

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

  factory TutorialProgress.fromJson(Map<String, dynamic> json) {
    return TutorialProgress(
      beginnerProgress: (json['beginnerprogress'] as num?)?.toDouble() ?? 0.0,
      competentProgress: (json['competentprogress'] as num?)?.toDouble() ?? 0.0,
      expertProgress: (json['expertprogress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'beginnerprogress': beginnerProgress,
      'competentprogress': competentProgress,
      'expertprogress': expertProgress,
    };
  }

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
  final String id;
  final String title;
  final String topicId;
  final double answersForgotten;
  final DateTime lastReviewed;

  final TutorialProgress progress;

  Tutorial({
    required this.id,
    required this.title,
    required this.topicId,
    required this.progress,
    required this.answersForgotten,
    required this.lastReviewed,
  });

  factory Tutorial.fromJson(Map<String, dynamic> json) {
    return Tutorial(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      topicId: json['entitytopicid'] as String? ?? '',
      progress: json['progress'] != null
          ? TutorialProgress.fromJson(json['progress'] as Map<String, dynamic>)
          : TutorialProgress(
              beginnerProgress: 0,
              competentProgress: 0,
              expertProgress: 0,
            ),
      answersForgotten: (json['answersforgotten'] as num?)?.toDouble() ?? 0.0,
      lastReviewed: json['lastreviewed'] != null
          ? DateTime.tryParse(json['lastreviewed'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'entitytopicid': topicId,
      'progress': progress.toJson(),
      'answersforgotten': answersForgotten,
      'lastreviewed': lastReviewed.toIso8601String(),
    };
  }

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

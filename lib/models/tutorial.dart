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

class McqQuestion {
  final String id;
  final String question;
  final Map<String, String> options;
  final String correctOption;
  final String cognitiveLevel;

  McqQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOption,
    required this.cognitiveLevel,
  });

  factory McqQuestion.fromJson(Map<String, dynamic> json) {
    final Map<String, String> opts = {};
    if (json['options'] is Map) {
      (json['options'] as Map).forEach((k, v) {
        opts[k.toString()] = v.toString();
      });
    } else if (json['options'] is List) {
      final list = json['options'] as List;
      for (int i = 0; i < list.length; i++) {
        opts['option_${String.fromCharCode(97 + i)}'] = list[i].toString();
      }
    }

    return McqQuestion(
      id: json['id'] as String? ?? '',
      question: json['question'] as String? ?? '',
      options: opts,
      correctOption:
          json['correctoption'] as String? ??
          json['correct_option'] as String? ??
          '',
      cognitiveLevel:
          json['cognitivelevel'] as String? ??
          json['cognitive_level'] as String? ??
          'beginner',
    );
  }

  List<String> get optionsList {
    if (options.isEmpty) return [];
    final keys = options.keys.toList()..sort();
    return keys.map((k) => options[k]!).toList();
  }

  int get correctAnswerIndex {
    final keys = options.keys.toList()..sort();
    final targetKey = correctOption.toLowerCase().trim();

    int index = keys.indexOf(targetKey);
    if (index != -1) return index;

    if (targetKey.length == 1) {
      final fullKey = 'option_$targetKey';
      index = keys.indexOf(fullKey);
      if (index != -1) return index;
    }

    return 0;
  }

  String get difficultyDisplay {
    if (cognitiveLevel.isEmpty) return 'Beginner';
    return cognitiveLevel[0].toUpperCase() + cognitiveLevel.substring(1);
  }
}

class TutorialContent {
  final String id;
  final String content;
  final String assetUrl;
  final String contentType;
  final String contentRole;
  final McqQuestion? question;

  TutorialContent({
    required this.id,
    required this.content,
    required this.assetUrl,
    required this.contentType,
    required this.contentRole,
    this.question,
  });

  bool get isMcq => contentType.toLowerCase() == 'mcq';
  bool get isAsset => contentType.toLowerCase() == 'asset';
  bool get isText => !isMcq && !isAsset;

  factory TutorialContent.fromJson(Map<String, dynamic> json) {
    return TutorialContent(
      id: json['id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      assetUrl: json['asseturl'] as String? ?? '',
      contentType:
          json['contenttype'] as String? ??
          json['content_type'] as String? ??
          '',
      contentRole:
          json['contentrole'] as String? ??
          json['content_role'] as String? ??
          '',
      question:
          json['question'] != null && json['question'] is Map<String, dynamic>
          ? McqQuestion.fromJson(json['question'] as Map<String, dynamic>)
          : null,
    );
  }
}

class TutorialSection {
  final String id;
  final String title;
  final List<TutorialContent> contents;

  TutorialSection({
    required this.id,
    required this.title,
    required this.contents,
  });

  factory TutorialSection.fromJson(Map<String, dynamic> json) {
    final rawContents = json['contents'] as List<dynamic>? ?? [];
    final list = rawContents
        .map((item) => TutorialContent.fromJson(item as Map<String, dynamic>))
        .toList();

    return TutorialSection(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      contents: list,
    );
  }

  /// Merges consecutive text components in this section into single TutorialContent items.
  List<TutorialContent> getMergedContents() {
    final List<TutorialContent> merged = [];
    StringBuffer? textBuffer;
    List<String> ids = [];

    void flushTextBuffer() {
      if (textBuffer != null && textBuffer!.isNotEmpty) {
        merged.add(
          TutorialContent(
            id: ids.join('_'),
            content: textBuffer!.toString(),
            assetUrl: '',
            contentType: 'merged_text',
            contentRole: '',
          ),
        );
        textBuffer = null;
        ids = [];
      }
    }

    for (final item in contents) {
      if (item.isText) {
        String content = item.content;
        if (item.contentType == "heading") {
          content = "<h1>$content</h1>";
        }
        textBuffer ??= StringBuffer();
        if (textBuffer!.isNotEmpty) {
          textBuffer!.write('\n');
        }
        textBuffer!.write(content);
        ids.add(item.id);
      } else {
        flushTextBuffer();
        merged.add(item);
      }
    }

    flushTextBuffer();
    return merged;
  }
}

class TutorialDetail {
  final List<TutorialSection> sections;

  TutorialDetail({required this.sections});

  factory TutorialDetail.fromJson(Map<String, dynamic> json) {
    final rawSections = json['sections'] as List<dynamic>? ?? [];
    return TutorialDetail(
      sections: rawSections
          .map((item) => TutorialSection.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RehearseQuestion {
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  final String difficulty; // "Beginner", "Intermediate", "Expert"
  final String? sectionTitle;
  final String? sectionContentText;

  const RehearseQuestion({
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    required this.difficulty,
    this.sectionTitle,
    this.sectionContentText,
  });

  factory RehearseQuestion.fromMcq(
    McqQuestion mcq, {
    String? sectionTitle,
    String? sectionContentText,
  }) {
    return RehearseQuestion(
      text: mcq.question,
      options: mcq.optionsList,
      correctAnswerIndex: mcq.correctAnswerIndex,
      difficulty: mcq.difficultyDisplay,
      sectionTitle: sectionTitle,
      sectionContentText: sectionContentText,
    );
  }
}

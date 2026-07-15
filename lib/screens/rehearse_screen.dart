import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:testu_cl/models/topic.dart';
import 'package:testu_cl/services/topic_service.dart';
import 'package:testu_cl/widgets/common_widgets.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/tutorial.dart';

List<RehearseQuestion> getQuestionsForTutorial(Tutorial tutorial) {
  return [
    const RehearseQuestion(
      text:
          "According to the new OSHA standards, what is the primary requirement for employers regarding incident energy?",
      options: [
        "To rely solely on general language for hazard-free workplaces",
        "To allow contractors to decide on implementation methods without employer oversight",
        "To perform estimations for incident energy through an arc flash study",
        "To eliminate the need for specific regulations in electrical power generation",
      ],
      correctAnswerIndex: 2,
      difficulty: "Beginner",
    ),
  ];
}

class ChatMessage {
  final String sender; // 'ai' or 'user'
  final String text;
  final DateTime timestamp;
  final String messageType; //text, image, video, audio, question, answer, explanation, learn_more_content
  final String? sectionTitle;
  final String? sectionContentText;
  bool isLearnedMoreExpanded;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.messageType,
    this.sectionTitle,
    this.sectionContentText,
    this.isLearnedMoreExpanded = false,
  }) : timestamp = DateTime.now();
}

class RehearseScreen extends StatefulWidget {
  final Tutorial tutorial;

  const RehearseScreen({super.key, required this.tutorial});

  @override
  State<RehearseScreen> createState() => _RehearseScreenState();
}

class _RehearseScreenState extends State<RehearseScreen> {
  bool _isLoading = true;
  List<RehearseQuestion> _questions = [];

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _followUpController = TextEditingController();

  int _currentIndex = 0;
  bool _isFinished = false;

  // Track user selections
  // Map index -> selected option index
  final Map<int, int?> _selectedAnswers = {};
  // Map index -> confidence level string ("No Idea", "Not sure", "Mostly Sure", "Confident")
  final Map<int, String?> _confidenceLevels = {};

  final List<String> _confidenceOptions = [
    'No Idea',
    'Not sure',
    'Mostly Sure',
    'Confident',
  ];

  // Chat state
  final List<ChatMessage> _messages = [];
  int? _tempSelectedAnswerIndex;
  String? _tempConfidenceLevel;
  String _stage = 'question_asked';

  @override
  void initState() {
    super.initState();
    _loadTutorialDetail();
  }

  Future<void> _loadTutorialDetail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final detail =
          await TopicService().fetchTutorialDetail(widget.tutorial.id);

      final List<RehearseQuestion> parsedQuestions = [];
      _messages.clear();

      for (final section in detail.sections) {
        // Collect text and assets for this section to reveal on "Learn More"
        final StringBuffer sectionContentBuffer = StringBuffer();
        final mergedContents = section.getMergedContents();
        for (final item in mergedContents) {
          if (item.isText && item.content.isNotEmpty) {
            if (sectionContentBuffer.isNotEmpty) {
              sectionContentBuffer.write("\n\n");
            }
            sectionContentBuffer.write(item.content);
          } else if (item.isAsset && item.content.isNotEmpty) {
            if (sectionContentBuffer.isNotEmpty) {
              sectionContentBuffer.write("\n\n");
            }
            sectionContentBuffer.write(item.content);
          }
        }

        final sectionText = sectionContentBuffer.toString();

        for (final item in section.contents) {
          if (item.isMcq && item.question != null) {
            parsedQuestions.add(
              RehearseQuestion.fromMcq(
                item.question!,
                sectionTitle: section.title.isNotEmpty ? section.title : null,
                sectionContentText:
                    sectionText.isNotEmpty ? sectionText : null,
              ),
            );
          }
        }
      }

      if (parsedQuestions.isEmpty) {
        parsedQuestions.addAll(getQuestionsForTutorial(widget.tutorial));
      }

      setState(() {
        _questions = parsedQuestions;
        _isLoading = false;
        if (_questions.isNotEmpty) {
          final firstQ = _questions[0];
          final String titleHeader =
              (firstQ.sectionTitle != null && firstQ.sectionTitle!.isNotEmpty)
              ? "📌 **${firstQ.sectionTitle}**\n\n"
              : "";
          _messages.add(
            ChatMessage(
              sender: 'ai',
              text:
                  "${titleHeader}Here is your question:\n\n**Question 1 (${firstQ.difficulty})**:\n${firstQ.text}",
              messageType: 'question',
            ),
          );
        }
      });
    } catch (e) {
      final fallbackQuestions = getQuestionsForTutorial(widget.tutorial);
      setState(() {
        _questions = fallbackQuestions;
        _isLoading = false;
        _initializeChat();
      });
    }
  }

  void _initializeChat() {
    _messages.clear();
    if (_questions.isNotEmpty) {
      _messages.add(
        ChatMessage(
          sender: 'ai',
          text:
              "Hello! Let's practice. Here is your first question:\n\n**Question 1 (${_questions[0].difficulty})**:\n${_questions[0].text}",
          messageType: 'question',
        ),
      );
    }
  }

  String _getExplanationForQuestion(RehearseQuestion question) {
    return "Great job reviewing this question! The correct answer choice is: '${question.options[question.correctAnswerIndex]}'.";
  }

  String _getFollowUpForQuestion(RehearseQuestion question, String userQuery) {
    return "Regarding '${question.text}': $userQuery\n\nNote: Always adhere to relevant guidelines and domain standards.";
  }


  @override
  void dispose() {
    _scrollController.dispose();
    _followUpController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Color _getConfidenceColor(String confidence) {
    switch (confidence) {
      case 'No Idea':
        return const Color(0xFFF50057); // Soft red
      case 'Not sure':
        return const Color(0xFFFF9F43); // Orange
      case 'Mostly Sure':
        return const Color(0xFF38B6FF); // Light blue
      case 'Confident':
        return const Color(0xFF38EF7D); // Vibrant green
      default:
        return Colors.white54;
    }
  }

  void _selectOption(int optIndex) {
    setState(() {
      _tempSelectedAnswerIndex = optIndex;
    });
  }

  void _selectConfidence(String confidence) {
    setState(() {
      _tempConfidenceLevel = confidence;
    });
  }

  void _submitAnswer() {
    if (_tempSelectedAnswerIndex == null || _tempConfidenceLevel == null) {
      return;
    }

    final activeQuestion = _questions[_currentIndex];
    final selectedOptionText =
        activeQuestion.options[_tempSelectedAnswerIndex!];
    final confidence = _tempConfidenceLevel!;

    setState(() {
      _selectedAnswers[_currentIndex] = _tempSelectedAnswerIndex;
      _confidenceLevels[_currentIndex] = confidence;

      // Add user selection message
      _messages.add(
        ChatMessage(
          sender: 'user',
          text:
              "I select: **$selectedOptionText**\nConfidence level: **$confidence**",
          messageType: 'answer',
        ),
      );

      // Generate AI explanation
      final isCorrect =
          _tempSelectedAnswerIndex == activeQuestion.correctAnswerIndex;
      final correctText = isCorrect ? "Correct! 🎉" : "Incorrect.";
      final explanationText = _getExplanationForQuestion(activeQuestion);

      final aiText = isCorrect
          ? "**$correctText**\n\n$explanationText"
          : "**$correctText** The correct answer is **${activeQuestion.options[activeQuestion.correctAnswerIndex]}**.\n\n$explanationText";

      _messages.add(
        ChatMessage(
          sender: 'ai',
          text: aiText,
          messageType: 'explanation',
          sectionTitle: activeQuestion.sectionTitle,
          sectionContentText: activeQuestion.sectionContentText,
        ),
      );

      _stage = 'explain_and_followup';
    });
    _scrollToBottom();
  }

  void _sendFollowUp() {
    final text = _followUpController.text.trim();
    if (text.isEmpty) return;
    _followUpController.clear();

    setState(() {
      _messages.add(
        ChatMessage(sender: 'user', text: text, messageType: 'follow_up'),
      );
    });
    _scrollToBottom();

    // Simulate AI typing delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        final answer = _getFollowUpForQuestion(_questions[_currentIndex], text);
        _messages.add(
          ChatMessage(
            sender: 'ai',
            text: answer,
            messageType: 'follow_up_reply',
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _tempSelectedAnswerIndex = null;
        _tempConfidenceLevel = null;
        _stage = 'question_asked';

        final nextQ = _questions[_currentIndex];
        final String titleHeader =
            (nextQ.sectionTitle != null && nextQ.sectionTitle!.isNotEmpty)
            ? "📌 **${nextQ.sectionTitle}**\n\n"
            : "";

        _messages.add(
          ChatMessage(
            sender: 'ai',
            text:
                "${titleHeader}Moving on to the next question:\n\n**Question ${_currentIndex + 1} (${nextQ.difficulty})**:\n${nextQ.text}",
            messageType: 'question',
          ),
        );
      });
      _scrollToBottom();
    } else {
      // Validate that all questions have selected answers (should be true in this flow)
      bool allAnswered = true;
      for (int i = 0; i < _questions.length; i++) {
        if (_selectedAnswers[i] == null) {
          allAnswered = false;
          break;
        }
      }

      if (!allAnswered) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFFF50057),
            content: const Text(
              'Please answer all questions before finishing.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return;
      }

      setState(() {
        _isFinished = true;
      });
    }
  }

  // Dynamic Metrics Functions
  // int _getBeginnerTotal() =>
  //     _questions.where((q) => q.difficulty == 'Beginner').length;
  // int _getIntermediateTotal() =>
  //     _questions.where((q) => q.difficulty == 'Intermediate').length;
  // int _getExpertTotal() =>
  //     _questions.where((q) => q.difficulty == 'Expert').length;

  // int _getBeginnerCorrect() {
  //   int count = 0;
  //   _selectedAnswers.forEach((index, userSelect) {
  //     if (index < _questions.length &&
  //         _questions[index].difficulty == 'Beginner') {
  //       if (userSelect == _questions[index].correctAnswerIndex) {
  //         count++;
  //       }
  //     }
  //   });
  //   return count;
  // }

  // int _getIntermediateCorrect() {
  //   int count = 0;
  //   _selectedAnswers.forEach((index, userSelect) {
  //     if (index < _questions.length &&
  //         _questions[index].difficulty == 'Intermediate') {
  //       if (userSelect == _questions[index].correctAnswerIndex) {
  //         count++;
  //       }
  //     }
  //   });
  //   return count;
  // }

  // int _getExpertCorrect() {
  //   int count = 0;
  //   _selectedAnswers.forEach((index, userSelect) {
  //     if (index < _questions.length &&
  //         _questions[index].difficulty == 'Expert') {
  //       if (userSelect == _questions[index].correctAnswerIndex) {
  //         count++;
  //       }
  //     }
  //   });
  //   return count;
  // }

  double _calculateScorePercentage() {
    int correctCount = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i].correctAnswerIndex) {
        correctCount++;
      }
    }
    return correctCount / _questions.length;
  }

  int _calculateCorrectCount() {
    int correctCount = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i].correctAnswerIndex) {
        correctCount++;
      }
    }
    return correctCount;
  }

  double _calculateAverageConfidence() {
    if (_confidenceLevels.isEmpty) return 0.0;
    double totalWeight = 0;
    int count = 0;
    _confidenceLevels.forEach((key, val) {
      if (val != null) {
        count++;
        if (val == 'No Idea') totalWeight += 0.25;
        if (val == 'Not sure') totalWeight += 0.50;
        if (val == 'Mostly Sure') totalWeight += 0.75;
        if (val == 'Confident') totalWeight += 1.0;
      }
    });
    return count > 0 ? (totalWeight / count) : 0.0;
  }

  String _getConfidenceTextFromScore(double score) {
    if (score < 0.35) return 'Low Confidence';
    if (score < 0.65) return 'Moderate Confidence';
    if (score < 0.85) return 'High Confidence';
    return 'Strong Confidence';
  }

  Widget _buildRichText(String text, TextStyle baseStyle) {
    String processed = text;

    // Convert common HTML block/line tags
    processed = processed
        .replaceAll(RegExp(r'</p\s*>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</li\s*>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<li\s*>', caseSensitive: false), '• ')
        .replaceAll(RegExp(r'</?h[1-6]\s*>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</?(div|ul|ol|p)\s*>', caseSensitive: false), '')
        .replaceAll(RegExp(r'</?(strong|b)\s*>', caseSensitive: false), '**')
        .replaceAll(RegExp(r'<[^>]*>'), '');

    final List<TextSpan> spans = [];
    final RegExp regExp = RegExp(r'\*\*(.*?)\*\*');
    int lastMatchEnd = 0;

    for (final Match match in regExp.allMatches(processed)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: processed.substring(lastMatchEnd, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(1),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < processed.length) {
      spans.add(TextSpan(text: processed.substring(lastMatchEnd)));
    }

    return RichText(
      text: TextSpan(children: spans, style: baseStyle),
    );
  }

  void _showLearnMoreModal(BuildContext context, String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF161C24),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modal top handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    color: Color(0xFF38B6FF),
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title.isNotEmpty ? title : 'Section Material',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white54,
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(8),
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white10, height: 24),
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildRichText(
                      content,
                      const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomPanel(RehearseQuestion question) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF11161D),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_stage == 'question_asked') ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _followUpController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      onSubmitted: (_) => _sendFollowUp(),
                      decoration: InputDecoration(
                        hintText: 'Need any explanation?',
                        hintStyle: const TextStyle(
                          color: Colors.white38,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.04),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.08),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.08),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: const Color(0xFFF27121),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sendFollowUp,
                    icon: const Icon(Icons.send_rounded),
                    color: const Color(0xFFF27121),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.04),
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (_stage == 'select_option') ...[
              const Padding(
                padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
                child: Text(
                  'SELECT YOUR ANSWER',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white38,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              ...List.generate(question.options.length, (optIndex) {
                final optionText = question.options[optIndex];
                final optionLetters = ['A', 'B', 'C', 'D'];
                final isSelected = _tempSelectedAnswerIndex == optIndex;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: InkWell(
                    onTap: () => _selectOption(optIndex),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFF27121).withValues(alpha: 0.15)
                            : const Color(0xFF161C24).withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFF27121)
                              : Colors.white.withValues(alpha: 0.06),
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? const Color(
                                      0xFFF27121,
                                    ).withValues(alpha: 0.2)
                                  : Colors.white.withValues(alpha: 0.05),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(
                                        0xFFF27121,
                                      ).withValues(alpha: 0.4)
                                    : Colors.white.withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              optionLetters[optIndex],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? const Color(0xFFF27121)
                                    : Colors.white60,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              optionText,
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white70,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
                child: Text(
                  'HOW CONFIDENT ARE YOU IN THIS ANSWER?',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white38,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              Row(
                children: _confidenceOptions.map((confidence) {
                  final color = _getConfidenceColor(confidence);
                  final isSelected = _tempConfidenceLevel == confidence;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: InkWell(
                        onTap: () => _selectConfidence(confidence),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withValues(alpha: 0.25)
                                : const Color(
                                    0xFF161C24,
                                  ).withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? color
                                  : Colors.white.withValues(alpha: 0.05),
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            confidence,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color:
                      (_tempSelectedAnswerIndex != null &&
                          _tempConfidenceLevel != null)
                      ? const Color(0xFFF27121)
                      : const Color(0xFF161C24).withValues(alpha: 0.4),
                  boxShadow:
                      (_tempSelectedAnswerIndex != null &&
                          _tempConfidenceLevel != null)
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFFF27121,
                            ).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                  border:
                      (_tempSelectedAnswerIndex != null &&
                          _tempConfidenceLevel != null)
                      ? null
                      : Border.all(
                          color: Colors.white.withValues(alpha: 0.06),
                          width: 1.5,
                        ),
                ),
                child: ElevatedButton(
                  onPressed:
                      (_tempSelectedAnswerIndex != null &&
                          _tempConfidenceLevel != null)
                      ? _submitAnswer
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Submit Answer',
                        style: TextStyle(
                          color:
                              (_tempSelectedAnswerIndex != null &&
                                  _tempConfidenceLevel != null)
                              ? Colors.white
                              : Colors.white30,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.send_rounded,
                        size: 16,
                        color:
                            (_tempSelectedAnswerIndex != null &&
                                _tempConfidenceLevel != null)
                            ? Colors.white
                            : Colors.white30,
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (_stage == 'explain_and_followup') ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _followUpController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      onSubmitted: (_) => _sendFollowUp(),
                      decoration: InputDecoration(
                        hintText: 'Ask a follow-up question...',
                        hintStyle: const TextStyle(
                          color: Colors.white38,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.04),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.08),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.08),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: const Color(0xFFF27121),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sendFollowUp,
                    icon: const Icon(Icons.send_rounded),
                    color: const Color(0xFFF27121),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.04),
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xFFF27121),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF27121).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentIndex == _questions.length - 1
                            ? 'Finish Rehearsal'
                            : 'Next Question',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _currentIndex == _questions.length - 1
                            ? Icons.check_circle_outline_rounded
                            : Icons.arrow_forward_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuizView() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFF27121)),
            SizedBox(height: 16),
            Text(
              'Loading tutorial questions...',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_questions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, color: Colors.white54, size: 48),
            const SizedBox(height: 16),
            const Text(
              'No rehearsal questions available for this tutorial.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF27121),
              ),
              child: const Text('Go Back', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    final activeQuestion = _questions[_currentIndex];

    // Compute dynamic session metrics
    // final easyTotal = _getBeginnerTotal();
    // final easyCorrect = _getBeginnerCorrect();
    // final intTotal = _getIntermediateTotal();
    // final intCorrect = _getIntermediateCorrect();
    // final advTotal = _getExpertTotal();
    // final advCorrect = _getExpertCorrect();

    return Column(
      children: [
        // Premium custom AppBar header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.04),
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tutorial.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        CommonWidgets.buildProgressColumn(
                          widget.tutorial.progress,
                          Efficiency.beginner,
                        ),
                        const SizedBox(width: 24),
                        CommonWidgets.buildProgressColumn(
                          widget.tutorial.progress,
                          Efficiency.competent,
                        ),
                        const SizedBox(width: 24),
                        CommonWidgets.buildProgressColumn(
                          widget.tutorial.progress,
                          Efficiency.expert,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // // Progress bar indicators
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        //   child: Column(
        //     children: [
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Text(
        //             'Question ${_currentIndex + 1} of ${_questions.length}',
        //             style: const TextStyle(
        //               color: Colors.white70,
        //               fontWeight: FontWeight.bold,
        //               fontSize: 13,
        //             ),
        //           ),
        //           Text(
        //             '${(progress * 100).toInt()}% Complete',
        //             style: TextStyle(
        //               color: Colors.white.withValues(alpha: 0.4),
        //               fontWeight: FontWeight.bold,
        //               fontSize: 11,
        //             ),
        //           ),
        //         ],
        //       ),
        //       const SizedBox(height: 8),
        //       ClipRRect(
        //         borderRadius: BorderRadius.circular(8),
        //         child: LinearProgressIndicator(
        //           value: progress,
        //           minHeight: 8,
        //           backgroundColor: Colors.white.withValues(alpha: 0.04),
        //           valueColor: AlwaysStoppedAnimation<Color>(
        //             const Color(0xFFF27121),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        // Chat Conversation Log Area
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(24.0),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              final isAI = message.sender == 'ai';
              final isLast = index == _messages.length - 1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: isAI
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: [
                    if (isAI) ...[
                      Container(
                        width: 32,
                        height: 32,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFFFFF).withValues(alpha: 0.2),
                          border: Border.all(
                            color: const Color(
                              0xFFFFFFFF,
                            ).withValues(alpha: 0.4),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image:
                              "https://eme.world/mediadb/services/module/asset/generated/Entity%20Assets/ai/ai.png/image200x200.webp",
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isAI
                              ? const Color(0xFF161C24).withValues(alpha: 0.8)
                              : const Color(0xFFF27121).withValues(alpha: 0.15),
                          borderRadius: isAI
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                )
                              : const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(4),
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                          border: Border.all(
                            color: isAI
                                ? Colors.white.withValues(alpha: 0.06)
                                : const Color(
                                    0xFFF27121,
                                  ).withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRichText(
                              message.text,
                              TextStyle(
                                fontSize: 14,
                                color: isAI
                                    ? Colors.white.withValues(alpha: 0.85)
                                    : Colors.white,
                                height: 1.4,
                              ),
                            ),
                            if (message.messageType == 'explanation' &&
                                message.sectionContentText != null &&
                                message.sectionContentText!.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                onPressed: () {
                                  final secTitle =
                                      (message.sectionTitle != null &&
                                              message.sectionTitle!.isNotEmpty)
                                      ? message.sectionTitle!
                                      : "Section Notes";
                                  _showLearnMoreModal(
                                    context,
                                    secTitle,
                                    message.sectionContentText!,
                                  );
                                },
                                icon: const Icon(
                                  Icons.menu_book_rounded,
                                  size: 16,
                                  color: Color(0xFF38B6FF),
                                ),
                                label: const Text(
                                  'Learn More',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF38B6FF),
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: const Color(
                                      0xFF38B6FF,
                                    ).withValues(alpha: 0.4),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                            if (isLast &&
                                message.messageType == 'question' &&
                                _stage != 'select_option') ...[
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _stage = 'select_option';
                                      _scrollToBottom();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF27121),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Answer',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (!isAI) ...[
                      const SizedBox(width: 12),
                      Container(
                        width: 32,
                        height: 32,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFFFFF).withValues(alpha: 0.2),
                          border: Border.all(
                            color: const Color(
                              0xFFFFFFFF,
                            ).withValues(alpha: 0.4),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image:
                              "https://eme.world/mediadb/services/module/asset/generated/Entity%20Assets/profile/placeholder.jpg/image200x200.webp",
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),

        // Bottom input/selection panel
        _buildBottomPanel(activeQuestion),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 700;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B0F13), Color(0xFF141923), Color(0xFF0F1319)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              width: min(680, size.width),
              color: Colors.white.withValues(alpha: 0.02),
              child: Stack(
                children: [
                  // Glowing background patterns
                  Positioned(
                    top: -size.height * 0.1,
                    right: -size.width * 0.2,
                    child: Container(
                      width: size.width * 0.7,
                      height: size.width * 0.7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF27121).withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -size.height * 0.1,
                    left: -size.width * 0.2,
                    child: Container(
                      width: size.width * 0.7,
                      height: size.width * 0.7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF27121).withValues(alpha: 0.06),
                      ),
                    ),
                  ),

                  // Main content layout
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isDesktop ? 680 : double.infinity,
                      ),
                      child: _isFinished
                          ? _buildResultsView()
                          : _buildQuizView(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsView() {
    final scorePct = _calculateScorePercentage();
    final correctCount = _calculateCorrectCount();
    final avgConf = _calculateAverageConfidence();
    final confText = _getConfidenceTextFromScore(avgConf);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Header Title
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF38EF7D).withValues(alpha: 0.1),
                ),
                padding: const EdgeInsets.all(16),
                child: const Icon(
                  Icons.stars_rounded,
                  color: Color(0xFF38EF7D),
                  size: 64,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Rehearsal Completed!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                widget.tutorial.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white38,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Score and Confidence Overview Cards
            Row(
              children: [
                // Score Gauge Card
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF161C24).withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text(
                              'ACCURACY',
                              style: TextStyle(
                                color: Colors.white38,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CircularProgressIndicator(
                                    value: scorePct,
                                    strokeWidth: 6,
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.04,
                                    ),
                                    color: scorePct > 0.7
                                        ? const Color(0xFF38EF7D)
                                        : scorePct > 0.4
                                        ? const Color(0xFFFF9F43)
                                        : const Color(0xFFF50057),
                                  ),
                                ),
                                Text(
                                  '$correctCount / ${_questions.length}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${(scorePct * 100).toInt()}% Correct',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: scorePct > 0.7
                                    ? const Color(0xFF38EF7D)
                                    : scorePct > 0.4
                                    ? const Color(0xFFFF9F43)
                                    : const Color(0xFFF50057),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Average Confidence Card
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF161C24).withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text(
                              'CONFIDENCE',
                              style: TextStyle(
                                color: Colors.white38,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CircularProgressIndicator(
                                    value: avgConf,
                                    strokeWidth: 6,
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.04,
                                    ),
                                    color: const Color(0xFF38B6FF),
                                  ),
                                ),
                                Text(
                                  '${(avgConf * 100).toInt()}%',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              confText,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF38B6FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Detailed Breakdown header
            const Text(
              'QUESTION BREAKDOWN',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white38,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),

            // Questions list review
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                final userSelect = _selectedAnswers[index];
                final isCorrect = userSelect == question.correctAnswerIndex;
                final confidence = _confidenceLevels[index] ?? 'No Idea';
                final confidenceColor = _getConfidenceColor(confidence);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF161C24).withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Question Number & Status icon
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCorrect
                                    ? const Color(
                                        0xFF38EF7D,
                                      ).withValues(alpha: 0.15)
                                    : const Color(
                                        0xFFF50057,
                                      ).withValues(alpha: 0.15),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                isCorrect
                                    ? Icons.check_rounded
                                    : Icons.close_rounded,
                                color: isCorrect
                                    ? const Color(0xFF38EF7D)
                                    : const Color(0xFFF50057),
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Question ${index + 1}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white38,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              question.difficulty == 'Beginner'
                                              ? const Color(
                                                  0xFF38EF7D,
                                                ).withValues(alpha: 0.15)
                                              : question.difficulty ==
                                                    'Intermediate'
                                              ? const Color(
                                                  0xFFFF9F43,
                                                ).withValues(alpha: 0.15)
                                              : const Color(
                                                  0xFFF50057,
                                                ).withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          question.difficulty.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                question.difficulty ==
                                                    'Beginner'
                                                ? const Color(0xFF38EF7D)
                                                : question.difficulty ==
                                                      'Intermediate'
                                                ? const Color(0xFFFF9F43)
                                                : const Color(0xFFF50057),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    question.text,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24, color: Colors.white10),
                        // Answer selections details
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Your Answer',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white38,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    userSelect != null
                                        ? question.options[userSelect]
                                        : 'None',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isCorrect
                                          ? const Color(0xFF38EF7D)
                                          : const Color(0xFFF50057),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!isCorrect) ...[
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Correct Answer',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white38,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      question.options[question
                                          .correctAnswerIndex],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF38EF7D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(width: 8),
                            // Confidence Indicator
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Confidence',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white38,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  decoration: BoxDecoration(
                                    color: confidenceColor.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: confidenceColor.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    confidence,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: confidenceColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Back to Dashboard / Retry Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedAnswers.clear();
                        _confidenceLevels.clear();
                        _currentIndex = 0;
                        _isFinished = false;
                        _messages.clear();
                        _tempSelectedAnswerIndex = null;
                        _tempConfidenceLevel = null;
                        _stage = 'select_option';
                        _initializeChat();
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: const Color(0xFFF27121),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Finish Review',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

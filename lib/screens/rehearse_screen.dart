import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/course.dart';

class RehearseQuestion {
  final String text;
  final List<String> options;
  final int correctAnswerIndex;

  const RehearseQuestion({
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
  });
}

List<RehearseQuestion> getQuestionsForCourse(Course course) {
  if (course.category.contains('MATEMÁTICA') || course.title.contains('MATHEMATICAL')) {
    return [
      const RehearseQuestion(
        text: 'What is the vertex of the parabola defined by f(x) = x² - 4x + 5?',
        options: [
          '(2, 1)',
          '(2, 5)',
          '(4, 5)',
          '(-2, 17)',
        ],
        correctAnswerIndex: 0,
      ),
      const RehearseQuestion(
        text: 'A box contains 5 red balls and 3 blue balls. If two balls are drawn without replacement, what is the probability that both are blue?',
        options: [
          '3/28',
          '9/64',
          '15/56',
          '3/8',
        ],
        correctAnswerIndex: 0,
      ),
      const RehearseQuestion(
        text: 'If log₂(x) + log₂(x - 2) = 3, what is the value of x?',
        options: [
          '4',
          '2',
          '8',
          '-2',
        ],
        correctAnswerIndex: 0,
      ),
      const RehearseQuestion(
        text: 'What is the sum of the interior angles of a regular hexagon?',
        options: [
          '720°',
          '540°',
          '180°',
          '1080°',
        ],
        correctAnswerIndex: 0,
      ),
    ];
  } else if (course.category.contains('CIENCIAS') || course.title.contains('PHYSICS')) {
    return [
      const RehearseQuestion(
        text: 'A car accelerates from rest at a constant rate of 2.0 m/s². How far does it travel in the first 5 seconds?',
        options: [
          '25 m',
          '10 m',
          '50 m',
          '5 m',
        ],
        correctAnswerIndex: 0,
      ),
      const RehearseQuestion(
        text: 'Which of the following colors of visible light has the shortest wavelength?',
        options: [
          'Violet',
          'Red',
          'Green',
          'Blue',
        ],
        correctAnswerIndex: 0,
      ),
      const RehearseQuestion(
        text: 'An object is placed 10 cm in front of a concave mirror with a focal length of 15 cm. The image formed is:',
        options: [
          'Virtual, upright, and magnified',
          'Real, inverted, and magnified',
          'Real, inverted, and diminished',
          'Virtual, upright, and diminished',
        ],
        correctAnswerIndex: 0,
      ),
      const RehearseQuestion(
        text: 'According to Kepler\'s Third Law, the square of the orbital period of a planet is directly proportional to:',
        options: [
          'The cube of the semi-major axis of its orbit',
          'The mass of the planet',
          'The square of the semi-major axis of its orbit',
          'The average distance to the nearest planet',
        ],
        correctAnswerIndex: 0,
      ),
    ];
  } else if (course.category.contains('LENGUAJE') || course.title.contains('LANGUAGE')) {
    return [
      const RehearseQuestion(
        text: 'Which of the following best describes the main purpose of an expository text?',
        options: [
          'To explain, inform, or describe a specific topic',
          'To persuade the reader to adopt a certain point of view',
          'To entertain through storytelling and poetic language',
          'To criticize a public figure or institution',
        ],
        correctAnswerIndex: 0,
      ),
      const RehearseQuestion(
        text: 'Identify the tone of the author: "Despite the devastating loss, the team showed remarkable resilience, immediately planning their next steps for improvement."',
        options: [
          'Optimistic and encouraging',
          'Sarcastic and critical',
          'Apathetic and indifferent',
          'Melancholic and hopeless',
        ],
        correctAnswerIndex: 0,
      ),
      const RehearseQuestion(
        text: 'What is the main function of a thesis statement in an argumentative essay?',
        options: [
          'To present the central argument or claim of the essay',
          'To summarize the concluding remarks of the author',
          'To provide statistical evidence supporting the data',
          'To list the bibliography and sources cited',
        ],
        correctAnswerIndex: 0,
      ),
      const RehearseQuestion(
        text: 'In reading comprehension, what is "implicit information"?',
        options: [
          'Information that is not stated directly but can be inferred from clues',
          'Information written clearly in the text',
          'Information that has no relevance to the main theme',
          'The list of characters and settings mentioned',
        ],
        correctAnswerIndex: 0,
      ),
    ];
  } else {
    // Default / History
    return [
      const RehearseQuestion(
        text: 'What was the main cause of the French Revolution of 1789?',
        options: [
          'Economic crisis, social inequality, and Enlightenment ideas',
          'The invasion of France by the Spanish Empire',
          'The discovery of new trade routes to Asia',
          'The decline of the Catholic Church\'s influence in Italy',
        ],
        correctAnswerIndex: 0,
      ),
      const RehearseQuestion(
        text: 'Which process describes the movement of people from rural areas to cities during the Industrial Revolution?',
        options: [
          'Urbanization',
          'Colonization',
          'Industrialization',
          'Globalization',
        ],
        correctAnswerIndex: 0,
      ),
      const RehearseQuestion(
        text: 'What was the main goal of the United Nations when it was founded in 1945?',
        options: [
          'To maintain international peace and security',
          'To establish a single global currency',
          'To control the production of oil and natural gas',
          'To promote colonization in Africa',
        ],
        correctAnswerIndex: 0,
      ),
      const RehearseQuestion(
        text: 'The Cold War was primarily a geopolitical tension between which two superpowers?',
        options: [
          'United States and Soviet Union',
          'Great Britain and France',
          'Germany and Japan',
          'United States and China',
        ],
        correctAnswerIndex: 0,
      ),
    ];
  }
}

class RehearseScreen extends StatefulWidget {
  final Course course;

  const RehearseScreen({super.key, required this.course});

  @override
  State<RehearseScreen> createState() => _RehearseScreenState();
}

class _RehearseScreenState extends State<RehearseScreen> {
  late final List<RehearseQuestion> _questions;
  late final PageController _pageController;

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

  @override
  void initState() {
    super.initState();
    _questions = getQuestionsForCourse(widget.course);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color _getConfidenceColor(String confidence) {
    switch (confidence) {
      case 'No Idea':
        return const Color(0xFFE94057); // Soft red
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

  void _nextPage() {
    if (_currentIndex < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Validate that all questions have selected answers
      bool allAnswered = true;
      for (int i = 0; i < _questions.length; i++) {
        if (_selectedAnswers[i] == null) {
          allAnswered = false;
          break;
        }
      }

      if (!allAnswered) {
        // Show warnings
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFFE94057),
            content: const Text(
              'Please answer all questions before finishing.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }

      setState(() {
        _isFinished = true;
      });
    }
  }

  void _prevPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

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
                    color: widget.course.gradientColors.first.withValues(alpha: 0.08),
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
                    color: widget.course.gradientColors.last.withValues(alpha: 0.06),
                  ),
                ),
              ),

              // Main content layout
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 680 : double.infinity,
                  ),
                  child: _isFinished ? _buildResultsView() : _buildQuizView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizView() {
    final hasSelectedAnswer = _selectedAnswers[_currentIndex] != null;
    final progress = (_currentIndex + 1) / _questions.length;

    return Column(
      children: [
        // Premium custom AppBar header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.04),
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.course.category,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.4),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Progress bar indicators
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentIndex + 1} of ${_questions.length}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}% Complete',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.04),
                  valueColor: AlwaysStoppedAnimation<Color>(widget.course.gradientColors.first),
                ),
              ),
            ],
          ),
        ),

        // Page view for questionnaire
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _questions.length,
            itemBuilder: (context, qIndex) {
              final question = _questions[qIndex];
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Glassmorphic Question Box
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF161C24).withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                              width: 1.5,
                            ),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Decorative Top category bubble
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: widget.course.gradientColors,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                child: const Text(
                                  'CONCEPT PRACTICE',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                question.text,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Options Label
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0, bottom: 12.0),
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

                    // 4 Multiple Choice Options
                    ...List.generate(question.options.length, (optIndex) {
                      final optionText = question.options[optIndex];
                      final isSelected = _selectedAnswers[qIndex] == optIndex;
                      final optionLetters = ['A', 'B', 'C', 'D'];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedAnswers[qIndex] = optIndex;
                              // Default a confidence if not yet selected
                              if (_confidenceLevels[qIndex] == null) {
                                _confidenceLevels[qIndex] = 'Confident';
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? widget.course.gradientColors.first.withValues(alpha: 0.12)
                                  : const Color(0xFF161C24).withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? widget.course.gradientColors.first.withValues(alpha: 0.6)
                                    : Colors.white.withValues(alpha: 0.06),
                                width: 1.5,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            child: Row(
                              children: [
                                // Selection Circle/Letter
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: isSelected
                                        ? LinearGradient(colors: widget.course.gradientColors)
                                        : null,
                                    color: isSelected
                                        ? null
                                        : Colors.white.withValues(alpha: 0.05),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.transparent
                                          : Colors.white.withValues(alpha: 0.1),
                                      width: 1,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    optionLetters[optIndex],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : Colors.white60,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    optionText,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: isSelected ? Colors.white : Colors.white70,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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

                    // Confidence Level Row
                    if (hasSelectedAnswer) ...[
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0, bottom: 12.0),
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
                          final isConfSelected = _confidenceLevels[qIndex] == confidence;
                          final color = _getConfidenceColor(confidence);

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _confidenceLevels[qIndex] = confidence;
                                  });
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isConfSelected
                                        ? color.withValues(alpha: 0.12)
                                        : const Color(0xFF161C24).withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isConfSelected ? color : Colors.white.withValues(alpha: 0.05),
                                      width: 1.5,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    confidence,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isConfSelected ? color : Colors.white54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              );
            },
          ),
        ),

        // Navigation Footer
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              if (_currentIndex > 0)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: OutlinedButton(
                      onPressed: _prevPage,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back_rounded, size: 16),
                          SizedBox(width: 8),
                          Text('Previous', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        colors: widget.course.gradientColors,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.course.gradientColors.first.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentIndex == _questions.length - 1 ? 'Finish Rehearsal' : 'Next',
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
                ),
              ),
            ],
          ),
        ),
      ],
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
                widget.course.title,
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
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
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
                                    backgroundColor: Colors.white.withValues(alpha: 0.04),
                                    color: scorePct > 0.7
                                        ? const Color(0xFF38EF7D)
                                        : scorePct > 0.4
                                            ? const Color(0xFFFF9F43)
                                            : const Color(0xFFE94057),
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
                                        : const Color(0xFFE94057),
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
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
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
                                    backgroundColor: Colors.white.withValues(alpha: 0.04),
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
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
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
                                    ? const Color(0xFF38EF7D).withValues(alpha: 0.15)
                                    : const Color(0xFFE94057).withValues(alpha: 0.15),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                isCorrect ? Icons.check_rounded : Icons.close_rounded,
                                color: isCorrect ? const Color(0xFF38EF7D) : const Color(0xFFE94057),
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Question ${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white38,
                                    ),
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
                                    style: TextStyle(fontSize: 10, color: Colors.white38),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    userSelect != null ? question.options[userSelect] : 'None',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isCorrect ? const Color(0xFF38EF7D) : const Color(0xFFE94057),
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
                                      style: TextStyle(fontSize: 10, color: Colors.white38),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      question.options[question.correctAnswerIndex],
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
                                  style: TextStyle(fontSize: 10, color: Colors.white38),
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  decoration: BoxDecoration(
                                    color: confidenceColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: confidenceColor.withValues(alpha: 0.2)),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                      });
                      _pageController.jumpToPage(0);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Try Again', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        colors: widget.course.gradientColors,
                      ),
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

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:testu_cl/widgets/circular_progress.dart';
import '../models/tutorial.dart';

class RehearseQuestion {
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  final String difficulty; // "Beginner", "Intermediate", "Expert"

  const RehearseQuestion({
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    required this.difficulty,
  });
}

List<RehearseQuestion> getQuestionsForTutorial(Tutorial tutorial) {
  if (tutorial.category.contains('MATEMÁTICA') ||
      tutorial.title.contains('MATHEMATICAL')) {
    return [
      const RehearseQuestion(
        text:
            'What is the vertex of the parabola defined by f(x) = x² - 4x + 5?',
        options: ['(2, 1)', '(2, 5)', '(4, 5)', '(-2, 17)'],
        correctAnswerIndex: 0,
        difficulty: 'Beginner',
      ),
      const RehearseQuestion(
        text:
            'A box contains 5 red balls and 3 blue balls. If two balls are drawn without replacement, what is the probability that both are blue?',
        options: ['3/28', '9/64', '15/56', '3/8'],
        correctAnswerIndex: 0,
        difficulty: 'Intermediate',
      ),
      const RehearseQuestion(
        text: 'If log₂(x) + log₂(x - 2) = 3, what is the value of x?',
        options: ['4', '2', '8', '-2'],
        correctAnswerIndex: 0,
        difficulty: 'Expert',
      ),
      const RehearseQuestion(
        text: 'What is the sum of the interior angles of a regular hexagon?',
        options: ['720°', '540°', '180°', '1080°'],
        correctAnswerIndex: 0,
        difficulty: 'Intermediate',
      ),
    ];
  } else if (tutorial.category.contains('CIENCIAS') ||
      tutorial.title.contains('PHYSICS')) {
    return [
      const RehearseQuestion(
        text:
            'A car accelerates from rest at a constant rate of 2.0 m/s². How far does it travel in the first 5 seconds?',
        options: ['25 m', '10 m', '50 m', '5 m'],
        correctAnswerIndex: 0,
        difficulty: 'Beginner',
      ),
      const RehearseQuestion(
        text:
            'Which of the following colors of visible light has the shortest wavelength?',
        options: ['Violet', 'Red', 'Green', 'Blue'],
        correctAnswerIndex: 0,
        difficulty: 'Beginner',
      ),
      const RehearseQuestion(
        text:
            'An object is placed 10 cm in front of a concave mirror with a focal length of 15 cm. The image formed is:',
        options: [
          'Virtual, upright, and magnified',
          'Real, inverted, and magnified',
          'Real, inverted, and diminished',
          'Virtual, upright, and diminished',
        ],
        correctAnswerIndex: 0,
        difficulty: 'Intermediate',
      ),
      const RehearseQuestion(
        text:
            'According to Kepler\'s Third Law, the square of the orbital period of a planet is directly proportional to:',
        options: [
          'The cube of the semi-major axis of its orbit',
          'The mass of the planet',
          'The square of the semi-major axis of its orbit',
          'The average distance to the nearest planet',
        ],
        correctAnswerIndex: 0,
        difficulty: 'Expert',
      ),
    ];
  } else if (tutorial.category.contains('LENGUAJE') ||
      tutorial.title.contains('LANGUAGE')) {
    return [
      const RehearseQuestion(
        text:
            'Which of the following best describes the main purpose of an expository text?',
        options: [
          'To explain, inform, or describe a specific topic',
          'To persuade the reader to adopt a certain point of view',
          'To entertain through storytelling and poetic language',
          'To criticize a public figure or institution',
        ],
        correctAnswerIndex: 0,
        difficulty: 'Beginner',
      ),
      const RehearseQuestion(
        text:
            'Identify the tone of the author: "Despite the devastating loss, the team showed remarkable resilience, immediately planning their next steps for improvement."',
        options: [
          'Optimistic and encouraging',
          'Sarcastic and critical',
          'Apathetic and indifferent',
          'Melancholic and hopeless',
        ],
        correctAnswerIndex: 0,
        difficulty: 'Intermediate',
      ),
      const RehearseQuestion(
        text:
            'What is the main function of a thesis statement in an argumentative essay?',
        options: [
          'To present the central argument or claim of the essay',
          'To summarize the concluding remarks of the author',
          'To provide statistical evidence supporting the data',
          'To list the bibliography and sources cited',
        ],
        correctAnswerIndex: 0,
        difficulty: 'Intermediate',
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
        difficulty: 'Expert',
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
        difficulty: 'Beginner',
      ),
      const RehearseQuestion(
        text:
            'Which process describes the movement of people from rural areas to cities during the Industrial Revolution?',
        options: [
          'Urbanization',
          'Colonization',
          'Industrialization',
          'Globalization',
        ],
        correctAnswerIndex: 0,
        difficulty: 'Intermediate',
      ),
      const RehearseQuestion(
        text:
            'What was the main goal of the United Nations when it was founded in 1945?',
        options: [
          'To maintain international peace and security',
          'To establish a single global currency',
          'To control the production of oil and natural gas',
          'To promote colonization in Africa',
        ],
        correctAnswerIndex: 0,
        difficulty: 'Expert',
      ),
      const RehearseQuestion(
        text:
            'The Cold War was primarily a geopolitical tension between which two superpowers?',
        options: [
          'United States and Soviet Union',
          'Great Britain and France',
          'Germany and Japan',
          'United States and China',
        ],
        correctAnswerIndex: 0,
        difficulty: 'Intermediate',
      ),
    ];
  }
}

class ChatMessage {
  final String sender; // 'ai' or 'user'
  final String text;
  final DateTime timestamp;

  ChatMessage({required this.sender, required this.text})
    : timestamp = DateTime.now();
}

class RehearseScreen extends StatefulWidget {
  final Tutorial tutorial;

  const RehearseScreen({super.key, required this.tutorial});

  @override
  State<RehearseScreen> createState() => _RehearseScreenState();
}

class _RehearseScreenState extends State<RehearseScreen> {
  late final List<RehearseQuestion> _questions;
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
  String _stage =
      'select_option'; // 'select_option', 'select_confidence', 'explain_and_followup'

  @override
  void initState() {
    super.initState();
    _questions = getQuestionsForTutorial(widget.tutorial);
    _initializeChat();
  }

  void _initializeChat() {
    _messages.add(
      ChatMessage(
        sender: 'ai',
        text:
            "Hello! Let's practice. Here is your first question:\n\n**Question 1 (${_questions[0].difficulty})**:\n${_questions[0].text}",
      ),
    );
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

  void _selectOption(int optIndex) {
    setState(() {
      _tempSelectedAnswerIndex = optIndex;
      _stage = 'select_confidence';
    });
    _scrollToBottom();
  }

  void _selectConfidence(String confidence) {
    final activeQuestion = _questions[_currentIndex];
    final selectedOptionText =
        activeQuestion.options[_tempSelectedAnswerIndex!];

    setState(() {
      _selectedAnswers[_currentIndex] = _tempSelectedAnswerIndex;
      _confidenceLevels[_currentIndex] = confidence;

      // Add user selection message
      _messages.add(
        ChatMessage(
          sender: 'user',
          text:
              "I select: **$selectedOptionText**\nConfidence level: **$confidence**",
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

      _messages.add(ChatMessage(sender: 'ai', text: aiText));

      _stage = 'explain_and_followup';
    });
    _scrollToBottom();
  }

  void _sendFollowUp() {
    final text = _followUpController.text.trim();
    if (text.isEmpty) return;
    _followUpController.clear();

    setState(() {
      _messages.add(ChatMessage(sender: 'user', text: text));
    });
    _scrollToBottom();

    // Simulate AI typing delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        final answer = _getFollowUpForQuestion(_questions[_currentIndex], text);
        _messages.add(ChatMessage(sender: 'ai', text: answer));
      });
      _scrollToBottom();
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _tempSelectedAnswerIndex = null;
        _stage = 'select_option';

        _messages.add(
          ChatMessage(
            sender: 'ai',
            text:
                "Moving on to the next question:\n\n**Question ${_currentIndex + 1} (${_questions[_currentIndex].difficulty})**:\n${_questions[_currentIndex].text}",
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
            backgroundColor: const Color(0xFFE94057),
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
  int _getBeginnerTotal() =>
      _questions.where((q) => q.difficulty == 'Beginner').length;
  int _getIntermediateTotal() =>
      _questions.where((q) => q.difficulty == 'Intermediate').length;
  int _getExpertTotal() =>
      _questions.where((q) => q.difficulty == 'Expert').length;

  int _getBeginnerCorrect() {
    int count = 0;
    _selectedAnswers.forEach((index, userSelect) {
      if (index < _questions.length &&
          _questions[index].difficulty == 'Beginner') {
        if (userSelect == _questions[index].correctAnswerIndex) {
          count++;
        }
      }
    });
    return count;
  }

  int _getIntermediateCorrect() {
    int count = 0;
    _selectedAnswers.forEach((index, userSelect) {
      if (index < _questions.length &&
          _questions[index].difficulty == 'Intermediate') {
        if (userSelect == _questions[index].correctAnswerIndex) {
          count++;
        }
      }
    });
    return count;
  }

  int _getExpertCorrect() {
    int count = 0;
    _selectedAnswers.forEach((index, userSelect) {
      if (index < _questions.length &&
          _questions[index].difficulty == 'Expert') {
        if (userSelect == _questions[index].correctAnswerIndex) {
          count++;
        }
      }
    });
    return count;
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

  String _getExplanationForQuestion(RehearseQuestion question) {
    final text = question.text;
    if (text.contains('vertex of the parabola')) {
      return 'The vertex of a parabola y = ax² + bx + c has an x-coordinate of h = -b/(2a). In f(x) = x² - 4x + 5, we have a = 1, b = -4, and c = 5.\n\nCalculate x-coordinate:\nh = -(-4) / (2 * 1) = 4 / 2 = 2.\n\nCalculate y-coordinate by plugging x = 2 into f(x):\nf(2) = 2² - 4(2) + 5 = 4 - 8 + 5 = 1.\n\nThus, the vertex is **(2, 1)**.';
    } else if (text.contains('without replacement')) {
      return 'The probability of drawing the first blue ball is 3/8 (since there are 3 blue balls out of 8 total balls).\n\nSince we draw without replacement, there are now 2 blue balls and 7 total balls left. The probability of drawing a second blue ball is 2/7.\n\nTo find the probability that both are blue, multiply the individual probabilities:\n(3/8) * (2/7) = 6/56 = **3/28**.';
    } else if (text.contains('log₂')) {
      return 'Using the logarithm product property, log_b(m) + log_b(n) = log_b(m * n). So:\nlog₂(x(x - 2)) = 3\n\nConvert the logarithmic equation to exponential form:\nx(x - 2) = 2³\nx² - 2x = 8\nx² - 2x - 8 = 0\n\nFactor the quadratic equation:\n(x - 4)(x + 2) = 0\n\nThis gives x = 4 or x = -2. Since the logarithm of a negative number is undefined, x must be positive. Therefore, x = **4**.';
    } else if (text.contains('regular hexagon')) {
      return 'The sum of the interior angles of any n-sided polygon is given by the formula:\nSum = (n - 2) * 180°\n\nA regular hexagon has 6 sides (n = 6). Plug this into the formula:\nSum = (6 - 2) * 180°\nSum = 4 * 180° = **720°**.';
    } else if (text.contains('accelerates from rest')) {
      return 'We can use the kinematic equation for displacement:\nd = v_i * t + 0.5 * a * t²\n\nSince the car starts from rest, its initial velocity (v_i) is 0 m/s. Given acceleration (a) = 2.0 m/s² and time (t) = 5 seconds:\nd = 0 + 0.5 * 2.0 * 5²\nd = 0.5 * 2.0 * 25\nd = **25 meters**.';
    } else if (text.contains('shortest wavelength')) {
      return 'The visible light spectrum is organized by wavelength and frequency. **Violet** has the shortest wavelength (approx. 380-450 nm) and highest frequency/energy.\n\nRed has the longest wavelength (approx. 620-750 nm) and lowest frequency/energy. The order from shortest to longest wavelength is: Violet, Indigo, Blue, Green, Yellow, Orange, Red (VIBGYOR backward).';
    } else if (text.contains('concave mirror')) {
      return 'Using the mirror equation:\n1/f = 1/d_o + 1/d_i\n\nGiven the focal length (f) = 15 cm and object distance (d_o) = 10 cm:\n1/15 = 1/10 + 1/d_i\n1/d_i = 1/15 - 1/10 = 2/30 - 3/30 = -1/30\nd_i = -30 cm.\n\nSince the image distance (d_i) is negative, the image is virtual and located behind the mirror. The magnification (m) is:\nm = -d_i / d_o = -(-30) / 10 = +3.\n\nSince m > 1 and positive, the image is upright and magnified. Thus, the image is **Virtual, upright, and magnified**.';
    } else if (text.contains('Kepler\'s Third Law')) {
      return 'Kepler\'s Third Law (the Law of Harmonies) states that the square of the orbital period (T) of a planet is directly proportional to the cube of the semi-major axis (a) of its orbit:\nT² ∝ a³\n\nThis relationship indicates that planets farther from the Sun take significantly longer to complete an orbit. Thus, the square of the orbital period is proportional to **the cube of the semi-major axis of its orbit**.';
    } else if (text.contains('expository text')) {
      return 'The primary goal of an expository text is **to explain, inform, clarify, or describe a specific topic** to the reader. It uses logical structuring, facts, evidence, and examples to present information objectively.\n\nIn contrast, persuasive texts attempt to convince, narrative texts tell a story, and critical essays analyze/evaluate.';
    } else if (text.contains('resilience, immediately planning')) {
      return 'The author mentions that the team showed "remarkable resilience" and "immediately planned their next steps for improvement." This focus on recovery, learning, and future success conveys an **optimistic and encouraging** tone.';
    } else if (text.contains('thesis statement')) {
      return 'The thesis statement is typically located in the introductory paragraph. Its main function is **to present the central argument or claim of the essay**. It serves as a road map for the reader, guiding the direction and supporting arguments of the entire essay.';
    } else if (text.contains('implicit information')) {
      return 'Implicit information is **information that is not stated directly but can be inferred from clues**. The reader must infer or deduce it by using context clues, text evidence, and logical reasoning.\n\nExplicit information, on the other hand, is stated directly and clearly in the text.';
    } else if (text.contains('French Revolution')) {
      return 'The French Revolution of 1789 was sparked by a combination of key factors:\n1. Economic Crisis: Severe national debt and food shortages.\n2. Social Inequality: The rigid feudal system (Estates System) where the Third Estate bore the tax burden while the nobility/clergy paid almost nothing.\n3. Enlightenment Ideas: Philosophies challenging absolute monarchy and divine right (e.g., Rousseau, Voltaire).\n\nTherefore, the correct option is **Economic crisis, social inequality, and Enlightenment ideas**.';
    } else if (text.contains('rural areas to cities')) {
      return '**Urbanization** is the physical growth of urban areas (cities) as a result of rural migration. During the Industrial Revolution, the introduction of machinery and factories in cities created mass employment opportunities, prompting workers to move away from agricultural rural fields to industrial cities.';
    } else if (text.contains('United Nations')) {
      return 'The United Nations was founded in 1945 immediately after World War II. Its primary mission was **to maintain international peace and security**, promote human rights, and foster friendly relations among nations.';
    } else if (text.contains('Cold War was primarily')) {
      return 'The Cold War was a period of geopolitical tension primarily between the **United States and Soviet Union** (along with their respective allies). It was "cold" because there was no direct large-scale fighting between the two superpowers, but rather proxy wars, nuclear arms race, space race, and ideological competition.';
    }
    return 'The correct answer is Option A. This is because it aligns with the core concepts discussed in this chapter. If you have any specific questions about this topic, feel free to ask below!';
  }

  String _getFollowUpForQuestion(RehearseQuestion question, String query) {
    final qText = question.text;
    final lowercaseQuery = query.toLowerCase();

    // Probability question
    if (qText.contains('without replacement')) {
      if (lowercaseQuery.contains('why') || lowercaseQuery.contains('how')) {
        return 'We multiply the probabilities because the events are dependent. Since we do not replace the first ball, the total count drops from 8 to 7, and the blue ball count drops from 3 to 2. Therefore, the chance of both is:\nP(First Blue) * P(Second Blue | First Blue) = (3/8) * (2/7) = 6/56 = **3/28**.';
      } else if (lowercaseQuery.contains('with replacement') ||
          lowercaseQuery.contains('replace')) {
        return 'If we drew WITH replacement, the probability for the second draw would remain 3/8. The probability of drawing two blue balls would be (3/8) * (3/8) = **9/64** (which is Option B).';
      } else if (lowercaseQuery.contains('example') ||
          lowercaseQuery.contains('ejemplo') ||
          lowercaseQuery.contains('another')) {
        return 'Example: A bag has 4 red and 2 green balls. Drawing 2 green balls without replacement:\n- First green: 2/6 = 1/3.\n- Second green: 1/5.\n- Total probability: (1/3) * (1/5) = **1/15**.';
      } else if (lowercaseQuery.contains('other') ||
          lowercaseQuery.contains('incorrect') ||
          lowercaseQuery.contains('options') ||
          lowercaseQuery.contains('wrong')) {
        return '- **9/64**: Probability WITH replacement.\n- **15/56**: Probability of drawing 1 red and 1 blue ball without replacement.\n- **3/8**: Probability of drawing just a single blue ball on the first try.';
      }
    }

    // Parabola Vertex question
    if (qText.contains('vertex of the parabola')) {
      if (lowercaseQuery.contains('x =') ||
          lowercaseQuery.contains('find x') ||
          lowercaseQuery.contains('formula')) {
        return 'The x-coordinate of the vertex is given by the formula **x = -b / (2a)**. For f(x) = x² - 4x + 5, we have a = 1 and b = -4.\nPlugging in:\nx = -(-4) / (2 * 1) = 4 / 2 = **2**.';
      } else if (lowercaseQuery.contains('y =') ||
          lowercaseQuery.contains('find y') ||
          lowercaseQuery.contains('y-coordinate')) {
        return 'To find the y-coordinate, evaluate the function at the vertex x-coordinate (which is 2):\nf(2) = (2)² - 4(2) + 5 = 4 - 8 + 5 = **1**.\nThis gives the vertex point **(2, 1)**.';
      } else if (lowercaseQuery.contains('example') ||
          lowercaseQuery.contains('ejemplo') ||
          lowercaseQuery.contains('another')) {
        return 'Example: Find the vertex of f(x) = x² - 6x + 10.\n- h = -(-6) / (2 * 1) = 3.\n- k = f(3) = 3² - 6(3) + 10 = 9 - 18 + 10 = 1.\nVertex is **(3, 1)**.';
      } else if (lowercaseQuery.contains('other') ||
          lowercaseQuery.contains('incorrect') ||
          lowercaseQuery.contains('options') ||
          lowercaseQuery.contains('wrong')) {
        return '- **(2, 5)**: Incorrectly calculates the y-value by adding 4 instead of subtracting.\n- **(4, 5)**: This is the point where x = 4, f(4) = 5. It is on the parabola, but not the vertex.\n- **(-2, 17)**: This is f(-2) = 17, also on the parabola but not the vertex.';
      }
    }

    // Log question
    if (qText.contains('log₂')) {
      if (lowercaseQuery.contains('why') ||
          lowercaseQuery.contains('negative') ||
          lowercaseQuery.contains('-2')) {
        return 'We reject x = -2 because log₂(x) and log₂(x - 2) require the arguments to be strictly positive (x > 0 and x - 2 > 0). If you try to calculate log₂(-2), it is mathematically undefined in real numbers.';
      } else if (lowercaseQuery.contains('property') ||
          lowercaseQuery.contains('rule') ||
          lowercaseQuery.contains('product')) {
        return 'We use the logarithmic product rule: **log_b(A) + log_b(B) = log_b(A * B)**. This lets us merge log₂(x) + log₂(x - 2) into log₂(x * (x - 2)).';
      } else if (lowercaseQuery.contains('example') ||
          lowercaseQuery.contains('ejemplo') ||
          lowercaseQuery.contains('another')) {
        return 'Example: Solve log₃(x) + log₃(x - 6) = 3.\nlog₃(x(x - 6)) = 3\nx(x - 6) = 3³ = 27\nx² - 6x - 27 = 0\n(x - 9)(x + 3) = 0\nSince x must be positive, **x = 9**.';
      }
    }

    // Hexagon sum of angles question
    if (qText.contains('regular hexagon')) {
      if (lowercaseQuery.contains('formula') ||
          lowercaseQuery.contains('how') ||
          lowercaseQuery.contains('why')) {
        return 'The sum of the interior angles of a polygon with n sides is **S = (n - 2) * 180°**. A hexagon has 6 sides, so S = (6 - 2) * 180° = 4 * 180° = **720°**. For a regular hexagon, each individual angle is 720° / 6 = **120°**.';
      } else if (lowercaseQuery.contains('example') ||
          lowercaseQuery.contains('pentagon') ||
          lowercaseQuery.contains('octagon') ||
          lowercaseQuery.contains('another')) {
        return 'Examples for other polygons:\n- Pentagon (5 sides): (5 - 2) * 180° = **540°**.\n- Octagon (8 sides): (8 - 2) * 180° = **1080°**.';
      }
    }

    // Physics car acceleration question
    if (qText.contains('accelerates from rest')) {
      if (lowercaseQuery.contains('formula') ||
          lowercaseQuery.contains('equation')) {
        return 'The formula is **d = v_i * t + 0.5 * a * t²**. Here, initial velocity v_i = 0 (from rest), acceleration a = 2.0 m/s², and time t = 5s.\nSo, d = 0 + 0.5 * 2.0 * (5)² = **25m**.';
      } else if (lowercaseQuery.contains('example') ||
          lowercaseQuery.contains('another')) {
        return 'Example: An object accelerates from rest at 4 m/s² for 3 seconds:\nd = 0.5 * 4 * 3² = 2 * 9 = **18 meters**.';
      }
    }

    // Physics wavelength question
    if (qText.contains('shortest wavelength')) {
      if (lowercaseQuery.contains('longest') ||
          lowercaseQuery.contains('red')) {
        return 'Red light has the longest wavelength in the visible spectrum, around **700 nm**. It has the lowest frequency and energy of visible light.';
      } else if (lowercaseQuery.contains('violet') ||
          lowercaseQuery.contains('why')) {
        return 'Violet light has the shortest wavelength, around **400 nm**. In electromagnetic waves, shorter wavelength corresponds to higher frequency and energy, which is why ultraviolet (even shorter than violet) is high-energy radiation.';
      }
    }

    // Physics Concave mirror question
    if (qText.contains('concave mirror')) {
      if (lowercaseQuery.contains('virtual') ||
          lowercaseQuery.contains('why') ||
          lowercaseQuery.contains('real')) {
        return 'When an object is placed closer to a concave mirror than its focal length (d_o < f), the light rays diverge after reflecting. Extending these rays backward behind the mirror shows they meet at a virtual point. This makes the image virtual (behind mirror) and upright.';
      } else if (lowercaseQuery.contains('math') ||
          lowercaseQuery.contains('formula') ||
          lowercaseQuery.contains('calculation')) {
        return 'Using 1/f = 1/d_o + 1/d_i:\n1/f = 1/15 = 1/10 + 1/d_i\n1/d_i = 1/15 - 1/10 = -1/30\nd_i = -30 cm (Virtual). Magnification m = -d_i / d_o = -(-30) / 10 = +3 (Magnified & Upright).';
      }
    }

    // Kepler's Third Law
    if (qText.contains('Kepler\'s Third Law')) {
      if (lowercaseQuery.contains('formula') ||
          lowercaseQuery.contains('equation') ||
          lowercaseQuery.contains('proportional') ||
          lowercaseQuery.contains('math')) {
        return 'The mathematical representation is **T² ∝ a³**, where T is the orbital period and a is the semi-major axis. If you double the distance, the orbital period increases by a factor of 2^(3/2) ≈ **2.83** times.';
      }
    }

    // Expository text
    if (qText.contains('expository text')) {
      if (lowercaseQuery.contains('persuade') ||
          lowercaseQuery.contains('argumentative')) {
        return 'An argumentative text is designed to persuade the reader. Expository texts, by contrast, avoid opinions and stick to presenting factual explanations neutrally.';
      } else if (lowercaseQuery.contains('example') ||
          lowercaseQuery.contains('ejemplo') ||
          lowercaseQuery.contains('another')) {
        return 'Examples of expository texts include news articles, textbooks, manuals, and encyclopedias. They present facts and explanations without trying to convince you of a personal viewpoint.';
      }
    }

    // Tone of resilience
    if (qText.contains('resilience, immediately planning')) {
      if (lowercaseQuery.contains('why') ||
          lowercaseQuery.contains('tone') ||
          lowercaseQuery.contains('explain')) {
        return 'The tone is encouraging because the author focuses on the team\'s positive response ("resilience") and future planning rather than dwelling on the "devastating loss," showing an optimistic outlook.';
      }
    }

    // Thesis statement
    if (qText.contains('thesis statement')) {
      if (lowercaseQuery.contains('where') || lowercaseQuery.contains('find')) {
        return 'The thesis statement is typically found at the end of the introductory paragraph of an essay. It establishes the main argument that the body paragraphs will support with evidence.';
      }
    }

    // French Revolution
    if (qText.contains('French Revolution')) {
      if (lowercaseQuery.contains('enlightenment') ||
          lowercaseQuery.contains('ideas')) {
        return 'Enlightenment thinkers like Montesquieu, Voltaire, and Rousseau popularized concepts like social contract, separation of powers, and individual liberty. These ideas inspired citizens to challenge the absolute power of King Louis XVI.';
      } else if (lowercaseQuery.contains('inequality') ||
          lowercaseQuery.contains('estates')) {
        return 'French society was split into three Estates: Clergy (1st), Nobility (2nd), and everyone else (3rd). The Third Estate made up 98% of the population but had virtually no political power and paid all the taxes, leading to massive resentment.';
      }
    }

    // Industrial Revolution Urbanization
    if (qText.contains('rural areas to cities')) {
      if (lowercaseQuery.contains('urbanization') ||
          lowercaseQuery.contains('why')) {
        return 'Urbanization occurred because agricultural machines reduced the need for farm labor in the countryside, while new steam-powered factories in cities needed thousands of workers, leading to massive migration.';
      }
    }

    // United Nations
    if (qText.contains('United Nations')) {
      if (lowercaseQuery.contains('league of nations') ||
          lowercaseQuery.contains('history')) {
        return 'The United Nations succeeded the League of Nations, which had failed to prevent World War II. The UN was designed with stronger enforcement mechanisms, such as the Security Council, to make peace preservation more effective.';
      }
    }

    // Cold War
    if (qText.contains('Cold War was primarily')) {
      if (lowercaseQuery.contains('why') || lowercaseQuery.contains('cold')) {
        return 'It was called "cold" because the US and USSR never directly declared war on each other, fearing a nuclear holocaust. Instead, they fought through proxy wars (like the Korean and Vietnam wars), espionage, and propaganda.';
      }
    }

    // General fallbacks based on keywords
    if (lowercaseQuery.contains('why') ||
        lowercaseQuery.contains('explain') ||
        lowercaseQuery.contains('how')) {
      return 'This concept is a core element of the topic. Reviewing the correct answer details helps clarify the underlying principles. Let me know if you would like me to explain a specific option!';
    }
    if (lowercaseQuery.contains('example') ||
        lowercaseQuery.contains('ejemplo')) {
      return 'For instance, in similar problems, we apply the same rule or concept to a slightly different scenario. This helps reinforce the general principle. Would you like to review another part of this question?';
    }
    if (lowercaseQuery.contains('thank') ||
        lowercaseQuery.contains('ok') ||
        lowercaseQuery.contains('thanks') ||
        lowercaseQuery.contains('perfecto')) {
      return 'You\'re welcome! Let me know if you want to discuss this more, or feel free to move on to the next question when you\'re ready.';
    }

    return 'That is a great question! This topic requires careful attention to the key definitions and formulas. Let me know if you would like a step-by-step breakdown or another example.';
  }

  Widget _buildRichText(String text, TextStyle baseStyle) {
    final List<TextSpan> spans = [];
    final RegExp regExp = RegExp(r'\*\*(.*?)\*\*');
    int lastMatchEnd = 0;

    for (final Match match in regExp.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
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

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return RichText(
      text: TextSpan(children: spans, style: baseStyle),
    );
  }

  Widget _buildHeaderProgressColumn(
    String label,
    int correct,
    int total,
    Color color,
  ) {
    final double percentage = total > 0 ? (correct / total) : 0.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        CircularProgress(
          value: correct.toDouble(),
          max: total > 0 ? total.toDouble() : 1.0,
          color: color,
        ),
        const SizedBox(height: 8),
        Text(
          '${(percentage * 100).toInt()}%',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
            if (_stage == 'select_option') ...[
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
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: InkWell(
                    onTap: () => _selectOption(optIndex),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF161C24).withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.06),
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
                              color: Colors.white.withValues(alpha: 0.05),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              optionLetters[optIndex],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white60,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              optionText,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ] else if (_stage == 'select_confidence') ...[
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
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: InkWell(
                        onTap: () => _selectConfidence(confidence),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF161C24,
                            ).withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.05),
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
                            color: widget.tutorial.gradientColors.first,
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
                    color: widget.tutorial.gradientColors.first,
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
                  gradient: LinearGradient(
                    colors: widget.tutorial.gradientColors,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.tutorial.gradientColors.first.withValues(
                        alpha: 0.3,
                      ),
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
    // final progress = (_currentIndex + 1) / _questions.length;
    final activeQuestion = _questions[_currentIndex];

    // Compute dynamic session metrics
    final easyTotal = _getBeginnerTotal();
    final easyCorrect = _getBeginnerCorrect();
    final intTotal = _getIntermediateTotal();
    final intCorrect = _getIntermediateCorrect();
    final advTotal = _getExpertTotal();
    final advCorrect = _getExpertCorrect();

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
                    const SizedBox(height: 8),
                    const Text(
                      'Your progress so far',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildHeaderProgressColumn(
                          'Beginner',
                          easyCorrect,
                          easyTotal,
                          const Color(0xFF38EF7D),
                        ),
                        const SizedBox(width: 24),
                        _buildHeaderProgressColumn(
                          'Intermediate',
                          intCorrect,
                          intTotal,
                          const Color(0xFFF27121),
                        ),
                        const SizedBox(width: 24),
                        _buildHeaderProgressColumn(
                          'Expert',
                          advCorrect,
                          advTotal,
                          const Color(0xFFE94057),
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
        //             widget.tutorial.gradientColors.first,
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
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: widget.tutorial.gradientColors,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.smart_toy_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isAI
                              ? const Color(0xFF161C24).withValues(alpha: 0.8)
                              : widget.tutorial.gradientColors.first.withValues(
                                  alpha: 0.15,
                                ),
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
                                : widget.tutorial.gradientColors.first
                                      .withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: _buildRichText(
                          message.text,
                          TextStyle(
                            fontSize: 14,
                            color: isAI
                                ? Colors.white.withValues(alpha: 0.85)
                                : Colors.white,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                    if (!isAI) ...[
                      const SizedBox(width: 12),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.tutorial.gradientColors.first
                              .withValues(alpha: 0.2),
                          border: Border.all(
                            color: widget.tutorial.gradientColors.first
                                .withValues(alpha: 0.4),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 18,
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
                    color: widget.tutorial.gradientColors.first.withValues(
                      alpha: 0.08,
                    ),
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
                    color: widget.tutorial.gradientColors.last.withValues(
                      alpha: 0.06,
                    ),
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
                                        0xFFE94057,
                                      ).withValues(alpha: 0.15),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                isCorrect
                                    ? Icons.check_rounded
                                    : Icons.close_rounded,
                                color: isCorrect
                                    ? const Color(0xFF38EF7D)
                                    : const Color(0xFFE94057),
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
                                                  0xFFE94057,
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
                                                : const Color(0xFFE94057),
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
                                          : const Color(0xFFE94057),
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
                      gradient: LinearGradient(
                        colors: widget.tutorial.gradientColors,
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

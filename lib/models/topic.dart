import 'package:flutter/material.dart';
import 'course.dart';

class Topic {
  final String title;
  final String category;
  final IconData icon;
  final List<Color> gradientColors;
  final double averageScore; // e.g. 0.85 (85%) average test score
  final List<Course> courses;

  const Topic({
    required this.title,
    required this.category,
    required this.icon,
    required this.gradientColors,
    required this.averageScore,
    required this.courses,
  });

  // Calculates the average progress of courses within this topic
  double get progress {
    if (courses.isEmpty) return 0.0;
    final totalProgress = courses.map((c) => c.progress).reduce((a, b) => a + b);
    return totalProgress / courses.length;
  }
}

// Mock topics grouping the original mockCourses and adding additional detail courses
final List<Topic> mockTopics = [
  Topic(
    title: 'Mathematics (M1 & M2)',
    category: 'PAES - MATEMÁTICA',
    icon: Icons.calculate_rounded,
    gradientColors: const [Color(0xFF1D2671), Color(0xFFC33764)],
    averageScore: 0.58,
    courses: [
      const Course(
        title: 'MATHEMATICAL COMPETENCE 1 (M1)',
        category: 'PAES - MATEMÁTICA',
        status: 'On Track',
        unlockedQuestions: 350,
        totalQuestions: 500,
        progress: 0.70,
        daysToForget: '15 days',
        effectiveness: 'Good',
        gradientColors: [Color(0xFF1D2671), Color(0xFF6B114D)],
        icon: Icons.calculate_outlined,
      ),
      mockCourses[0], // MATHEMATICAL COMPETENCE 2 (M2)
      const Course(
        title: 'GEOMETRY & ALGEBRA BOOTCAMP',
        category: 'PAES - MATEMÁTICA',
        status: 'Warning',
        unlockedQuestions: 80,
        totalQuestions: 300,
        progress: 0.26,
        daysToForget: '4 days',
        effectiveness: 'Moderate',
        gradientColors: [Color(0xFF430082), Color(0xFF96007F)],
        icon: Icons.architecture_rounded,
      ),
    ],
  ),
  Topic(
    title: 'Science (Ciencias)',
    category: 'PAES - CIENCIAS',
    icon: Icons.science_rounded,
    gradientColors: const [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],
    averageScore: 0.64,
    courses: [
      mockCourses[1], // SCIENCE - PHYSICS
      const Course(
        title: 'SCIENCE - CHEMISTRY (CIENCIAS - QUÍMICA)',
        category: 'PAES - CIENCIAS',
        status: 'On Track',
        unlockedQuestions: 210,
        totalQuestions: 400,
        progress: 0.52,
        daysToForget: '10 days',
        effectiveness: 'Good',
        gradientColors: [Color(0xFFE94057), Color(0xFFF27121)],
        icon: Icons.biotech_rounded,
      ),
      const Course(
        title: 'SCIENCE - BIOLOGY (CIENCIAS - BIOLOGÍA)',
        category: 'PAES - CIENCIAS',
        status: 'Critical',
        unlockedQuestions: 50,
        totalQuestions: 450,
        progress: 0.11,
        daysToForget: 'No data',
        effectiveness: 'Poor',
        gradientColors: [Color(0xFF8A2387), Color(0xFFF27121)],
        icon: Icons.spa_rounded,
      ),
    ],
  ),
  Topic(
    title: 'Language & Reading',
    category: 'PAES - LENGUAJE',
    icon: Icons.menu_book_rounded,
    gradientColors: const [Color(0xFF11998E), Color(0xFF38EF7D)],
    averageScore: 0.91,
    courses: [
      mockCourses[2], // LANGUAGE & READING
      const Course(
        title: 'LITERARY & NON-LITERARY TEXTS',
        category: 'PAES - LENGUAJE',
        status: 'On Track',
        unlockedQuestions: 150,
        totalQuestions: 200,
        progress: 0.75,
        daysToForget: '12 days',
        effectiveness: 'Excellent',
        gradientColors: [Color(0xFF11998E), Color(0xFF1A5F7A)],
        icon: Icons.auto_stories_rounded,
      ),
    ],
  ),
  Topic(
    title: 'History & Social Sciences',
    category: 'PAES - HISTORIA',
    icon: Icons.public_rounded,
    gradientColors: const [Color(0xFF00C6FF), Color(0xFF0072FF)],
    averageScore: 0.72,
    courses: [
      mockCourses[3], // HISTORY & SOCIAL SCIENCES
      const Course(
        title: 'DEMOCRACY AND CITIZENSHIP',
        category: 'PAES - HISTORIA',
        status: 'Warning',
        unlockedQuestions: 90,
        totalQuestions: 250,
        progress: 0.36,
        daysToForget: '5 days',
        effectiveness: 'Moderate',
        gradientColors: [Color(0xFF0072FF), Color(0xFF0F172A)],
        icon: Icons.gavel_rounded,
      ),
    ],
  ),
];

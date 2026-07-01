import 'package:flutter/material.dart';

class Course {
  final String title;
  final String category;
  final String status; // Critical, Warning, On Track, Excellent
  final int unlockedQuestions;
  final int totalQuestions;
  final double progress;
  final String daysToForget;
  final String effectiveness;
  final List<Color> gradientColors;
  final IconData icon;

  const Course({
    required this.title,
    required this.category,
    required this.status,
    required this.unlockedQuestions,
    required this.totalQuestions,
    required this.progress,
    required this.daysToForget,
    required this.effectiveness,
    required this.gradientColors,
    required this.icon,
  });
}

// Mock Data
final List<Course> mockCourses = [
  const Course(
    title: 'MATHEMATICAL COMPETENCE 2 (M2)',
    category: 'PAES - MATEMÁTICA',
    status: 'Critical',
    unlockedQuestions: 110,
    totalQuestions: 440,
    progress: 0.05,
    daysToForget: 'No data',
    effectiveness: 'Poor',
    gradientColors: [Color(0xFF1D2671), Color(0xFFC33764)],
    icon: Icons.calculate_rounded,
  ),
  const Course(
    title: 'SCIENCE - PHYSICS (CIENCIAS - FÍSICA)',
    category: 'PAES - CIENCIAS',
    status: 'Warning',
    unlockedQuestions: 180,
    totalQuestions: 400,
    progress: 0.45,
    daysToForget: '3 days',
    effectiveness: 'Moderate',
    gradientColors: [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],
    icon: Icons.waves_rounded,
  ),
  const Course(
    title: 'LANGUAGE & READING (COMPRENSIÓN LECTORA)',
    category: 'PAES - LENGUAJE',
    status: 'On Track',
    unlockedQuestions: 320,
    totalQuestions: 350,
    progress: 0.91,
    daysToForget: '18 days',
    effectiveness: 'Excellent',
    gradientColors: [Color(0xFF11998E), Color(0xFF38EF7D)],
    icon: Icons.menu_book_rounded,
  ),
  const Course(
    title: 'HISTORY & SOCIAL SCIENCES',
    category: 'PAES - HISTORIA',
    status: 'On Track',
    unlockedQuestions: 120,
    totalQuestions: 500,
    progress: 0.24,
    daysToForget: '12 days',
    effectiveness: 'Good',
    gradientColors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
    icon: Icons.public_rounded,
  ),
];

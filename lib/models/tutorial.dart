import 'package:flutter/material.dart';

class Tutorial {
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

  const Tutorial({
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
final List<Tutorial> mockTutorials = [
  // Ciberseguridad Tutorials (Indices 0 - 3)
  const Tutorial(
    title: 'Conceptos Básicos de Ciberseguridad',
    category: 'Ciberseguridad',
    status: 'On Track',
    unlockedQuestions: 8,
    totalQuestions: 10,
    progress: 0.8,
    daysToForget: '15 días',
    effectiveness: 'Good',
    gradientColors: [Color(0xFF38B6FF), Color(0xFF0072FF)],
    icon: Icons.security,
  ),
  const Tutorial(
    title: 'Ingeniería Social y Phishing',
    category: 'Ciberseguridad',
    status: 'Critical',
    unlockedQuestions: 3,
    totalQuestions: 10,
    progress: 0.3,
    daysToForget: '2 días',
    effectiveness: 'Moderate',
    gradientColors: [Color(0xFFE94057), Color(0xFFF27121)],
    icon: Icons.phishing,
  ),
  const Tutorial(
    title: 'Buenas Prácticas de Contraseñas',
    category: 'Ciberseguridad',
    status: 'Excellent',
    unlockedQuestions: 10,
    totalQuestions: 10,
    progress: 1.0,
    daysToForget: '30 días',
    effectiveness: 'Excellent',
    gradientColors: [Color(0xFF11998e), Color(0xFF38EF7D)],
    icon: Icons.vpn_key,
  ),
  const Tutorial(
    title: 'Seguridad en Dispositivos Móviles',
    category: 'Ciberseguridad',
    status: 'Warning',
    unlockedQuestions: 5,
    totalQuestions: 10,
    progress: 0.5,
    daysToForget: '7 días',
    effectiveness: 'Moderate',
    gradientColors: [Color(0xFFF27121), Color(0xFFE94057)],
    icon: Icons.phone_android,
  ),

  // Derechos Humanos Tutorials (Indices 4 - 7)
  const Tutorial(
    title: 'Fundamentos de los Derechos Humanos',
    category: 'Derechos Humanos',
    status: 'Excellent',
    unlockedQuestions: 10,
    totalQuestions: 10,
    progress: 1.0,
    daysToForget: '45 días',
    effectiveness: 'Excellent',
    gradientColors: [Color(0xFF11998e), Color(0xFF38EF7D)],
    icon: Icons.gavel,
  ),
  const Tutorial(
    title: 'Derechos Humanos en el Entorno Laboral',
    category: 'Derechos Humanos',
    status: 'On Track',
    unlockedQuestions: 7,
    totalQuestions: 10,
    progress: 0.7,
    daysToForget: '12 días',
    effectiveness: 'Good',
    gradientColors: [Color(0xFF38B6FF), Color(0xFF0072FF)],
    icon: Icons.work,
  ),
  const Tutorial(
    title: 'Diversidad, Equidad e Inclusión',
    category: 'Derechos Humanos',
    status: 'Excellent',
    unlockedQuestions: 10,
    totalQuestions: 10,
    progress: 1.0,
    daysToForget: '30 días',
    effectiveness: 'Excellent',
    gradientColors: [Color(0xFF11998e), Color(0xFF38EF7D)],
    icon: Icons.people,
  ),
  const Tutorial(
    title: 'Prevención del Acoso y Canales de Denuncia',
    category: 'Derechos Humanos',
    status: 'Warning',
    unlockedQuestions: 4,
    totalQuestions: 10,
    progress: 0.4,
    daysToForget: '5 días',
    effectiveness: 'Moderate',
    gradientColors: [Color(0xFFF27121), Color(0xFFE94057)],
    icon: Icons.campaign,
  ),
];


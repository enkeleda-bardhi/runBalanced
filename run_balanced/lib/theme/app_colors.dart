import 'package:flutter/material.dart';

/// Enhanced color system with semantic colors for RunBalanced app
class AppColors {
  // Fitness-specific colors
  static const Color heartRate = Color(0xFFE53E3E);
  static const Color calories = Color(0xFFFF8C00);
  static const Color distance = Color(0xFF38A169);
  static const Color pace = Color(0xFF3182CE);

  // Fatigue zones
  static const Color fatigueOptimal = Color(0xFF48BB78);
  static const Color fatigueModerate = Color(0xFFF6E05E);
  static const Color fatigueHigh = Color(0xFFF56565);
  static const Color fatigueCritical = Color(0xFFE53E3E);

  // UI colors
  static const Color primary = Color(0xFF6B46C1);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color surface = Color(0xFFF7FAFC);
  static const Color onSurface = Color(0xFF2D3748);

  // Timer specific gradients
  static const List<Color> timerGradient = [
    Color(0xFF6B46C1), // Deep purple
    Color(0xFF8B5CF6), // Lighter purple
  ];

  static const List<Color> timerGradientDark = [
    Color(0xFF553C9A), // Darker purple for dark mode
    Color(0xFF6B46C1), // Deep purple
  ];
}

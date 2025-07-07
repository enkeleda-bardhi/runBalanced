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

/// Consistent spacing system
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Typography system
class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  
  static const TextStyle timerLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.2,
  );
  
  static const TextStyle timerTime = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w300,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}

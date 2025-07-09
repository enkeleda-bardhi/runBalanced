import 'package:flutter/material.dart';

/// Enhanced color system with semantic colors for RunBalanced app
class AppColors {
  // Primary theme colors (using your existing deep purple)
  static const Color primary = Colors.indigoAccent;
  static const Color secondary = Colors.lightBlueAccent;
  static const Color tertiary = Color.fromARGB(255, 193, 193, 193);
  
  // Others
  static const Color error = Colors.redAccent;


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
  
  // Fatigue types
  static const Color cardioFatigue = Colors.red; // Red for cardio fatigue
  static const Color jointFatigue = Colors.orange; // Orange for joint fatigue
  static const Color muscleFatigue = Colors.green; // Green for muscle fatigue

  // UI colors
  static const Color surface = Color.fromARGB(255, 248, 250, 251);
  static const Color onSurface = Color.fromARGB(255, 30, 30, 30);
  
  // Timer specific gradients (using your primary color)
  static const List<Color> timerGradient = [
    primary,
    secondary,
  ];
  
  static const List<Color> timerGradientDark = [
    Color.fromARGB(255, 52, 36, 94), // Darker purple for dark mode
    Color.fromARGB(255, 53, 70, 162),
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

/// Typography system - shared font sizes and weights
class AppTextStyles {
  // Font sizes
  static double displayLargeSize = 32.0;
  static double displayMediumSize = 28.0;
  static double headlineSize = 24.0;
  static double bodySize = 16.0;
  static double captionSize = 12.0;
  static double timerLabelSize = 14.0;
  static double timerTimeSize = 56.0;
  static double appBarTitleSize = 22.0;

  static TextStyle headline1 = TextStyle(
    fontSize: displayLargeSize,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  static TextStyle headline2 = TextStyle(
    fontSize: headlineSize,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle body1 = TextStyle(
    fontSize: bodySize,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle caption = TextStyle(
    fontSize: captionSize,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle timerLabel = TextStyle(
    fontSize: timerLabelSize,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.2,
  );
  
  static TextStyle timerTime = TextStyle(
    fontSize: timerTimeSize,
    fontWeight: FontWeight.w300,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.surface,
  canvasColor: AppColors.surface,
  iconTheme: IconThemeData(color: AppColors.onSurface),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.onSurface,
    foregroundColor: AppColors.surface,
    iconTheme: IconThemeData(color: AppColors.surface),
    titleTextStyle: TextStyle(
      color: AppColors.surface,
      fontSize: AppTextStyles.appBarTitleSize,
    ),
  ),
  drawerTheme: DrawerThemeData(backgroundColor: AppColors.surface),
  listTileTheme: ListTileThemeData(
    selectedColor: AppColors.surface,
    selectedTileColor: AppColors.tertiary,
    iconColor: AppColors.onSurface,
    textColor: AppColors.onSurface,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: AppColors.onSurface),
    bodyMedium: TextStyle(color: AppColors.onSurface),
    displayLarge: TextStyle(
      fontSize: AppTextStyles.displayLargeSize,
      fontWeight: FontWeight.bold,
      color: AppColors.onSurface,
    ),
    displayMedium: TextStyle(
      fontSize: AppTextStyles.displayMediumSize,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
    ),
  ),

  cardColor: AppColors.tertiary,
);

ThemeData darkMode = ThemeData(
  useMaterial3: true, // Keep Material 3 enabled
  brightness: Brightness.dark,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.onSurface,
  canvasColor: AppColors.onSurface,
  // FIX: Use a light color for icons to be visible on a dark background
  iconTheme: IconThemeData(color: AppColors.surface),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.surface,
    foregroundColor: AppColors.onSurface,
    // FIX: Make AppBar icons match the title color for consistency
    iconTheme: IconThemeData(color: AppColors.onSurface),
    titleTextStyle: TextStyle(
      color: AppColors.onSurface,
      fontSize: AppTextStyles.appBarTitleSize,
    ),
  ),
  drawerTheme: DrawerThemeData(backgroundColor: Colors.grey[900]),
  listTileTheme: ListTileThemeData(
    selectedColor: AppColors.surface,
    selectedTileColor: AppColors.primary,
    iconColor: AppColors.surface,
    textColor: AppColors.surface,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: AppColors.surface),
    bodyMedium: TextStyle(color: AppColors.surface),
    displayLarge: TextStyle(
      fontSize: AppTextStyles.displayLargeSize,
      fontWeight: FontWeight.bold,
      color: AppColors.surface,
    ),
    displayMedium: TextStyle(
      fontSize: AppTextStyles.displayMediumSize,
      fontWeight: FontWeight.w600,
      color: AppColors.surface,
    ),
  ),

  focusColor: AppColors.primary,
  cardColor: AppColors.secondary,
);

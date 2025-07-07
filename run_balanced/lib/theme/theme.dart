import 'package:flutter/material.dart';

/// Enhanced color system with semantic colors for RunBalanced app
class AppColors {
  // Primary theme colors (using your existing deep purple)
  static const Color primary = Colors.deepPurple;
  static const Color secondary = Color(0xFF8B5CF6);
  
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
  static const Color surface = Color(0xFFF7FAFC);
  static const Color onSurface = Color(0xFF2D3748);
  
  // Timer specific gradients (using your primary color)
  static const List<Color> timerGradient = [
    primary,
    secondary,
  ];
  
  static const List<Color> timerGradientDark = [
    Color(0xFF553C9A), // Darker purple for dark mode
    primary,
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
  static const double displayLargeSize = 32;
  static const double displayMediumSize = 28;
  static const double headlineSize = 24;
  static const double bodySize = 16;
  static const double captionSize = 12;
  static const double timerLabelSize = 14;
  static const double timerTimeSize = 56;
  static const double appBarTitleSize = 22;
  
  static const TextStyle headline1 = TextStyle(
    fontSize: displayLargeSize,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );
  
  static const TextStyle headline2 = TextStyle(
    fontSize: headlineSize,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  static const TextStyle body1 = TextStyle(
    fontSize: bodySize,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: captionSize,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  
  static const TextStyle timerLabel = TextStyle(
    fontSize: timerLabelSize,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.2,
  );
  
  static const TextStyle timerTime = TextStyle(
    fontSize: timerTimeSize,
    fontWeight: FontWeight.w300,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}

/// Shared theme components to avoid repetition
class AppThemeData {
  // Shared button theme
  static ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 20,
      ),
    ),
  );
  
  // Shared color scheme factory
  static ColorScheme colorSchemeLight = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  );
  
  static ColorScheme colorSchemeDark = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  );
}

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: Colors.white,
  canvasColor: Colors.white,
  iconTheme: IconThemeData(color: Colors.black),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: AppTextStyles.appBarTitleSize,
    ),
  ),
  drawerTheme: DrawerThemeData(backgroundColor: Colors.white),
  listTileTheme: ListTileThemeData(
    selectedColor: Colors.black,
    selectedTileColor: Colors.lightBlue.shade100,
    iconColor: Colors.black,
    textColor: Colors.black,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    displayLarge: TextStyle(
      fontSize: AppTextStyles.displayLargeSize,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    displayMedium: TextStyle(
      fontSize: AppTextStyles.displayMediumSize,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  ),
  colorScheme: AppThemeData.colorSchemeLight,
  focusColor: Colors.lightBlue.shade200,
  cardColor: Colors.grey.shade50,
  elevatedButtonTheme: AppThemeData.elevatedButtonTheme,
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: Colors.black,
  canvasColor: Colors.black,
  iconTheme: IconThemeData(color: Colors.grey.shade900),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.grey.shade900),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: AppTextStyles.appBarTitleSize,
    ),
  ),
  drawerTheme: DrawerThemeData(backgroundColor: Colors.grey[900]),
  listTileTheme: ListTileThemeData(
    selectedColor: Colors.white,
    selectedTileColor: Colors.blue.shade800,
    iconColor: Colors.white,
    textColor: Colors.white,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    displayLarge: TextStyle(
      fontSize: AppTextStyles.displayLargeSize,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displayMedium: TextStyle(
      fontSize: AppTextStyles.displayMediumSize,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
  colorScheme: AppThemeData.colorSchemeDark,
  focusColor: Colors.blue.shade600,
  cardColor: Colors.grey.shade800,
  elevatedButtonTheme: AppThemeData.elevatedButtonTheme,
);

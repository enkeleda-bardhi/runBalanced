import 'dart:ui';
import 'package:flutter/material.dart';

/// Enhanced color system with semantic colors
class AppColors {
  // Primary theme colors
  static const Color primary = Color(0xFF1976D2);
  static const Color secondary = Color(0xFF90CAF9);
  static const Color tertiary = Color.fromARGB(255, 193, 193, 193);
  static const Color secondaryLight = Color.fromARGB(255, 196, 224, 247);

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
  static const Color cardioFatigue = Colors.red;
  static const Color jointFatigue = Colors.orange;
  static const Color muscleFatigue = Colors.green;

  // UI colors
  static const Color surface = Color(0xFFF8FAFB); // Light mode surface
  static const Color onSurface = Color(0xFF1E1E1E); // Text on light surfaces

  static const Color darkSurface = Color(0xFF2A2A2A); // Dark mode surface
  static const Color darkCardBackground = Color(
    0xFF202020,
  ); // Card bg in dark mode

  // Timer gradients
  static const List<Color> timerGradient = [primary, secondary];
  static const List<Color> timerGradientDark = [
    Color(0xFF34245E),
    Color(0xFF3546A2),
  ];

  // Card colors
  static const Color cardBackgroundLight = Colors.white;
  static const Color cardBorderLight = primary;
  static const Color cardShadowLight = Color.fromRGBO(0, 0, 0, 0.1);
  static const Color cardBorderDark = Color.fromRGBO(100, 100, 255, 0.7);
  static const Color cardShadowDark = Color.fromRGBO(0, 0, 0, 0.5);
}

/// Spacing system
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

/// Color schemes
final ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.primary,
  onPrimary: Colors.white,
  secondary: AppColors.secondary,
  onSecondary: Colors.black,
  error: AppColors.error,
  onError: Colors.white,
  surface: AppColors.surface,
  onSurface: AppColors.onSurface,
  background: AppColors.surface,
  onBackground: AppColors.onSurface,
);

final ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: AppColors.primary,
  onPrimary: Colors.black,
  secondary: AppColors.secondary,
  onSecondary: Colors.white,
  error: AppColors.error,
  onError: Colors.black,
  surface: AppColors.darkSurface,
  onSurface: Colors.white,
  background: Color.fromARGB(255, 47, 47, 47),
  onBackground: Colors.white,
);

/// Theme definitions
ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.surface,
  canvasColor: AppColors.surface,
  iconTheme: const IconThemeData(color: AppColors.primary),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.onSurface,
    foregroundColor: AppColors.surface,
    iconTheme: const IconThemeData(color: AppColors.surface),
    titleTextStyle: TextStyle(
      color: AppColors.surface,
      fontSize: AppTextStyles.appBarTitleSize,
    ),
  ),
  drawerTheme: const DrawerThemeData(backgroundColor: AppColors.surface),
  listTileTheme: const ListTileThemeData(
    selectedColor: AppColors.surface,
    selectedTileColor: AppColors.secondary,
    iconColor: AppColors.primary,
    textColor: AppColors.onSurface,
  ),
  textTheme: TextTheme(
    bodyLarge: const TextStyle(color: AppColors.onSurface),
    bodyMedium: const TextStyle(color: AppColors.onSurface),
    displayLarge: AppTextStyles.headline1.copyWith(color: AppColors.onSurface),
    displayMedium: AppTextStyles.headline2.copyWith(color: AppColors.onSurface),
  ),
  cardColor: AppColors.cardBackgroundLight,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 14),
      textStyle: AppTextStyles.body1.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.surface,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(AppColors.primary),
      textStyle: WidgetStateProperty.resolveWith((states) {
        return AppTextStyles.body1.copyWith(
          fontWeight: FontWeight.w500,
          decoration:
              states.contains(WidgetState.hovered)
                  ? TextDecoration.underline
                  : null,
        );
      }),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.secondaryLight, width: 2),
      borderRadius: BorderRadius.circular(4),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.tertiary, width: 1),
      borderRadius: BorderRadius.circular(4),
    ),
    labelStyle: const TextStyle(color: AppColors.tertiary),
    floatingLabelStyle: const TextStyle(color: AppColors.tertiary),
  ),
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  scaffoldBackgroundColor: darkColorScheme.background,
  canvasColor: darkColorScheme.background,
  iconTheme: IconThemeData(color: darkColorScheme.onSurface),
  appBarTheme: AppBarTheme(
    backgroundColor: darkColorScheme.surface,
    foregroundColor: darkColorScheme.onSurface,
    iconTheme: IconThemeData(color: darkColorScheme.onSurface),
    titleTextStyle: TextStyle(
      color: darkColorScheme.onSurface,
      fontSize: AppTextStyles.appBarTitleSize,
    ),
  ),
  drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF1A1A1A)),
  listTileTheme: ListTileThemeData(
    selectedColor: AppColors.surface,
    selectedTileColor: AppColors.secondary,
    iconColor: AppColors.primary,
    textColor: AppColors.surface,
  ),
  textTheme: TextTheme(
    bodyLarge: const TextStyle(color: AppColors.surface),
    bodyMedium: const TextStyle(color: AppColors.surface),
    displayLarge: AppTextStyles.headline1.copyWith(color: AppColors.surface),
    displayMedium: AppTextStyles.headline2.copyWith(color: AppColors.surface),
  ),
  cardColor: AppColors.darkCardBackground,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 14),
      textStyle: AppTextStyles.body1.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.surface,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(AppColors.secondary),
      textStyle: WidgetStateProperty.resolveWith((states) {
        return AppTextStyles.body1.copyWith(
          fontWeight: FontWeight.w500,
          decoration:
              states.contains(WidgetState.hovered)
                  ? TextDecoration.underline
                  : null,
        );
      }),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.secondaryLight, width: 2),
      borderRadius: BorderRadius.circular(4),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(4),
    ),
    labelStyle: TextStyle(color: Colors.grey[500]),
    floatingLabelStyle: const TextStyle(color: AppColors.secondaryLight),
  ),
);

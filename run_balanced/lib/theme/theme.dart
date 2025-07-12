import 'package:flutter/material.dart';

/// Enhanced color system with semantic colors
class AppColors {
  // Primary theme colors (using your existing deep purple)
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
  static const Color cardioFatigue = Colors.red; // Red for cardio fatigue
  static const Color jointFatigue = Colors.orange; // Orange for joint fatigue
  static const Color muscleFatigue = Colors.green; // Green for muscle fatigue

  // UI colors
  static const Color surface = Color.fromARGB(255, 248, 250, 251);
  static const Color onSurface = Color.fromARGB(255, 30, 30, 30);

  // Timer specific gradients (using your primary color)
  static const List<Color> timerGradient = [primary, secondary];

  static const List<Color> timerGradientDark = [
    Color.fromARGB(255, 52, 36, 94), // Darker purple for dark mode
    Color.fromARGB(255, 53, 70, 162),
  ];

  // Card colors for light mode
  static const Color cardBackgroundLight = Colors.white;
  static const Color cardBorderLight = primary;
  static const Color cardShadowLight = Color.fromRGBO(0, 0, 0, 0.1);

  // Card colors for dark mode
  static const Color cardBackgroundDark = Color(0xFF121212);
  static const Color cardBorderDark = Color.fromRGBO(100, 100, 255, 0.7);
  static const Color cardShadowDark = Color.fromRGBO(0, 0, 0, 0.5);
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
  surface: AppColors.onSurface,
  onSurface: AppColors.surface,
  background: AppColors.onSurface,
  onBackground: AppColors.surface,
);

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: lightColorScheme.surface,
  canvasColor: lightColorScheme.surface,
  iconTheme: IconThemeData(color: AppColors.primary),
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
      textStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.hovered)) {
          return AppTextStyles.body1.copyWith(
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
          );
        }
        return AppTextStyles.body1.copyWith(fontWeight: FontWeight.w500);
      }),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      padding: WidgetStateProperty.all(EdgeInsets.zero),
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
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: const Color.fromARGB(255, 185, 0, 0),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(4),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: const Color.fromARGB(255, 185, 0, 0),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(4),
    ),
    labelStyle: TextStyle(color: AppColors.tertiary), // Normal label style
    floatingLabelStyle: TextStyle(
      color: AppColors.tertiary,
    ), // Label color when focused
  ),
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: darkColorScheme.surface,
  canvasColor: darkColorScheme.surface,
  iconTheme: IconThemeData(color: AppColors.secondary), // light icons
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.onSurface, // dark app bar background
    foregroundColor: AppColors.surface, // light text/icons
    iconTheme: IconThemeData(color: AppColors.surface),
    titleTextStyle: TextStyle(
      color: AppColors.surface,
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

  cardColor: AppColors.cardBackgroundDark,
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
      textStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.hovered)) {
          return AppTextStyles.body1.copyWith(
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
          );
        }
        return AppTextStyles.body1.copyWith(fontWeight: FontWeight.w500);
      }),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      padding: WidgetStateProperty.all(EdgeInsets.zero),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.secondaryLight, width: 2),
      borderRadius: BorderRadius.circular(4),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(4),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: const Color.fromARGB(255, 185, 0, 0),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(4),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: const Color.fromARGB(255, 185, 0, 0),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(4),
    ),
    labelStyle: TextStyle(color: Colors.grey[500]),
    floatingLabelStyle: TextStyle(color: AppColors.secondaryLight),
  ),
);

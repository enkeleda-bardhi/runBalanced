import 'package:flutter/material.dart';
import 'package:run_balanced/theme/app_colors.dart';
import 'package:run_balanced/theme/app_spacing.dart';
import 'package:run_balanced/theme/app_text_styles.dart';

class AppThemeData {
  static ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    ),
  );

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
  useMaterial3: true,
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
  useMaterial3: true,
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

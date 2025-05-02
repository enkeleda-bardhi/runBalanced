import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.deepPurple,
  scaffoldBackgroundColor: Colors.white,
  canvasColor: Colors.white,
  iconTheme: IconThemeData(color: Colors.black),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 22,
    ), // Larger font size
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
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ), // Main titles
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ), // Subheadings
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.light,
  ),
  focusColor: Colors.lightBlue.shade200, // Lighter blue for more contrast
  cardColor: Colors.grey.shade50, // Light grey for card background
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple, // Button color
      foregroundColor: Colors.white, // Text color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 20,
      ), // Button padding
    ),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.deepPurple,
  scaffoldBackgroundColor: Colors.black,
  canvasColor: Colors.black,
  iconTheme: IconThemeData(color: Colors.grey.shade900),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.grey.shade900),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 22,
    ), // Larger font size
  ),
  drawerTheme: DrawerThemeData(backgroundColor: Colors.grey[900]),
  listTileTheme: ListTileThemeData(
    selectedColor: Colors.white,
    selectedTileColor: Colors.blue.shade800, // Darker blue for dark mode
    iconColor: Colors.white,
    textColor: Colors.white,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ), // Main titles
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ), // Subheadings
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.dark,
  ),
  focusColor: Colors.blue.shade600, // Slightly brighter blue for dark mode
  cardColor: Colors.grey.shade800, // Dark grey for card background
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple, // Button color
      foregroundColor: Colors.white, // Text color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 20,
      ), // Button padding
    ),
  ),
);

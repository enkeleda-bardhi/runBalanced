import 'package:flutter/material.dart';

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

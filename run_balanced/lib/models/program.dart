import 'package:flutter/material.dart';

class Program {
  final String title;
  final String subtitle;
  final String duration;
  final String difficulty;
  final String description;
  final IconData icon;
  final Map<String, List<String>> schedule;

  Program({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.difficulty,
    required this.description,
    required this.icon,
    required this.schedule,
  });
}

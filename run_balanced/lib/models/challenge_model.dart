import 'package:flutter/material.dart';

class Challenge {
  final int id;
  final String title;
  final String description;
  final int durationDays;
  final List<String> benefits;
  final List<String> tips;
  final IconData icon;
  final String quote;
  bool isJoined;
  DateTime? joinedDate;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.durationDays,
    required this.benefits,
    required this.tips,
    required this.icon,
    required this.quote,
    this.isJoined = false,
    this.joinedDate,
  });
}

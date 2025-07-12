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

  static List<Challenge> sampleChallenges = [
    Challenge(
      id: 1,
      title: "10K Steps a Day",
      description:
          "Walk 10,000 steps every day for 30 days to boost your cardiovascular health and daily energy.",
      durationDays: 30,
      icon: Icons.directions_walk,
      benefits: [
        "Improves cardiovascular fitness",
        "Burns calories and supports weight loss",
        "Boosts mood and energy levels",
      ],
      tips: [
        "Take short walking breaks throughout the day",
        "Use a step tracker app or wearable",
        "Walk with a friend or listen to podcasts",
      ],
      quote: "The journey of a thousand miles begins with a single step.",
    ),
    Challenge(
      id: 2,
      title: "Hydration Boost",
      description:
          "Drink 2 liters of water every day for 21 days to improve skin, energy, and digestion.",
      durationDays: 21,
      icon: Icons.local_drink,
      benefits: [
        "Improves skin clarity",
        "Boosts energy and focus",
        "Supports healthy digestion",
      ],
      tips: [
        "Keep a water bottle with you at all times",
        "Add lemon or mint for flavor",
        "Set reminders to drink regularly",
      ],
      quote:
          "Drink water like it's your job — because your body depends on it.",
      isJoined: true, // Example of a joined challenge
      joinedDate: DateTime.now().subtract(
        Duration(days: 5),
      ), // Example joined date
    ),
    Challenge(
      id: 3,
      title: "Daily Meditation",
      description:
          "Meditate for 10 minutes daily for 14 days to reduce stress and improve mental clarity.",
      durationDays: 14,
      icon: Icons.self_improvement,
      benefits: [
        "Reduces stress and anxiety",
        "Improves focus and attention",
        "Enhances emotional well-being",
      ],
      tips: [
        "Use guided meditation apps",
        "Start with just a few minutes and build up",
        "Create a quiet and comfortable space",
      ],
      quote: "Quiet the mind, and the soul will speak.",
    ),
    Challenge(
      id: 4,
      title: "Screen-Free Evenings",
      description:
          "Avoid screens (phone, TV, computer) after 8 PM to improve sleep and reduce digital fatigue.",
      durationDays: 10,
      icon: Icons.nights_stay,
      benefits: [
        "Improves sleep quality and duration",
        "Reduces eye strain and mental fatigue",
        "Encourages more mindful evening routines",
      ],
      tips: [
        "Set a daily screen curfew alarm",
        "Keep devices out of your bedroom",
        "Use the evening for reading, journaling, or light stretching",
      ],
      quote: "Disconnect to reconnect — your mind deserves rest too.",
    ),
    Challenge(
      id: 5,
      title: "Gratitude Journal",
      description:
          "Write down 3 things you're grateful for every day for 21 days to boost positivity and mental health.",
      durationDays: 21,
      icon: Icons.edit_note,
      benefits: [
        "Increases overall happiness",
        "Reduces stress and anxiety",
        "Improves self-esteem and resilience",
      ],
      tips: [
        "Keep your journal by your bedside",
        "Reflect on both big and small things",
        "Review past entries to see your growth",
      ],
      quote: "Gratitude turns what we have into enough.",
      isJoined: true, // Example of a joined challenge
      joinedDate: DateTime.now().subtract(
        Duration(days: 10),
      ), // Example joined date
    ),
  ];
}

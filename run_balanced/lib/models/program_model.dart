import 'package:flutter/material.dart';

class Program {
  final String title;
  final String subtitle;
  final String description;
  final String duration;
  final String difficulty;
  final IconData icon;
  final Map<String, List<String>> schedule; // Add this line

  Program({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.icon,
    required this.schedule, // Add this line
  });

  static List<Program> samplePrograms = [
    Program(
      title: "5K Beginner",
      subtitle: "Learn to run 5km in 6 weeks",
      description:
          "This beginner-friendly plan helps you gradually build endurance to complete a 5K run without injury.",
      duration: "6 weeks",
      difficulty: "Beginner",
      icon: Icons.directions_run,
      schedule: {
        "Week 1": ["Walk 5 min", "Run 1 min", "Repeat x5"],
        "Week 2": ["Walk 4 min", "Run 2 min", "Repeat x5"],
        "Week 3": ["Walk 3 min", "Run 3 min", "Repeat x5"],
        "Week 4": ["Walk 2 min", "Run 4 min", "Repeat x5"],
        "Week 5": ["Walk 1 min", "Run 5 min", "Repeat x5"],
        "Week 6": ["Run 20 min continuously"],
      },
    ),
    Program(
      title: "Joint-Friendly Workouts",
      subtitle: "Low impact training to protect your joints",
      description:
          "Perfect for users with joint concerns. All exercises are low-impact and designed to reduce strain.",
      duration: "4 weeks",
      difficulty: "Easy",
      icon: Icons.directions_walk,
      schedule: {
        "Week 1": ["Chair squats", "Wall pushups", "Leg raises"],
        "Week 2": ["Yoga stretches", "Side steps", "Planks"],
        "Week 3": ["Seated marches", "Resistance band pulls", "Bridges"],
        "Week 4": ["Step-ups", "Bird-dogs", "Toe taps"],
      },
    ),
    Program(
      title: "Mobility Boost",
      subtitle: "Improve joint range of motion",
      description:
          "This program focuses on dynamic stretches and joint mobility exercises to keep you flexible.",
      duration: "3 weeks",
      difficulty: "Intermediate",
      icon: Icons.accessibility_new,
      schedule: {
        "Week 1": ["Hip circles", "Arm swings", "Ankle rolls"],
        "Week 2": ["Deep squats", "Shoulder rolls", "Lunges"],
        "Week 3": [
          "Cossack squats",
          "Thoracic rotations",
          "World’s Greatest Stretch",
        ],
      },
    ),
    Program(
      title: "Posture Fix",
      subtitle: "Strengthen your back and core",
      description:
          "Target back, glutes, and abs to improve posture and reduce lower back pain with guided sessions.",
      duration: "5 weeks",
      difficulty: "Intermediate",
      icon: Icons.fitness_center,
      schedule: {
        "Week 1": ["Superman pose", "Bird-dog", "Bridge"],
        "Week 2": ["Dead bug", "Side plank", "Wall angels"],
        "Week 3": ["Glute kicks", "Cat-cow", "Pallof press"],
        "Week 4": ["Reverse plank", "Cobra stretch", "Back extensions"],
        "Week 5": ["Side leg lifts", "Shoulder shrugs", "Scapular retractions"],
      },
    ),
  ];
}

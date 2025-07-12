import 'package:flutter/material.dart';
import '../models/challenge_model.dart';
import '../theme/theme.dart'; // make sure this is imported
import 'challenge_detail_screen.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  List<Challenge> allChallenges = [
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
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final myChallenges = allChallenges.where((c) => c.isJoined).toList();
    final otherChallenges = allChallenges.where((c) => !c.isJoined).toList();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          if (myChallenges.isNotEmpty) ...[
            Text(
              "My Challenges",
              style: AppTextStyles.headline2.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...myChallenges.map(
              (challenge) => _buildChallengeCard(challenge, colorScheme),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          Text(
            "New Challenges",
            style: AppTextStyles.headline2.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...otherChallenges.map(
            (challenge) => _buildChallengeCard(challenge, colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(Challenge challenge, ColorScheme colorScheme) {
    return Card(
      color: colorScheme.surface,
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        leading: Icon(Icons.flag, size: 32, color: colorScheme.primary),
        title: Text(
          challenge.title,
          style: AppTextStyles.headline2.copyWith(color: colorScheme.onSurface),
        ),
        subtitle: Text(
          "${challenge.durationDays} days",
          style: AppTextStyles.caption.copyWith(color: colorScheme.secondary),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: colorScheme.secondary,
        ),
        onTap: () async {
          final updatedChallenge = await Navigator.push<Challenge>(
            context,
            MaterialPageRoute(
              builder: (_) => ChallengeDetailScreen(challenge: challenge),
            ),
          );

          if (updatedChallenge != null) {
            setState(() {
              final index = allChallenges.indexWhere(
                (c) => c.id == updatedChallenge.id,
              );
              if (index != -1) {
                allChallenges[index] = updatedChallenge;
              }
            });
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/challenge_model.dart';
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
      description: "Walk 10,000 steps every day for 30 days.",
      durationDays: 30,
    ),
    Challenge(
      id: 2,
      title: "Hydration Boost",
      description: "Drink 2L of water daily for 21 days.",
      durationDays: 21,
    ),
    Challenge(
      id: 3,
      title: "Daily Meditation",
      description: "Meditate 10 minutes every day for 14 days.",
      durationDays: 14,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final myChallenges = allChallenges.where((c) => c.isJoined).toList();
    final otherChallenges = allChallenges.where((c) => !c.isJoined).toList();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (myChallenges.isNotEmpty) ...[
            Text("My Challenges", style: theme.textTheme.displayMedium),
            const SizedBox(height: 8),
            ...myChallenges.map((challenge) => _buildChallengeCard(challenge)),
            const SizedBox(height: 24),
          ],
          Text("Challenges", style: theme.textTheme.displayMedium),
          const SizedBox(height: 8),
          ...otherChallenges.map((challenge) => _buildChallengeCard(challenge)),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(Challenge challenge) {
    final theme = Theme.of(context);

    return Card(
      color: theme.cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const Icon(Icons.flag, size: 32),
        title: Text(challenge.title, style: theme.textTheme.bodyLarge),
        subtitle: Text(
          "${challenge.durationDays} days",
          style: theme.textTheme.bodyMedium,
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
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

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
  final allChallenges = Challenge.sampleChallenges;
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

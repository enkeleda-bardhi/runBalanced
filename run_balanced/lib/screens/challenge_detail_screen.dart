import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/challenge_model.dart';
import '../theme/theme.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final Challenge challenge;

  const ChallengeDetailScreen({super.key, required this.challenge});

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  late Challenge challenge;

  @override
  void initState() {
    super.initState();
    challenge = widget.challenge;
  }

  void toggleJoinStatus() {
    setState(() {
      challenge.isJoined = !challenge.isJoined;
      challenge.joinedDate = challenge.isJoined ? DateTime.now() : null;
    });
  }

  int getProgressDays() {
    if (challenge.joinedDate == null) return 0;
    final now = DateTime.now();
    return now.difference(challenge.joinedDate!).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(challenge.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                challenge.icon,
                size: 64,
                color: theme.iconTheme.color,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(challenge.description, style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.md),
            Text(
              "Duration: ${challenge.durationDays} days",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            if (challenge.isJoined) ...[
              Text(
                "Joined on: ${DateFormat.yMMMd().format(challenge.joinedDate!)}",
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                "Progress: ${getProgressDays()} / ${challenge.durationDays} days",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              LinearProgressIndicator(
                value: getProgressDays() / challenge.durationDays,
                color: color.primary,
                backgroundColor: color.surface.withOpacity(0.3),
                minHeight: 6,
              ),
            ],

            // Benefits Section
            const SizedBox(height: AppSpacing.lg),
            Text("Benefits", style: theme.textTheme.displayMedium),
            const SizedBox(height: AppSpacing.sm),
            ...challenge.benefits.map(
              (b) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "• ",
                      style: TextStyle(
                        fontSize: 18,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Expanded(child: Text(b, style: theme.textTheme.bodyLarge)),
                  ],
                ),
              ),
            ),

            // Tips Section
            const SizedBox(height: AppSpacing.lg),
            Text("Tips for Success", style: theme.textTheme.displayMedium),
            const SizedBox(height: AppSpacing.sm),
            ...challenge.tips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "• ",
                      style: TextStyle(
                        fontSize: 18,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Expanded(
                      child: Text(tip, style: theme.textTheme.bodyLarge),
                    ),
                  ],
                ),
              ),
            ),

            // Motivational Quote
            const SizedBox(height: AppSpacing.lg),
            Text("Motivational Quote", style: theme.textTheme.displayMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '"${challenge.quote}"',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                color: color.secondary,
              ),
            ),

            // Join / Leave Button
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton(
              onPressed: () {
                toggleJoinStatus();
                Navigator.pop(context, challenge);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.sm,
                ),
                child: Text(
                  challenge.isJoined ? "Leave Challenge" : "Join Challenge",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

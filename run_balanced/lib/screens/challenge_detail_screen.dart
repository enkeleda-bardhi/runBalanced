import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/challenge_model.dart';

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
      if (challenge.isJoined) {
        challenge.joinedDate = DateTime.now();
      } else {
        challenge.joinedDate = null;
      }
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

    return Scaffold(
      appBar: AppBar(title: Text(challenge.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(challenge.description, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            Text(
              "Duration: ${challenge.durationDays} days",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            if (challenge.isJoined) ...[
              Text(
                "Joined on: ${DateFormat.yMMMd().format(challenge.joinedDate!)}",
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                "Progress: ${getProgressDays()} / ${challenge.durationDays} days",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  toggleJoinStatus();
                  Navigator.pop(context, challenge);
                },
                child: const Text("Leave Challenge"),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: () {
                  toggleJoinStatus();
                  Navigator.pop(context, challenge);
                },
                child: const Text("Join Challenge"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

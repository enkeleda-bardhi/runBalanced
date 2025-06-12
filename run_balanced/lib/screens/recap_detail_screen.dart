import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:run_balanced/models/training_session.dart'; // your model file path

class RecapDetailScreen extends StatelessWidget {
  final TrainingSession session;

  const RecapDetailScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormatted = DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(session.timestamp);

    return Scaffold(
      appBar: AppBar(title: Text("Session Details")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Icon(Icons.directions_run, size: 60, color: theme.iconTheme.color),
            const SizedBox(height: 16),
            Text(
              "Session on $dateFormatted",
              style: theme.textTheme.displayMedium,
            ),
            const SizedBox(height: 12),
            Text("Time: ${session.time}", style: theme.textTheme.bodyLarge),
            Text(
              "Distance: ${session.distance.toStringAsFixed(2)} km",
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              "Calories: ${session.calories.toStringAsFixed(2)}",
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              "Pace: ${session.pace.toStringAsFixed(2)}",
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Text("Physiological Metrics", style: theme.textTheme.displayMedium),
            const SizedBox(height: 12),
            Text(
              "Breath: ${session.breath.toStringAsFixed(2)}%",
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              "Joints: ${session.joints.toStringAsFixed(2)}%",
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              "Muscles: ${session.muscles.toStringAsFixed(2)}%",
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

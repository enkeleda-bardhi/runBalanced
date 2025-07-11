import 'package:flutter/material.dart';
import 'package:run_balanced/models/program_model.dart';

class ProgramDetailScreen extends StatelessWidget {
  final Program program;

  const ProgramDetailScreen({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(program.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Icon(program.icon, size: 60, color: theme.iconTheme.color),
          const SizedBox(height: 16),
          Text(program.subtitle, style: theme.textTheme.displayMedium),
          const SizedBox(height: 12),
          Text(
            "Duration: ${program.duration}",
            style: theme.textTheme.bodyLarge,
          ),
          Text(
            "Difficulty: ${program.difficulty}",
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Text("About This Program", style: theme.textTheme.displayMedium),
          const SizedBox(height: 8),
          Text(program.description, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 24),
          Text("Weekly Schedule", style: theme.textTheme.displayMedium),
          const SizedBox(height: 12),
          ...program.schedule.entries
              .map((entry) => _buildDayCard(entry, theme))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildDayCard(MapEntry<String, List<String>> entry, ThemeData theme) {
    return Card(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(entry.key, style: theme.textTheme.bodyLarge),
        children:
            entry.value
                .map(
                  (exercise) => ListTile(
                    title: Text(exercise, style: theme.textTheme.bodyMedium),
                    dense: true,
                    visualDensity: VisualDensity.compact,
                  ),
                )
                .toList(),
      ),
    );
  }
}

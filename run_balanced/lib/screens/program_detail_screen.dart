import 'package:flutter/material.dart';
import 'package:run_balanced/models/program_model.dart';
import 'package:run_balanced/theme/theme.dart';

class ProgramDetailScreen extends StatelessWidget {
  final Program program;

  const ProgramDetailScreen({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          program.title,
          style: theme.textTheme.displayMedium?.copyWith(
            color: color.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Icon(program.icon, size: 64, color: color.primary)),
            const SizedBox(height: AppSpacing.lg),
            Text(program.subtitle, style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.md),
            Text(
              "Duration: ${program.duration}",
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              "Difficulty: ${program.difficulty}",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text("About This Program", style: theme.textTheme.displayMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(program.description, style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.xl),
            Text("Weekly Schedule", style: theme.textTheme.displayMedium),
            const SizedBox(height: AppSpacing.sm),
            ...program.schedule.entries
                .map((entry) => _buildDayCard(entry, theme))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(MapEntry<String, List<String>> entry, ThemeData theme) {
    final color = theme.colorScheme;

    return Card(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.primary, width: 1.5),
      ),
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: ExpansionTile(
        title: Text(entry.key, style: theme.textTheme.bodyLarge),
        tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        childrenPadding: const EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: AppSpacing.md,
        ),
        shape: const RoundedRectangleBorder(),
        collapsedShape: const RoundedRectangleBorder(),
        children:
            entry.value
                .map(
                  (exercise) => ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.zero,
                    title: Text(exercise, style: theme.textTheme.bodyMedium),
                  ),
                )
                .toList(),
      ),
    );
  }
}

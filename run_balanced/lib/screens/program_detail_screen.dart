import 'package:flutter/material.dart';
import 'package:run_balanced/models/program_model.dart';
import 'package:run_balanced/theme/theme.dart';

class ProgramDetailScreen extends StatelessWidget {
  final Program program;

  const ProgramDetailScreen({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          program.title,
          style: AppTextStyles.headline2.copyWith(color: colorScheme.onSurface),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Icon(program.icon, size: 60, color: colorScheme.primary),
          const SizedBox(height: AppSpacing.lg),
          Text(
            program.subtitle,
            style: AppTextStyles.headline2.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            "Duration: ${program.duration}",
            style: AppTextStyles.body1.copyWith(color: colorScheme.onSurface),
          ),
          Text(
            "Difficulty: ${program.difficulty}",
            style: AppTextStyles.body1.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            "About This Program",
            style: AppTextStyles.headline2.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            program.description,
            style: AppTextStyles.body1.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            "Weekly Schedule",
            style: AppTextStyles.headline2.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...program.schedule.entries
              .map((entry) => _buildDayCard(entry, colorScheme))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildDayCard(
    MapEntry<String, List<String>> entry,
    ColorScheme colorScheme,
  ) {
    return Card(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: ExpansionTile(
        title: Text(
          entry.key,
          style: AppTextStyles.body1.copyWith(color: colorScheme.onSurface),
        ),
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
                    title: Text(
                      exercise,
                      style: AppTextStyles.body1.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

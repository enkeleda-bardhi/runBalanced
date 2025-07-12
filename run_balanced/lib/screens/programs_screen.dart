import 'package:flutter/material.dart';
import 'package:run_balanced/models/program_model.dart';
import 'package:run_balanced/theme/theme.dart';
import 'program_detail_screen.dart';

class ProgramsScreen extends StatefulWidget {
  const ProgramsScreen({super.key});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  final allPrograms = Program.samplePrograms;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const SizedBox(height: AppSpacing.sm),
          ...allPrograms.map(
            (program) => _buildProgramCard(context, program, color),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramCard(
    BuildContext context,
    Program program,
    ColorScheme color,
  ) {
    return Card(
      color: color.surface,
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.primary, width: 1.5),
      ),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        leading: Icon(program.icon, size: 40, color: color.primary),
        title: Text(
          program.title,
          style: AppTextStyles.headline2.copyWith(color: color.onSurface),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xs),
            Text(
              program.subtitle,
              style: AppTextStyles.body1.copyWith(color: color.onSurface),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Icon(Icons.timer, size: 16, color: color.secondary),
                const SizedBox(width: 4),
                Text(
                  program.duration,
                  style: AppTextStyles.caption.copyWith(color: color.secondary),
                ),
                const SizedBox(width: AppSpacing.md),
                Icon(Icons.fitness_center, size: 16, color: color.secondary),
                const SizedBox(width: 4),
                Text(
                  program.difficulty,
                  style: AppTextStyles.caption.copyWith(color: color.secondary),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: color.secondary,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProgramDetailScreen(program: program),
            ),
          );
        },
      ),
    );
  }
}

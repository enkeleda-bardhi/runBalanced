import 'package:flutter/material.dart';
import 'package:run_balanced/models/program_model.dart';
import 'package:run_balanced/theme/theme.dart';
import 'program_detail_screen.dart';

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final programs = Program.samplePrograms;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView.builder(
          itemCount: programs.length,
          itemBuilder: (context, index) {
            final program = programs[index];

            return Card(
              color: colorScheme.surface, // fixed background
              elevation: 3,
              shadowColor: Colors.black.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colorScheme.primary, width: 1.5),
              ),
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProgramDetailScreen(program: program),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(program.icon, size: 40, color: colorScheme.primary),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              program.title,
                              style: AppTextStyles.headline2.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              program.subtitle,
                              style: AppTextStyles.body1.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                Icon(
                                  Icons.timer,
                                  size: 16,
                                  color: colorScheme.secondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  program.duration,
                                  style: AppTextStyles.caption.copyWith(
                                    color: colorScheme.secondary,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Icon(
                                  Icons.fitness_center,
                                  size: 16,
                                  color: colorScheme.secondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  program.difficulty,
                                  style: AppTextStyles.caption.copyWith(
                                    color: colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

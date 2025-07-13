import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:run_balanced/providers/simulation_provider.dart';
import 'package:run_balanced/screens/recap_detail_screen.dart';
import 'package:run_balanced/widgets/loading_spinner_widget.dart';
import 'package:run_balanced/models/exercise.dart';
import 'package:run_balanced/theme/theme.dart';
import 'package:run_balanced/models/utilities.dart';

class RecapScreen extends StatelessWidget {
  const RecapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SimulationProvider>(
      builder: (context, dataProvider, child) {
        final sessions = dataProvider.savedSessions;
        final exerciseSessions = dataProvider.exerciseSessions;
        final theme = Theme.of(context);
        final color = theme.colorScheme;

        return Scaffold(
          body:
              dataProvider.isLoading
                  ? const Center(child: LoadingSpinnerWidget())
                  : (sessions.isEmpty && exerciseSessions.isEmpty)
                  ? Center(
                    child: Text(
                      "No saved sessions",
                      style: theme.textTheme.titleLarge,
                    ),
                  )
                  : SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (sessions.isNotEmpty) ...[
                          Text(
                            "Training Sessions",
                            style: AppTextStyles.headline2.copyWith(
                              color: color.onSurface,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ...sessions.map(
                            (session) => _buildSessionCard(session, context),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                        if (exerciseSessions.isNotEmpty) ...[
                          Text(
                            "Past Exercise Sessions",
                            style: AppTextStyles.headline2.copyWith(
                              color: color.onSurface,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ...exerciseSessions.map(
                            (session) =>
                                _buildExerciseSessionCard(session, context),
                          ),
                        ],
                      ],
                    ),
                  ),
        );
      },
    );
  }

  Widget _buildSessionCard(dynamic session, BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final dateFormatted = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).format(session.timestamp);

    return Card(
      color: color.surface,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.primary, width: 1.5),
      ),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecapDetailScreen(session: session),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.directions_run, size: 32, color: color.primary),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      "Session on $dateFormatted",
                      style: AppTextStyles.headline2.copyWith(
                        color: color.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: color.secondary,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.sm,
                children: [
                  _buildStat(theme, Icons.timer_outlined, session.time),
                  _buildStat(
                    theme,
                    Icons.space_bar_outlined,
                    "${session.distance.toStringAsFixed(2)} km",
                  ),
                  _buildStat(
                    theme,
                    Icons.speed_outlined,
                    "${formatPace(session.avgPace)} min/km",
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Divider(height: 20, color: color.tertiary.withOpacity(0.4)),
              Text(
                "Avg. Heart Rate: ${session.avgHeartRate?.toStringAsFixed(0)} bpm",
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                "Calories: ${session.calories.toStringAsFixed(0)} kcal",
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseSessionCard(
    ExerciseSession session,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    String formatDuration(double? seconds) {
      if (seconds == null) return "N/A";
      final minutes = (seconds / 60).round();
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      return hours > 0 ? "${hours}h ${mins}m" : "${mins}m";
    }

    String formatDistance(double? distance, String? unit) {
      if (distance == null) return "N/A";
      return "${distance.toStringAsFixed(2)} ${unit ?? 'km'}";
    }

    return Card(
      color: color.surface,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.primary, width: 1.5),
      ),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getActivityIcon(session.activityName ?? 'unknown'),
                  size: 32,
                  color: color.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    session.activityName ?? 'Unknown Activity',
                    style: AppTextStyles.headline2.copyWith(
                      color: color.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              "Duration: ${formatDuration(session.duration)}",
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              "Distance: ${formatDistance(session.distance, session.distanceUnit)}",
              style: theme.textTheme.bodyMedium,
            ),
            if (session.calories != null)
              Text(
                "Calories: ${session.calories!.toStringAsFixed(0)} kcal",
                style: theme.textTheme.bodyMedium,
              ),
            if (session.averageHeartRate != null)
              Text(
                "Avg Heart Rate: ${session.averageHeartRate} bpm",
                style: theme.textTheme.bodyMedium,
              ),
            if (session.steps != null)
              Text(
                "Steps: ${session.steps}",
                style: theme.textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(ThemeData theme, IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.iconTheme.color?.withOpacity(0.8)),
        const SizedBox(width: 4),
        Text(value, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  IconData _getActivityIcon(String activityName) {
    switch (activityName.toLowerCase()) {
      case 'corsa':
        return Icons.directions_run;
      case 'camminata':
        return Icons.directions_walk;
      case 'bici':
        return Icons.directions_bike;
      default:
        return Icons.help_outline;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:run_balanced/providers/simulation_provider.dart';
import 'package:run_balanced/screens/recap_detail_screen.dart';
import 'package:run_balanced/widgets/loading_spinner_widget.dart';
import 'package:run_balanced/models/exercise.dart';

class RecapScreen extends StatelessWidget {
  const RecapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SimulationProvider>(
      builder: (context, dataProvider, child) {
        final sessions = dataProvider.savedSessions;
        final exerciseSessions = dataProvider.exerciseSessions;
        final theme = Theme.of(context);

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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Original Training Sessions
                        if (sessions.isNotEmpty) ...[
                          ...sessions.map((session) {
                            final dateFormatted = DateFormat(
                              'yyyy-MM-dd HH:mm',
                            ).format(session.timestamp);

                            return Card(
                              color: theme.cardColor,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: Icon(
                                  Icons.directions_run,
                                  color: theme.iconTheme.color,
                                  size: 32,
                                ),
                                title: Text(
                                  "Session on $dateFormatted",
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        if (constraints.maxWidth < 400) {
                                          // Small screen: show stats in a column
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildStat(
                                                theme,
                                                Icons.timer_outlined,
                                                session.time,
                                              ),
                                              const SizedBox(height: 8),
                                              _buildStat(
                                                theme,
                                                Icons.space_bar_outlined,
                                                "${session.distance.toStringAsFixed(2)} km",
                                              ),
                                              const SizedBox(height: 8),
                                              _buildStat(
                                                theme,
                                                Icons.speed_outlined,
                                                "${session.avgPace?.toStringAsFixed(2)} min/km",
                                              ),
                                            ],
                                          );
                                        } else {
                                          // Large screen: show stats in a row
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              _buildStat(
                                                theme,
                                                Icons.timer_outlined,
                                                session.time,
                                              ),
                                              const SizedBox(width: 24),
                                              _buildStat(
                                                theme,
                                                Icons.space_bar_outlined,
                                                "${session.distance.toStringAsFixed(2)} km",
                                              ),
                                              const SizedBox(width: 24),
                                              _buildStat(
                                                theme,
                                                Icons.speed_outlined,
                                                "${session.avgPace?.toStringAsFixed(2)} min/km",
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                    const Divider(height: 20),
                                    Text(
                                      "Avg. Heart rate: ${session.avgHeartRate?.toStringAsFixed(0)} bpm",
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    Text(
                                      "Calories: ${session.calories.toStringAsFixed(0)} kcal",
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                                isThreeLine: true,
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: theme.iconTheme.color,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => RecapDetailScreen(
                                            session: session,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        ],

                        // Exercise Sessions Section
                        if (exerciseSessions.isNotEmpty) ...[
                          if (sessions.isNotEmpty) const SizedBox(height: 24),
                          Text(
                            "Past Exercise Sessions",
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...exerciseSessions.map(
                            (session) =>
                                _buildExerciseSessionCard(session, theme),
                          ),
                        ],
                      ],
                    ),
                  ),
        );
      },
    );
  }

  Widget _buildStat(ThemeData theme, IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.iconTheme.color?.withOpacity(0.8)),
        const SizedBox(width: 4),
        Text(value, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildExerciseSessionCard(ExerciseSession session, ThemeData theme) {
    // Convert duration from minutes to a readable format
    String formatDuration(double? seconds) {
      if (seconds == null) return "N/A";
      final minutes = (seconds / 60).round();
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      if (hours > 0) {
        return "${hours}h ${mins}m";
      }
      return "${mins}m";
    }

    // Format distance with unit
    String formatDistance(double? distance, String? unit) {
      if (distance == null) return "N/A";
      return "${distance.toStringAsFixed(2)} ${unit ?? 'km'}";
    }

    return Card(
      color: theme.cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          _getActivityIcon(session.activityName ?? 'unknown'),
          color: theme.primaryColor,
          size: 32,
        ),
        title: Text(
          session.activityName ?? 'Unknown Activity',
          style: theme.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
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
        isThreeLine: true,
        trailing: Icon(Icons.fitness_center, color: theme.iconTheme.color),
      ),
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

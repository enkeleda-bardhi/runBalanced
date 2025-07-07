import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:run_balanced/providers/data_provider.dart';
import 'package:run_balanced/screens/recap_detail_screen.dart';
import 'package:run_balanced/widgets/loading_spinner_widget.dart';
import 'package:run_balanced/models/exercise.dart';

class RecapScreen extends StatefulWidget {
  const RecapScreen({super.key});

  @override
  _RecapScreenState createState() => _RecapScreenState();
}

class _RecapScreenState extends State<RecapScreen> {
  late DataProvider data;

  @override
  void initState() {
    super.initState();
    // Fetch sessions once when screen initializes
    // Use listen: false because we don't want to rebuild on this call
    data = Provider.of<DataProvider>(context, listen: false);
    data.fetchAllSessions(); // This will fetch both training and exercise sessions
  }

  @override
  Widget build(BuildContext context) {
    data = Provider.of<DataProvider>(context);
    final sessions = data.savedSessions.toList();
    final exerciseSessions = data.exerciseSessions.toList();
    final theme = Theme.of(context);

    // Debug prints
    print('Training sessions count: ${sessions.length}');
    print('Exercise sessions count: ${exerciseSessions.length}');
    print('Is loading: ${data.isLoading}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recap'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              print('Manual refresh triggered');
              await data.fetchAllSessions();
            },
          ),
        ],
      ),
      body: data.isLoading
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
                            'yyyy-MM-dd HH:mm:ss',
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
                                  Text(
                                    "Time: ${session.time}",
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    "Distance: ${session.distance.toStringAsFixed(2)} km",
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    "Pace: ${session.avgPace?.toStringAsFixed(2)} min/km",
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    "Calories: ${session.calories.toStringAsFixed(2)} kcal",
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    "Heart rate: ${session.avgHeartRate?.toStringAsFixed(2)} bpm",
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    "Breath: ${session.avgBreath?.toStringAsFixed(2)}%",
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    "Joints: ${session.avgJoints?.toStringAsFixed(2)}%",
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    "Muscles: ${session.avgMuscles?.toStringAsFixed(2)}%",
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
                                    builder: (_) => RecapDetailScreen(session: session),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ],
                      
                      // Exercise Sessions Section (new addition)
                      if (exerciseSessions.isNotEmpty) ...[
                        if (sessions.isNotEmpty) const SizedBox(height: 24),
                        Text(
                          "Past Exercise Sessions",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...exerciseSessions.map((session) => _buildExerciseSessionCard(session, theme)),
                      ] else ...[
                        // Debug section - show even when no exercise sessions
                        if (sessions.isNotEmpty) const SizedBox(height: 24),
                        Text(
                          "Exercise Sessions",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "No exercise sessions found. Check debug console for API errors.",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
            if (session.time != null)
              Text(
                "Time: ${session.time}",
                style: theme.textTheme.bodyMedium,
              ),
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
        trailing: Icon(
          Icons.fitness_center,
          color: theme.iconTheme.color,
        ),
      ),
    );
  }

  IconData _getActivityIcon(String activityName) {
    switch (activityName.toLowerCase()) {
      case 'run':
      case 'running':
        return Icons.directions_run;
      case 'walk':
      case 'walking':
        return Icons.directions_walk;
      case 'bike':
      case 'cycling':
        return Icons.directions_bike;
      case 'swim':
      case 'swimming':
        return Icons.pool;
      case 'workout':
      case 'fitness':
        return Icons.fitness_center;
      default:
        return Icons.sports;
    }
  }
}

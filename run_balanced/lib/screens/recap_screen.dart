import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:run_balanced/providers/data_provider.dart';
import 'package:run_balanced/screens/recap_detail_screen.dart';

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
    data.fetchTrainingSessions();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to DataProvider updates here
    data = Provider.of<DataProvider>(context);

    // Map savedSessions to TrainingSession objects, reversed for most recent first
    final sessions = data.savedSessions.toList();

    final theme = Theme.of(context);

    return Scaffold(
      body:
          sessions.isEmpty
              ? Center(
                child: Text(
                  "No saved sessions",
                  style: theme.textTheme.titleLarge,
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
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
                },
              ),
    );
  }
}

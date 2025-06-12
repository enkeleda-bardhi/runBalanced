import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:run_balanced/models/training_session.dart';
import 'package:run_balanced/widgets/line_chart_widget.dart';

class RecapDetailScreen extends StatelessWidget {
  final TrainingSession session;

  const RecapDetailScreen({super.key, required this.session});

  List<FlSpot> _convertToSpots(List<Map<String, dynamic>> data, String key) {
    return data.map((entry) {
      final x = (entry['time'] as int).toDouble();
      final y = (entry[key] as num).toDouble();
      return FlSpot(x, y);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormatted = DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(session.timestamp);

    // Defensive check in case rhythmSnapshots is null or empty
    final rhythmSnapshots = session.rhythmSnapshots ?? [];

    final distanceSpots = _convertToSpots(rhythmSnapshots, 'km');
    final rhythmSpots = _convertToSpots(rhythmSnapshots, 'rhythm');

    return Scaffold(
      appBar: AppBar(title: const Text("Session Details")),
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
              "Calories: ${session.calories.toStringAsFixed(0)}",
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
              "Breath: ${session.breath.toStringAsFixed(1)}%",
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              "Joints: ${session.joints.toStringAsFixed(1)}%",
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              "Muscles: ${session.muscles.toStringAsFixed(1)}%",
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 30),

            // Line Chart: Time vs Distance
            GeneralLineChart(
              title: 'Time vs Distance',
              spots: distanceSpots,
              xAxisLabel: 'Time (s)',
              yAxisLabel: 'Distance (km)',
              lineColor: Colors.blue,
            ),

            const SizedBox(height: 30),

            // Line Chart: Time vs Pace
            GeneralLineChart(
              title: 'Time vs Pace',
              spots: rhythmSpots,
              xAxisLabel: 'Time (s)',
              yAxisLabel: 'Pace (min/km)',
              lineColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

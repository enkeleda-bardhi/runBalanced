import 'package:run_balanced/screens/metric_detail_screen.dart';
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

    final dataSnapshots = session.dataSnapshots ?? [];

    final distanceSpots = _convertToSpots(dataSnapshots, 'distance');
    final paceSpots = _convertToSpots(dataSnapshots, 'pace');
    final heartRateSpots = _convertToSpots(dataSnapshots, 'heartRate');

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
              "Avg. pace: ${session.avgPace?.toStringAsFixed(2)} min/km",
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              "Calories: ${session.calories.toStringAsFixed(2)} kcal",
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              "Avg. heart rate: ${session.avgHeartRate?.toStringAsFixed(0)} bpm",
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Text("Physiological Metrics", style: theme.textTheme.displayMedium),
            const SizedBox(height: 12),
            // BREATH
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MetricDetailScreen(
                      metricName: 'Breath',
                      spots: _convertToSpots(dataSnapshots, 'breath'),
                      unit: '%',
                      color: Colors.teal,
                    ),
                  ),
                );
              },
              child: Text(
                "Avg. breath: ${session.avgBreath?.toStringAsFixed(1)}%",
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.teal),
              ),
            ),

// JOINTS
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MetricDetailScreen(
                      metricName: 'Joints',
                      spots: _convertToSpots(dataSnapshots, 'joints'),
                      unit: '%',
                      color: Colors.orange,
                    ),
                  ),
                );
              },
              child: Text(
                "Avg. joints: ${session.avgJoints?.toStringAsFixed(1)}%",
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.orange),
              ),
            ),

// MUSCLES
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MetricDetailScreen(
                      metricName: 'Muscles',
                      spots: _convertToSpots(dataSnapshots, 'muscles'),
                      unit: '%',
                      color: Colors.green,
                    ),
                  ),
                );
              },
              child: Text(
                "Avg. muscles: ${session.avgMuscles?.toStringAsFixed(1)}%",
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.green),
              ),
            ),


            // Line Chart: Distance
            GeneralLineChart(
              title: 'Distance',
              spots: distanceSpots,
              xAxisLabel: 'Time (s)',
              yAxisLabel: 'Distance (km)',
              lineColor: Colors.blue,
              fixedMaxY: null,
            ),

            const SizedBox(height: 30),

            // Line Chart: Pace
            GeneralLineChart(
              title: 'Pace',
              spots: paceSpots,
              xAxisLabel: 'Time (s)',
              yAxisLabel: 'Pace (min/km)',
              lineColor: Colors.red,
              fixedMaxY: 20,
            ),
            const SizedBox(height: 30),

            // Line Chart: Heart rate
            GeneralLineChart(
              title: 'Heart rate',
              spots: heartRateSpots,
              xAxisLabel: 'Time (s)',
              yAxisLabel: 'Pace (min/km)',
              lineColor: Colors.purple,
              fixedMaxY: 180,
            ),
          ],
        ),
      ),
    );
  }
}

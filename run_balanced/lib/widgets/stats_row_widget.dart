import 'package:flutter/material.dart';
import 'package:run_balanced/models/utilities.dart';

class StatsRowWidget extends StatelessWidget {
  final double distance;
  final double calories;
  final double pace;
  final int heartRate;

  const StatsRowWidget({
    super.key,
    required this.distance,
    required this.calories,
    required this.pace,
    required this.heartRate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(
              label: "Distance (km)",
              value: distance.toStringAsFixed(2),
            ),
            _StatItem(
              label: "Pace (min/km)",
              value: formatPace(pace),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(label: "Heart rate (bpm)", value: heartRate.toString()),
            _StatItem(
              label: "Calories (kcal)",
              value: calories.toStringAsFixed(2),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}

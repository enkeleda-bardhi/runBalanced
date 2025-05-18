import 'package:flutter/material.dart';

class StatsRowWidget extends StatelessWidget {
  final double distance;
  final int calories;
  final double pace;

  const StatsRowWidget({
    required this.distance,
    required this.calories,
    required this.pace,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatItem(label: "Distanza (km)", value: distance.toStringAsFixed(2)),
        _StatItem(label: "Calorie (kcal)", value: calories.toString()),
        _StatItem(label: "Ritmo (min/km)", value: pace.toStringAsFixed(2)),
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
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label),
      ],
    );
  }
}

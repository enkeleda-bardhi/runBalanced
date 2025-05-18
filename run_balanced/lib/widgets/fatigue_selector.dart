// TODO Implement this library.
//PULSANTI INTERATTIVI
import 'package:flutter/material.dart';
import 'package:run_balanced/models/activity.dart';
import '../screens/fatigue_detail_screen.dart';

class FatigueSelector extends StatelessWidget {
  final Activity activity;

  const FatigueSelector({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          child: Text("Joints"),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FatigueDetailScreen(title: "Joints", data: activity.jointData)),
          ),
        ),
        ElevatedButton(
          child: Text("Cardio"),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FatigueDetailScreen(title: "Cardio", data: activity.cardioData)),
          ),
        ),
        ElevatedButton(
          child: Text("Muscles"),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FatigueDetailScreen(title: "Muscles", data: activity.muscleData)),
          ),
        ),
      ],
    );
  }
}

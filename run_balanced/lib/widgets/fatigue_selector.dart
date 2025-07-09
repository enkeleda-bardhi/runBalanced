// TODO Implement this library.
//PULSANTI INTERATTIVI
import 'package:flutter/material.dart';
import 'package:run_balanced/models/training_session.dart'; 
import '../screens/fatigue_detail_screen.dart';

class FatigueSelector extends StatelessWidget {
  final TrainingSession session;
  const FatigueSelector({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          child: Text("Joints"),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FatigueDetailScreen(title: "Joints", data: session.getJointData())),
          ),
        ),
        ElevatedButton(
          child: Text("Cardio"),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FatigueDetailScreen(title: "Cardio", data: session.getCardioData())),
          ),
        ),
        ElevatedButton(
          child: Text("Muscles"),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FatigueDetailScreen(title: "Muscles", data: session.getMuscleData())),
          ),
        ),
      ],
    );
  }
}

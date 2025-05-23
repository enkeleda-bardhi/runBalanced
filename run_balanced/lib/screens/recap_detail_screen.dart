//SELEZIONE AFFATICAMENTO
import 'package:flutter/material.dart';
import 'package:run_balanced/models/activity.dart';
import '../widgets/fatigue_selector.dart';

class RecapDetailScreen extends StatelessWidget {
  final Activity activity;

  RecapDetailScreen({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dettagli Allenamento")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Seleziona una sezione da approfondire:", style: TextStyle(fontSize: 18)),
          ),
          FatigueSelector(activity: activity),
        ],
      ),
    );
  }
}

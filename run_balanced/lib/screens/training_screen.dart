import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:run_balanced/screens/recap_screen.dart';
import 'package:run_balanced/widgets/timer_widget.dart';
import 'package:run_balanced/widgets/stats_row_widget.dart';
import 'package:run_balanced/widgets/progress_bar_widget.dart';
import 'package:run_balanced/widgets/controls_widget.dart';
import 'package:run_balanced/providers/data_provider.dart';

class TrainingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Allenamento")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TimerWidget(time: data.formattedTime),
            StatsRowWidget(
              distance: data.distance,
              calories: data.calories,
              pace: data.pace,
            ),
            const SizedBox(height: 20),
            ProgressBarWidget(
              label: "Respiro",
              value: data.breathState,
            ),
            ProgressBarWidget(
              label: "Articolazioni",
              value: data.jointState,
            ),
            ProgressBarWidget(
              label: "Muscoli",
              value: data.muscleState,
            ),
            const Spacer(),
            ControlsWidget(
              onStart: data.startSimulation,
              onPause: data.pauseSimulation,
              onReset: data.reset,
              onStopSave: () async {
                try {
                  await data.save(); // salva i dati
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RecapScreen()),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Errore durante il salvataggio")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}


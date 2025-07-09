import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:run_balanced/screens/recap_detail_screen.dart';
import 'package:run_balanced/widgets/timer_widget.dart';
import 'package:run_balanced/widgets/stats_row_widget.dart';
import 'package:run_balanced/widgets/progress_bar_widget.dart';
import 'package:run_balanced/widgets/controls_widget.dart';
import 'package:run_balanced/providers/simulation_provider.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TimerWidget(time: data.formattedTime),
            StatsRowWidget(
              distance: data.distance,
              calories: data.calories,
              pace: data.pace,
              heartRate: data.heartRate,
            ),
            const SizedBox(height: 20),
            ProgressBarWidget(label: "Cardio Fatigue", value: data.breathState),
            ProgressBarWidget(label: "Joint Fatigue", value: data.jointState),
            ProgressBarWidget(label: "Muscle Fatigue", value: data.muscleState),
            const Spacer(),
            ControlsWidget(
              onPlayPause: data.togglePlayPause,
              onReset: data.reset,
              // Use the new getter from the provider instead of a hardcoded value
              isPlaying: data.isPlaying,
              onStopSave: () async {
                try {
                  final session = await data.save(); // save the data
                  if (context.mounted && session != null) {
                    data.reset();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecapDetailScreen(session: session),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error while saving")));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

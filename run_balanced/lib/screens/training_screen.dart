import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:run_balanced/screens/recap_detail_screen.dart';
import 'package:run_balanced/widgets/timer_widget.dart';
import 'package:run_balanced/widgets/stats_row_widget.dart';
import 'package:run_balanced/widgets/progress_bar_widget.dart';
import 'package:run_balanced/widgets/controls_widget.dart';
import 'package:run_balanced/providers/data_provider.dart';
import 'package:run_balanced/theme/app_spacing.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DataProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            TimerWidget(time: data.formattedTime),
            StatsRowWidget(
              distance: data.distance,
              calories: data.calories,
              pace: data.pace,
              heartRate: data.heartRate,
            ),
            const SizedBox(height: AppSpacing.lg),
            ProgressBarWidget(label: "Breath", value: data.breathState),
            ProgressBarWidget(label: "Joints", value: data.jointState),
            ProgressBarWidget(label: "Muscles", value: data.muscleState),
            const Spacer(),
            ControlsWidget(
              onStart: data.startSimulation,
              onPause: data.pauseSimulation,
              onReset: data.reset,
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error while saving")),
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

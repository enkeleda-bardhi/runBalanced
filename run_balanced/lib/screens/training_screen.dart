import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:run_balanced/providers/simulation_provider.dart';
import 'package:run_balanced/screens/recap_detail_screen.dart';
import 'package:run_balanced/widgets/animated_fatigue_widget.dart';
import 'package:run_balanced/widgets/controls_widget.dart';
import 'package:run_balanced/widgets/stats_row_widget.dart';
import 'package:run_balanced/widgets/timer_widget.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a Consumer to listen for changes in SimulationProvider
    return Consumer<SimulationProvider>(
      builder: (context, data, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TimerWidget(time: data.formattedTime),
                const SizedBox(height: 20),
                StatsRowWidget(
                  distance: data.distance,
                  calories: data.calories,
                  pace: data.pace,
                  heartRate: data.heartRate,
                ),
                const SizedBox(height: 20),
                AnimatedFatigueWidget(
                  label: "Cardio Fatigue",
                  value: data.cardioState,
                  subtitle: "Based on HR, SpO2, and more",
                ),
                const SizedBox(height: 12),
                AnimatedFatigueWidget(
                  label: "Joint Fatigue",
                  value: data.jointState,
                  subtitle: "Based on impact and repetition",
                ),
                const SizedBox(height: 12),
                AnimatedFatigueWidget(
                  label: "Muscle Fatigue",
                  value: data.muscleState,
                  subtitle: "Based on biomechanical asymmetry",
                ),
                const Spacer(),
                ControlsWidget(
                  onPlayPause: data.togglePlayPause,
                  onReset: data.reset,
                  isPlaying: data.isPlaying,
                  onStopSave: () async {
                    try {
                      final session = await data.save();
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
                      debugPrint('Error saving session: $e');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to save session: $e')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

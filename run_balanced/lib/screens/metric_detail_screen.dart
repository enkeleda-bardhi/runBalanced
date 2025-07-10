import 'package:flutter/material.dart';
import 'package:run_balanced/models/training_session.dart';
import 'package:run_balanced/theme/theme.dart';

enum FatigueMetricType {
  muscles,
  joints,
  cardio,
}

class MetricDetailScreen extends StatelessWidget {
  final TrainingSession session;
  final FatigueMetricType metricType;

  const MetricDetailScreen({
    super.key,
    required this.session,
    required this.metricType,
  });

  @override
  Widget build(BuildContext context) {
    late String title;
    late IconData icon;
    late Color color;
    late List<double?> fatiguePerKm;
    late double averageFatigue;

    switch (metricType) {
      case FatigueMetricType.muscles:
        title = 'Muscular Fatigue';
        icon = Icons.fitness_center;
        color = AppColors.muscleFatigue;
        fatiguePerKm = session.getMuscleData();
        averageFatigue = session.avgMuscles ?? 0;
        break;
      case FatigueMetricType.joints:
        title = 'Joint Fatigue';
        icon = Icons.personal_injury_outlined;
        color = AppColors.jointFatigue;
        fatiguePerKm = session.getJointData();
        averageFatigue = session.avgJoints ?? 0;
        break;
      case FatigueMetricType.cardio:
        title = 'Cardio Fatigue';
        icon = Icons.monitor_heart;
        color = AppColors.cardioFatigue;
        fatiguePerKm = session.getCardioData();
        averageFatigue = session.avgCardio ?? 0;
        break;
    }

    final double maxFatigue = fatiguePerKm.isEmpty ? 0.0 : fatiguePerKm.whereType<double>().fold<double>(0, (prev, elem) => elem > prev ? elem : prev);
    final int maxFatigueKm = fatiguePerKm.isEmpty ? 0 : fatiguePerKm.indexWhere((v) => v == maxFatigue) + 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.onSurface,
        elevation: 0,
      ),
      backgroundColor: AppColors.surface,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 30, color: color),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text('Fatigue per km', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  final double maxBarWidth = constraints.maxWidth - 120; // 60 for label + 50 for value + 10 for spacing
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: fatiguePerKm.length,
                    itemBuilder: (context, index) {
                      final value = fatiguePerKm[index];
                      if (value == null) {
                        return const SizedBox.shrink();
                      }
                      final barWidth = (value / 100) * maxBarWidth; 
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            SizedBox(width: 60, child: Text('KM ${index + 1}', style: const TextStyle(fontSize: 14))),
                            Expanded(
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  Container(
                                    width: barWidth,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: _getBarColor(value),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(width: 50, child: Text('${value.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 14))),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              //if (fatiguePerKm.whereType<double>().length > 2) ...[
                const SizedBox(height: 30),
                const Text('Deviation from baseline of fatigue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(
                  'Average: ${averageFatigue.toStringAsFixed(1)}%   Max: ${maxFatigue.toStringAsFixed(1)}% in km $maxFatigueKm',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.start,
                  children: List.generate(fatiguePerKm.length, (index) {
                    final kmFatigue = fatiguePerKm[index];
                    if (kmFatigue == null) {
                      return const SizedBox.shrink();
                    }
                    final deviation = kmFatigue - averageFatigue;
                    final sign = deviation > 0 ? '+' : '';
                    final color = deviation >= 0 ? Colors.red.shade700 : Colors.green.shade700;

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: color.withOpacity(0.5)),
                      ),
                      child: Text(
                        'KM ${index + 1}: $sign${deviation.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    );
                  }),
                ),
              //],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBarColor(double? value) {
    switch (metricType) {
      case FatigueMetricType.muscles:
        return AppColors.muscleFatigue;
      case FatigueMetricType.joints:
        return AppColors.jointFatigue;
      case FatigueMetricType.cardio:
        return AppColors.cardioFatigue;
    }
  }
}

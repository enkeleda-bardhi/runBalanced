import 'package:flutter/material.dart';
import 'package:run_balanced/models/training_session.dart';
import 'package:run_balanced/theme/theme.dart';

enum FatigueMetricType { muscles, joints, cardio }

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    late String title;
    late IconData icon;
    late Color fatigueColor;
    late List<double?> fatiguePerKm;
    late double averageFatigue;

    switch (metricType) {
      case FatigueMetricType.muscles:
        title = 'Muscular Fatigue';
        icon = Icons.fitness_center;
        fatigueColor = AppColors.muscleFatigue;
        fatiguePerKm = session.getMuscleData();
        averageFatigue = session.avgMuscles ?? 0;
        break;
      case FatigueMetricType.joints:
        title = 'Joint Fatigue';
        icon = Icons.personal_injury_outlined;
        fatigueColor = AppColors.jointFatigue;
        fatiguePerKm = session.getJointData();
        averageFatigue = session.avgJoints ?? 0;
        break;
      case FatigueMetricType.cardio:
        title = 'Cardio Fatigue';
        icon = Icons.monitor_heart;
        fatigueColor = AppColors.cardioFatigue;
        fatiguePerKm = session.getCardioData();
        averageFatigue = session.avgCardio ?? 0;
        break;
    }

    final double maxFatigue =
        fatiguePerKm.isEmpty
            ? 0.0
            : fatiguePerKm.whereType<double>().fold<double>(
              0,
              (prev, elem) => elem > prev ? elem : prev,
            );
    final int maxFatigueKm =
        fatiguePerKm.isEmpty
            ? 0
            : fatiguePerKm.indexWhere((v) => v == maxFatigue) + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      backgroundColor: colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Centered Icon
              Center(child: Icon(icon, size: 60, color: fatigueColor)),

              const SizedBox(height: 30),
              Text(
                'Fatigue per km',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              LayoutBuilder(
                builder: (context, constraints) {
                  final double maxBarWidth = constraints.maxWidth - 120;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: fatiguePerKm.length,
                    itemBuilder: (context, index) {
                      final value = fatiguePerKm[index];
                      if (value == null) return const SizedBox.shrink();

                      final barWidth = (value / 100) * maxBarWidth;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: Text(
                                'KM ${index + 1}',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                            Expanded(
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: colorScheme.surfaceVariant
                                          .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  Container(
                                    width: barWidth,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: fatigueColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 50,
                              child: Text(
                                '${value.toStringAsFixed(1)}%',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 30),
              Text(
                'Deviation from baseline of fatigue',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Average: ${averageFatigue.toStringAsFixed(1)}%   Max: ${maxFatigue.toStringAsFixed(1)}% in km $maxFatigueKm',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.start,
                children: List.generate(fatiguePerKm.length, (index) {
                  final kmFatigue = fatiguePerKm[index];
                  if (kmFatigue == null) return const SizedBox.shrink();

                  final deviation = kmFatigue - averageFatigue;
                  final sign = deviation > 0 ? '+' : '';
                  final color =
                      deviation >= 0
                          ? Colors.red.shade700
                          : Colors.green.shade700;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withOpacity(0.5)),
                    ),
                    child: Text(
                      'KM ${index + 1}: $sign${deviation.toStringAsFixed(1)}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:run_balanced/theme/theme.dart';

class ProgressBarWidget extends StatelessWidget {
  final String label;
  final double value; // da 0 a 100

  const ProgressBarWidget({required this.label, required this.value, super.key});

  Color getColor(double val) {
    if (val < 25) return AppColors.fatigueOptimal;
    if (val < 50) return AppColors.fatigueModerate;
    if (val < 75) return AppColors.fatigueHigh;
    return AppColors.fatigueCritical;
  }

  @override
  Widget build(BuildContext context) {
    final color = getColor(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: value / 100,
            minHeight: 16,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${value.toStringAsFixed(0)}%',
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
      ],
    );
  }
}

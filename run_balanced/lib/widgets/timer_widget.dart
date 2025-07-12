import 'package:flutter/material.dart';
import 'package:run_balanced/theme/theme.dart';

class TimerWidget extends StatelessWidget {
  final String time;

  const TimerWidget({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.timerGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'WORKOUT TIME',
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onPrimary.withOpacity(0.8),
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            time,
            style: AppTextStyles.timerTime.copyWith(
              color: colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

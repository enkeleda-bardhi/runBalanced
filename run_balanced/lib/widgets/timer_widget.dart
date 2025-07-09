import 'package:flutter/material.dart';
import 'package:run_balanced/theme/theme.dart';

class TimerWidget extends StatelessWidget {
  final String time;

  const TimerWidget({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
            ? AppColors.timerGradientDark
            : AppColors.timerGradient,
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
            style: AppTextStyles.timerLabel.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            time,
            style: AppTextStyles.timerTime.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

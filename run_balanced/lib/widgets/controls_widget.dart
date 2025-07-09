import 'package:flutter/material.dart';
import 'package:run_balanced/theme/theme.dart';

class ControlsWidget extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onReset;
  final VoidCallback onStopSave;

  const ControlsWidget({
    required this.isPlaying,
    required this.onPlayPause,
    required this.onReset,
    required this.onStopSave,
    super.key,
  });

  @override
  State<ControlsWidget> createState() => _ControlsWidgetState();
}

class _ControlsWidgetState extends State<ControlsWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Reset button
        // Stop/Reset button in secondary style
        OutlinedButton(
          onPressed: widget.onReset,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(AppSpacing.md),
            foregroundColor: AppColors.error,
            side: const BorderSide(color: AppColors.error, width: 2),
          ),
          child: const Row(
            children: [
              Icon(Icons.delete_forever, 
              color: AppColors.error,
              size: AppTextStyles.displayLargeSize,
            ),
          ],
        ),
      ),
        // Play/Pause toggle button
        ElevatedButton(
          onPressed: widget.onPlayPause,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.all(AppSpacing.xl),
            backgroundColor: widget.isPlaying ? AppColors.tertiary : AppColors.primary,
            shadowColor: widget.isPlaying ? AppColors.primary : AppColors.tertiary,
            elevation: widget.isPlaying ? 0 : 4,
            side: BorderSide(
              color: AppColors.primary,
              width: 2, 
            ),
          ),
          child: Icon(
            widget.isPlaying ? Icons.pause : Icons.play_arrow,
            size: AppTextStyles.displayLargeSize,
            color: widget.isPlaying ?  AppColors.primary :AppColors.tertiary,
          ),
          ),

        // Save button
        OutlinedButton(
          onPressed: widget.onStopSave,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(AppSpacing.md),
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 2),
          ),
          child: const Row(
            children: [
              Icon(Icons.save,
                color: AppColors.primary,
                size: AppTextStyles.displayLargeSize,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
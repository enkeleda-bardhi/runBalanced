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
        ElevatedButton(
          onPressed: widget.onReset,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(AppSpacing.md),
            foregroundColor: AppColors.error,
            side: const BorderSide(color: AppColors.error, width: 2),
          ),
          child: Row(
            children: [
              Icon(Icons.delete_forever, 
              color: AppColors.error,
              size: AppTextStyles.displayLargeSize,
                  ),
              ],
          ),
        ),
        
        // Play/Pause Button
        if (!widget.isPlaying)
          ElevatedButton(
            onPressed: widget.onPlayPause,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.all(AppSpacing.xl),
              backgroundColor: AppColors.primary,
              elevation: 4,
              side: BorderSide(
                color: AppColors.primary,
                width: 2, 
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.play_arrow,
                  size: AppTextStyles.displayLargeSize,
                ),
//                const SizedBox(width: AppSpacing.xl),
              ],
            ),
          )
        else
          ElevatedButton(
            onPressed: widget.onPlayPause,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.all(AppSpacing.xl),
              backgroundColor: AppColors.tertiary,
              elevation: 4,
              side: BorderSide(
                color: AppColors.primary,
                width: 2, 
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.pause,
                  size: AppTextStyles.displayLargeSize,
                  color: AppColors.primary,
                ),
//                const SizedBox(width: AppSpacing.xl),
              ],
            ),
          ),

      // Stop/Save button
      ElevatedButton(
        onPressed: widget.onStopSave,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(AppSpacing.md),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.secondary,
          side: BorderSide(
            color: AppColors.secondary,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.save, size: AppTextStyles.displayLargeSize),
          ],
        ),
      )
      ],
    );
  }
}
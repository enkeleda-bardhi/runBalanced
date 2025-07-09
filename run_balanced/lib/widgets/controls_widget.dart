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
            backgroundColor: AppColors.surface,
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
              padding: const EdgeInsets.all(0), // Remove padding from the button
              backgroundColor: Colors.transparent, // Make button transparent for the gradient
              shadowColor: Colors.transparent,
              elevation: 4,
            ),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xl), // Apply padding to the container
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                  border: Border.all(
                  color: Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.play_arrow,
                size: AppTextStyles.displayLargeSize + 3,
                color: AppColors.surface,
                
              ),
            ),
          )
        else
          ElevatedButton(
            onPressed: widget.onPlayPause,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(0), // Remove padding from the button
              backgroundColor: Colors.transparent, // Make button transparent
              shadowColor: Colors.transparent,
              elevation: 4,
            ),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xl), // Apply padding to the container
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface, // Use a solid color for the background
                border: Border.all( // Add the border here
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.pause,
                size: AppTextStyles.displayLargeSize + 3,
                color: AppColors.primary,
              ),
            ),
          ),

      // Stop/Save button
      ElevatedButton(
        onPressed: widget.onStopSave,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(AppSpacing.md),
          backgroundColor: AppColors.surface,
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
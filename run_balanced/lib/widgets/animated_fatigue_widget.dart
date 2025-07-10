import 'package:flutter/material.dart';
import '../theme/theme.dart';

class AnimatedFatigueWidget extends StatefulWidget {
  final String label;
  final double value;
  final String subtitle;
  
  const AnimatedFatigueWidget({
    super.key,
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  State<AnimatedFatigueWidget> createState() => _AnimatedFatigueWidgetState();
}

class _AnimatedFatigueWidgetState extends State<AnimatedFatigueWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedFatigueWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the value has changed, create a new animation from the old value to the new one.
    if (widget.value != oldWidget.value) {
      _animation = Tween<double>(begin: oldWidget.value, end: widget.value).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
      // Reset and restart the animation controller.
      _controller
        ..value = 0
        ..forward();
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Use the animation's value for the progress bar and the text labels
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Label and Percentage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  widget.label,
                  style: AppTextStyles.headline2.copyWith(
                    fontSize: 16,
                    color: theme.primaryColor,
                  ),
                ),
                Text(
                  '${_animation.value.toInt()}%', // Animate the text
                  style: AppTextStyles.headline2.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),

            // Progress Bar
            _buildProgressBar(_animation.value),
            SizedBox(height: AppSpacing.sm),

            // Bottom Row: Subtitle, Zone Label, and Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.subtitle,
                  style: AppTextStyles.body1.copyWith(
                    fontSize: 12,
                    color: theme.brightness == Brightness.dark 
                      ? Colors.grey[400] 
                      : Colors.grey[600],
                  ),
                ),
                Row( // Group the status indicators together
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: _getZoneColor(_animation.value).withAlpha(26),
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                        border: Border.all(
                          color: _getZoneColor(_animation.value).withAlpha(77),
                        ),
                      ),
                      child: Text(
                        _getZoneLabel(_animation.value), // Animate the label
                        style: AppTextStyles.caption.copyWith(
                          color: _getZoneColor(_animation.value),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.xs),
                    _buildStatusIcon(widget.value),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  
  Gradient _getBarGradient(double value) {
    // Clamp value to avoid division by zero or invalid stops.
    final clampedValue = value.clamp(1.0, 100.0);
    
    if (value < 40) {
      // In the first zone, the bar is a solid color.
      return LinearGradient(colors: [AppColors.fatigueOptimal, AppColors.fatigueOptimal]);
    } else if (value < 60) {
      // In the second zone, it's a gradient from the first color to the second.
      return LinearGradient(
        colors: [AppColors.fatigueOptimal, AppColors.fatigueModerate],
        stops: [40.0 / clampedValue, 1.0],
      );
    } else if (value < 80) {
      // In the third zone, it's a gradient through the first three colors.
      return LinearGradient(
        colors: [AppColors.fatigueOptimal, AppColors.fatigueModerate, AppColors.fatigueHigh],
        stops: [40.0 / clampedValue, 60.0 / clampedValue, 1.0],
      );
    } else {
      // In the final zone, the gradient includes all colors.
      return LinearGradient(
        colors: [
          AppColors.fatigueOptimal,
          AppColors.fatigueModerate,
          AppColors.fatigueHigh,
          AppColors.fatigueCritical
        ],
        stops: [40.0 / clampedValue, 60.0 / clampedValue, 80.0 / clampedValue, 1.0],
      );
    }
  }

  Widget _buildProgressBar(double value) {
    // LayoutBuilder gives us the maximum available width for the bar.
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        // Calculate the exact width of the progress bar based on the animated value.
        final barWidth = (value / 100).clamp(0.0, 1.0) * maxWidth;

        // Use a Stack to layer the background and the progress bar.
        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            // 1. The background bar (the track).
            // This is always visible and takes up the full width.
            Container(
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.grey[800] 
                  : Colors.grey[200],
              ),
            ),
            // 2. The foreground bar (the progress).
            // This container's width is animated, and it's filled with the gradient.
            // The Stack ensures it is always aligned to the left.
            Container(
              width: barWidth,
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: _getBarGradient(value),
              ),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildStatusIcon(double value) {
    final IconData icon;
    final Color color = _getZoneColor(value);
    
    if (value < 40) {
      icon = Icons.sentiment_very_satisfied;
    } else if (value < 60) {
      icon = Icons.sentiment_satisfied;
    } else if (value < 80) {
      icon = Icons.sentiment_neutral;
    } else {
      icon = Icons.sentiment_very_dissatisfied;
    }
    
    return Container(
      padding: EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }
  
  Color _getZoneColor(double value) {
    if (value < 40) {
      return AppColors.fatigueOptimal;
    } else if (value < 60) {
      return AppColors.fatigueModerate;
    } else if (value < 80) {
      return AppColors.fatigueHigh;
    } else {
      return AppColors.fatigueCritical;
    }
  }
  
  String _getZoneLabel(double value) {
    if (value < 40) {
      return 'OPTIMAL';
    } else if (value < 60) {
      return 'MODERATE';
    } else if (value < 80) {
      return 'HIGH';
    } else {
      return 'CRITICAL';
    }
  }
}

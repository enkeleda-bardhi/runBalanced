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
    _animation = Tween<double>(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedFatigueWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _animation = Tween<double>(
        begin: oldWidget.value,
        end: widget.value,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Label and Percentage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${_animation.value.toInt()}%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            _buildProgressBar(context, _animation.value),
            const SizedBox(height: AppSpacing.sm),

            // Bottom Row: Subtitle, Zone Label, and Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        theme.brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey[600],
                  ),
                ),
                Row(
                  // Group the status indicators together
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: _getZoneColor(_animation.value).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                        border: Border.all(
                          color: _getZoneColor(
                            _animation.value,
                          ).withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        _getZoneLabel(_animation.value),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _getZoneColor(_animation.value),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    _buildStatusIcon(context, _animation.value),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressBar(BuildContext context, double value) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final barWidth = (value / 100).clamp(0.0, 1.0) * maxWidth;

        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[800]
                        : Colors.grey[200],
              ),
            ),
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

  Widget _buildStatusIcon(BuildContext context, double value) {
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
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Gradient _getBarGradient(double value) {
    final clampedValue = value.clamp(1.0, 100.0);

    if (value < 40) {
      return LinearGradient(
        colors: [AppColors.fatigueOptimal, AppColors.fatigueOptimal],
      );
    } else if (value < 60) {
      return LinearGradient(
        colors: [AppColors.fatigueOptimal, AppColors.fatigueModerate],
        stops: [40.0 / clampedValue, 1.0],
      );
    } else if (value < 80) {
      return LinearGradient(
        colors: [
          AppColors.fatigueOptimal,
          AppColors.fatigueModerate,
          AppColors.fatigueHigh,
        ],
        stops: [40.0 / clampedValue, 60.0 / clampedValue, 1.0],
      );
    } else {
      return LinearGradient(
        colors: [
          AppColors.fatigueOptimal,
          AppColors.fatigueModerate,
          AppColors.fatigueHigh,
          AppColors.fatigueCritical,
        ],
        stops: [
          40.0 / clampedValue,
          60.0 / clampedValue,
          80.0 / clampedValue,
          1.0,
        ],
      );
    }
  }

  Color _getZoneColor(double value) {
    if (value < 40) return AppColors.fatigueOptimal;
    if (value < 60) return AppColors.fatigueModerate;
    if (value < 80) return AppColors.fatigueHigh;
    return AppColors.fatigueCritical;
  }

  String _getZoneLabel(double value) {
    if (value < 40) return 'OPTIMAL';
    if (value < 60) return 'MODERATE';
    if (value < 80) return 'HIGH';
    return 'CRITICAL';
  }
}

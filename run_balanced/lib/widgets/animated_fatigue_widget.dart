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
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.label,
                  style: AppTextStyles.headline2.copyWith(
                    fontSize: 18,
                    color: theme.primaryColor,
                  ),
                ),
                _buildStatusIcon(widget.value),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              widget.subtitle,
              style: AppTextStyles.body1.copyWith(
                fontSize: 14,
                color: theme.brightness == Brightness.dark 
                  ? Colors.grey[400] 
                  : Colors.grey[600],
              ),
            ),
            SizedBox(height: AppSpacing.md),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return _buildProgressBar(_animation.value);
              },
            ),
            SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.value.toInt()}%',
                  style: AppTextStyles.body1.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: _getZoneColor(widget.value).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                    border: Border.all(
                      color: _getZoneColor(widget.value).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _getZoneLabel(widget.value),
                    style: AppTextStyles.caption.copyWith(
                      color: _getZoneColor(widget.value),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProgressBar(double value) {
    return Container(
      height: 12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Theme.of(context).brightness == Brightness.dark 
          ? Colors.grey[800] 
          : Colors.grey[200],
      ),
      child: Stack(
        children: [
          // Background gradient showing zones
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: LinearGradient(
                colors: [
                  AppColors.fatigueOptimal,
                  AppColors.fatigueModerate,
                  AppColors.fatigueHigh,
                  AppColors.fatigueCritical,
                ],
                stops: [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
          // Actual progress indicator
          FractionallySizedBox(
            widthFactor: value / 100,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: _getZoneColor(value),
                boxShadow: [
                  BoxShadow(
                    color: _getZoneColor(value).withOpacity(0.4),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
        color: color.withOpacity(0.1),
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

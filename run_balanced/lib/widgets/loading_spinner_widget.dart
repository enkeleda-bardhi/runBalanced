import 'package:flutter/material.dart';

class LoadingSpinnerWidget extends StatelessWidget {
  final double size;

  const LoadingSpinnerWidget({super.key, this.size = 40.0});

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = Theme.of(context).primaryColor;

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 4,
          valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
        ),
      ),
    );
  }
}

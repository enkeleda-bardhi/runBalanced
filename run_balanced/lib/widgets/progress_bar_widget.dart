import 'package:flutter/material.dart';

class ProgressBarWidget extends StatelessWidget {
  final String label;
  final double value; // da 0 a 100

  const ProgressBarWidget({required this.label, required this.value});

  Color getColor(double val) {
    if (val < 60) return Colors.red;
    if (val < 80) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 5),
        LinearProgressIndicator(
          value: value / 100,
          valueColor: AlwaysStoppedAnimation(getColor(value)),
          backgroundColor: Colors.grey.shade300,
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

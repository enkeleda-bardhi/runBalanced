import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  final String time;

  const TimerWidget({required this.time});

  @override
  Widget build(BuildContext context) {
    return Text(
      time,
      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
    );
  }
}
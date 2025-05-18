// TODO Implement this library.
import 'package:flutter/material.dart';
import '../widgets/fatigue_chart_widget.dart';

class FatigueDetailScreen extends StatelessWidget {
  final String title;
  final List<double> data;

  const FatigueDetailScreen({required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Affaticamento $title")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FatigueChartWidget(title: title, data: data),
      ),
    );
  }
}
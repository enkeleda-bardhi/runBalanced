// TODO Implement this library.
import 'package:flutter/material.dart';

class FatigueChartWidget extends StatelessWidget {
  final String title;
  final List<double> data;

  const FatigueChartWidget({required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Grafico $title (in arrivo)\nDati: ${data.join(', ')}",
          textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:run_balanced/widgets/line_chart_widget.dart';

class MetricDetailScreen extends StatelessWidget {
  final String metricName;
  final List<FlSpot> spots;
  final String unit;
  final Color color;

  const MetricDetailScreen({
    super.key,
    required this.metricName,
    required this.spots,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$metricName Detail')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$metricName over Time',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GeneralLineChart(
                title: metricName,
                spots: spots,
                xAxisLabel: 'Time (s)', // oppure Distance
                yAxisLabel: '$metricName ($unit)',
                lineColor: color,
                fixedMaxY: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

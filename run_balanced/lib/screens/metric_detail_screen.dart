import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:run_balanced/widgets/line_chart_widget.dart';

/* POTER VARIARE A SECONDA DELA SEZIONE
class MetricConfig {
  final String name;
  final String unit;
  final Color color;
  final double? maxY;

  const MetricConfig({required this.name, required this.unit, required this.color, this.maxY});
}
*/
/*
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
*/
/*

class MuscularFatigueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muscular Fatigue',
      theme: ThemeData(fontFamily: 'Roboto'),
      home: Scaffold(
        backgroundColor: const Color(0xFFF8F5F0),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: MuscularFatigueScreen(),
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';

class MetricDetailScreen extends StatelessWidget {
  final List<int> fatiguePerKm = [58, 66, 66, 70, 20, 82, 30,49, 12]; // valori % per km
  final int averageFatigue = 74;
  final int maxFatigue = 92;
  final int maxFatigueKm = 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Row(
              children: const [
                Icon(Icons.fitness_center, size: 30, color: Colors.green),
                SizedBox(width: 10),
                Text(
                  'Muscular Fatigue',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Media: $averageFatigue%   Massima: $maxFatigue% al km $maxFatigueKm',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),
            const Text('Fatica per km', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(fatiguePerKm.length, (index) {
                    final value = fatiguePerKm[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('$value%', style: const TextStyle(fontSize: 14)),
                          Container(
                            height: value * 1.2,
                            width: 30,
                            decoration: BoxDecoration(
                              color: _getBarColor(value),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('KM ${index + 1}'),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Text('Deviazione della fatica', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text('+12%'),
                Text('-3%'),
                Text('+7%'),
                Text('0%'),
                Text('-5%'),
                Text('+7%'),
                Text('0%'),
                Text('-5%')
              ],
            ),

            const SizedBox(height: 30),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Affaticamento elevato',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('tra i km 4 e 5'),
                  ],
                ),
                const Spacer(),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: averageFatigue / 100,
                        backgroundColor: Colors.greenAccent.shade100,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        strokeWidth: 6,
                      ),
                    ),
                    Text(
                      '$averageFatigue%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getBarColor(int value) {
    if (value < 60) return Colors.orange;
    if (value < 70) return Colors.yellow.shade700;
    if (value < 85) return Colors.lightGreen;
    return Colors.green;
  }
}


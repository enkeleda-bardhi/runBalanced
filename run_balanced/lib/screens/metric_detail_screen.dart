import 'package:flutter/material.dart';

class MetricDetailScreen extends StatelessWidget {
  final List<int> fatiguePerKm = [58, 66, 66, 70, 20, 82, 30, 49, 12, 65, 89]; // valori % per km
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: fatiguePerKm.length,
              itemBuilder: (context, index) {
                final value = fatiguePerKm[index];
                final barWidth = value * 2.0; // max 200px se 100%
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      SizedBox(width: 60, child: Text('KM ${index + 1}', style: const TextStyle(fontSize: 14))),
                      Stack(
                        children: [
                          Container(
                            width: 200,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            width: barWidth.clamp(0.0, 200.0),
                            height: 20,
                            decoration: BoxDecoration(
                              color: _getBarColor(value),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Text('$value%', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                );
              },
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
                Text('-5%'),
                Text('-3%'),
                Text('+7%'),
                Text('0%')
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
                        backgroundColor: Colors.greenAccent,
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
    return Colors.green.shade800;
  }
}

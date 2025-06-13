import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GeneralLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final String title;
  final String xAxisLabel;
  final String yAxisLabel;
  final Color lineColor;
  final bool isCurved;
  final bool showDots;

  /// Optional fixed values for customization
  final double? fixedMinX;
  final double? fixedMaxX;
  final double? fixedXInterval;
  final double? fixedMaxY;

  const GeneralLineChart({
    super.key,
    required this.spots,
    required this.title,
    this.xAxisLabel = 'Time (s)',
    this.yAxisLabel = '',
    this.lineColor = Colors.blue,
    this.isCurved = true,
    this.showDots = false,
    this.fixedMinX,
    this.fixedMaxX,
    this.fixedXInterval,
    this.fixedMaxY,
  });

  @override
  Widget build(BuildContext context) {
    final minX = 0.0;
    final maxX =
        fixedMaxX ??
        ((spots.isNotEmpty ? spots.last.x : 10) / 10).ceil() * 10.0;
    final xInterval = 10.0;

    final minY = 0.0;
    final maxY =
        fixedMaxY ??
        (spots.isNotEmpty
            ? spots.map((s) => s.y).reduce((a, b) => a > b ? a : b)
            : 10.0);
    final yInterval = ((maxY - minY) / 5).clamp(1.0, double.infinity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: (spots.length * 20).toDouble().clamp(
                300,
                10000,
              ), // Adjust width
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ), // Adjust as needed
                child: LineChart(
                  LineChartData(
                    minX: minX,
                    maxX: maxX,
                    minY: minY,
                    maxY: maxY,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        axisNameWidget: Text(xAxisLabel),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          interval: xInterval,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(value.toInt().toString()),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        axisNameWidget: Text(yAxisLabel),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: yInterval,
                          getTitlesWidget: (value, meta) {
                            return Text(value.toStringAsFixed(1));
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: isCurved,
                        color: lineColor,
                        dotData: FlDotData(show: showDots),
                        barWidth: 3,
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              spot.y.toStringAsFixed(
                                3,
                              ), // Show value with 2 decimal places
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

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

  // Helper function to measure text size
  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    // Ensure spots are not empty to prevent range errors
    final aSpots = spots.isEmpty ? [const FlSpot(0, 0)] : spots;

    final minX = fixedMinX ?? aSpots.map((s) => s.x).reduce(min);
    final maxX = fixedMaxX ?? aSpots.map((s) => s.x).reduce(max);

    // --- Data Scaling Logic ---
    const double plotMinY = 0.0;
    const double plotMaxY = 100.0; // We'll plot on a standard 0-100 scale

    // Find the actual max Y value from the original data
    final actualMaxY = fixedMaxY ?? (aSpots.map((s) => s.y).reduce(max) * 1.2);
    final actualMinY = 0.0; // Assuming Y always starts at 0

    // Normalize the spots to fit the 0-100 plotting scale
    final scaledSpots = aSpots.map((spot) {
      final scaledY = plotMinY +
          (spot.y - actualMinY) * (plotMaxY - plotMinY) / (actualMaxY - actualMinY);
      return FlSpot(spot.x, scaledY.isNaN ? 0.0 : scaledY);
    }).toList();
    // --- End of Data Scaling Logic ---

    final yInterval = ((plotMaxY - plotMinY) / 5).clamp(1.0, double.infinity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: spots.isEmpty
              ? const Center(child: Text("No data available to display."))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final double xInterval = fixedXInterval ??
                        (maxX / (constraints.maxWidth / 80))
                            .clamp(1.0, double.infinity);

                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 8.0),
                      child: LineChart(
                        LineChartData(
                          minX: minX,
                          maxX: maxX,
                          minY: plotMinY, // Use fixed plotting min Y
                          maxY: plotMaxY, // Use fixed plotting max Y
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              axisNameWidget: Text(xAxisLabel,
                                  style: const TextStyle(fontSize: 12)),
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                interval: xInterval,
                                getTitlesWidget: (value, meta) {
                                  if (value == meta.max) return const SizedBox();
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(value.toInt().toString(),
                                        style: const TextStyle(fontSize: 10)),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              axisNameWidget: Text(yAxisLabel,
                                  style: const TextStyle(fontSize: 12)),
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40, // Can be a fixed size now
                                interval: yInterval,
                                getTitlesWidget: (value, meta) {
                                  // Convert the scaled label value back to the original value for display
                                  final originalValue = actualMinY +
                                      (value - plotMinY) *
                                          (actualMaxY - actualMinY) /
                                          (plotMaxY - plotMinY);
                                  return Text(
                                    originalValue.toStringAsFixed(1),
                                    style: const TextStyle(fontSize: 10),
                                    textAlign: TextAlign.left,
                                  );
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            getDrawingHorizontalLine: (value) => FlLine(
                                color: Colors.grey.withOpacity(0.2),
                                strokeWidth: 1),
                            getDrawingVerticalLine: (value) => FlLine(
                                color: Colors.grey.withOpacity(0.2),
                                strokeWidth: 1),
                          ),
                          borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.3))),
                          lineBarsData: [
                            LineChartBarData(
                              spots: scaledSpots, // Use the scaled spots for plotting
                              isCurved: isCurved,
                              color: lineColor,
                              barWidth: 3,
                              dotData: FlDotData(show: showDots),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    lineColor.withOpacity(0.3),
                                    lineColor.withOpacity(0.0)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                          lineTouchData: LineTouchData(
                            handleBuiltInTouches: true,
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((spot) {
                                  // Convert the scaled tooltip Y value back to the original value
                                  final originalY = actualMinY +
                                      (spot.y - plotMinY) *
                                          (actualMaxY - actualMinY) /
                                          (plotMaxY - plotMinY);

                                  final xLabel = xAxisLabel.split(' ').first;
                                  final yLabel = yAxisLabel.split(' ').first;
                                  final tooltipText =
                                      '$xLabel: ${spot.x.toStringAsFixed(1)}\n$yLabel: ${originalY.toStringAsFixed(2)}';
                                  return LineTooltipItem(
                                    tooltipText,
                                    const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        ),
                      ));
                    },
                  ),
        ),
      ],
    );
  }
}

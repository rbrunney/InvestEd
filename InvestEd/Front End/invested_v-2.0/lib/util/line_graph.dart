import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import "package:invested/util/global_styling.dart" as global_style;

class LineGraph extends StatefulWidget {
  final double height;
  final double width;
  final double maxX;
  final double maxY;
  final double minY;
  final int previousCloseLineSize;
  final List<FlSpot> previousCloseData;
  final List<FlSpot> graphLineData;
  final Color graphLineColor;
  const LineGraph({
    Key? key,
    this.height = 180,
    this.width = 0,
    this.maxX = 0,
    this.maxY = 0,
    this.minY = 0,
    this.previousCloseLineSize = 8,
    this.previousCloseData = const [],
    this.graphLineData = const [],
    this.graphLineColor = Colors.grey
  }) : super(key: key);

  @override
  State<LineGraph> createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.height,
        width: widget.width,
        child: LineChart(
          LineChartData(
              minX: 0,
              maxX: widget.maxX,
              minY: widget.minY,
              maxY: widget.maxY,
              // Removing all of the label axis for information
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              lineBarsData: [
                LineChartBarData(
                  dashArray: [widget.previousCloseLineSize, widget.previousCloseLineSize],
                  spots: widget.previousCloseData,
                  color: Colors.grey,
                  // This is here to remove the disgusting data points
                  dotData: FlDotData(
                    show: false,
                  ),
                ),
                LineChartBarData(
                  barWidth: 4,
                  spots: widget.graphLineData,
                  color: widget.graphLineColor,
                  // This is here to remove the disgusting data points
                  dotData: FlDotData(
                    show: false,
                  ),
                  curveSmoothness: 0.4
                ),
              ],
              // Removing Border to be visually cleaner
              borderData: FlBorderData(show: false),
              // Removing Grid Information to be visually cleaner
              gridData: FlGridData(show: false),
              lineTouchData: LineTouchData(
                  enabled: true,
                  // Makes phone stay within view of the phone
                  touchTooltipData: LineTouchTooltipData(
                    fitInsideHorizontally: true,
                  ),
                  getTouchedSpotIndicator:
                      (LineChartBarData barData, List<int> indicators) {
                    return indicators.map(
                          (int index) {
                        final line = FlLine(
                            color: Colors.grey,
                            strokeWidth: 5,
                            dashArray: [2, 4]);
                        return TouchedSpotIndicatorData(
                          line,
                          FlDotData(show: true),
                        );
                      },
                    ).toList();
                  },
                  getTouchLineEnd: (_, __) => double.infinity
              )
          ),
        ));
  }
}
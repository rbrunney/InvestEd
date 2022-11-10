import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:invested/util/global_styling.dart' as global_styling;

class PortfolioGraph extends StatefulWidget {
  const PortfolioGraph({Key? key}) : super(key: key);

  @override
  State<PortfolioGraph> createState() => _PortfolioGraphState();
}

class _PortfolioGraphState extends State<PortfolioGraph> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
        width: MediaQuery.of(context).size.width - 15,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: 20,
            minY: 0,
            maxY: 6,
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
                dashArray: [8, 8],
                spots: const [
                  FlSpot(0, 2.75),
                  FlSpot(20, 2.75),
                ],
                color: Colors.grey,
                // This is here to remove the disgusting data points
                dotData: FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                  spots: const [
                    FlSpot(0, 3),
                    FlSpot(1, 4),
                    FlSpot(2, 3),
                    FlSpot(3, 2),
                    FlSpot(4, 0.5),
                    FlSpot(5, 5),
                    FlSpot(6, 3),
                    FlSpot(7, 4.3),
                    FlSpot(8, 2.75),
                    FlSpot(9, 3.75),
                    FlSpot(10, 1.45),
                    FlSpot(11, 2.6),
                    FlSpot(12, 5),
                    FlSpot(13, 3),
                    FlSpot(14, 4.3),
                    FlSpot(15, 2.75),
                    FlSpot(16, 3.75),
                    FlSpot(17, 1.45),
                    FlSpot(18, 2.6),
                    FlSpot(19, 2.6),
                    FlSpot(20, 3.0),
                  ],
                  color: Color(global_styling.LOGO_COLOR),
                  // This is here to remove the disgusting data points
                  dotData: FlDotData(
                    show: false,
                  ),
                  curveSmoothness: 0.4),
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
                        strokeWidth: 1,
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

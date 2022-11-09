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
        maxX: 5,
        minY: 0,
        maxY: 6,
        // Removing all of the label axis for information
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
              spots: const [
                FlSpot(0, 3),
                FlSpot(1, 4),
                FlSpot(2, 3),
                FlSpot(3, 2),
                FlSpot(4, 0.5),
                FlSpot(5, 1),
              ],
              color: Color(global_styling.LOGO_COLOR),
            isCurved: true,
            curveSmoothness: 0.4
          )
        ]
    )
    )

    );
  }
}

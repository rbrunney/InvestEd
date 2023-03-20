import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:invested/util/widget/data/price_history/period_view/period_choice.dart';
import 'package:invested/util/widget/graphs/line_graph.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;

class PriceHistoryCard extends StatefulWidget {
  final double minPrice;
  final double maxPrice;
  final double previousClose;
  final List<double> pricePoints;
  const PriceHistoryCard({
    Key? key,
    required this.previousClose,
    required this.pricePoints,
    required this.minPrice,
    required this.maxPrice
  }) : super(key: key);

  @override
  State<PriceHistoryCard> createState() => _PriceHistoryCardState();
}

class _PriceHistoryCardState extends State<PriceHistoryCard> {

  final double maxPricePoints = 250;
  double firstPricePoint = 0;
  double lastPricePoint = 0;
  List<FlSpot> dataPoints = [];

  @override
  void initState() {
    super.initState();

    if(widget.pricePoints.length < maxPricePoints) {
      try {
        firstPricePoint = widget.pricePoints.elementAt(0);
        lastPricePoint = widget.pricePoints.elementAt(widget.pricePoints.length - 1);

        for(int i=0; i < widget.pricePoints.length; i++) {
          dataPoints.add(FlSpot((maxPricePoints - 1) - i, widget.pricePoints.elementAt(i)));
        }
      } catch(exception) {
        firstPricePoint = 0;
      }

      for(double i=0; i < maxPricePoints - widget.pricePoints.length; i++) {
        dataPoints.add(FlSpot(i, firstPricePoint));
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    bool isBelowPreviousClose = lastPricePoint < widget.previousClose;
    Color currentLineColor =  isBelowPreviousClose ? const Color(global_style.redPrimaryColor) : const Color(global_style.greenPrimaryColor);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 10),
                  child: LineGraph(
                    graphLineColor: currentLineColor,
                    width: MediaQuery.of(context).size.width,
                    minY: widget.minPrice,
                    maxY: widget.maxPrice,
                    maxX: maxPricePoints,
                    graphLineData: dataPoints,
                    previousCloseData: [
                      FlSpot(0, widget.previousClose),
                      FlSpot(maxPricePoints, widget.previousClose)
                    ],
                  )),
              Container(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: PeriodChoice(),
              )
            ],
          )),
    );
  }
}

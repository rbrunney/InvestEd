import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/util/custom_divider.dart';
import 'package:invested/util/line_graph.dart';
import 'package:invested/pages/stock/basic_stock_info.dart';
import 'package:invested/util/custom_text.dart';
import 'package:invested/util/global_styling.dart' as global_styling;
import 'package:page_transition/page_transition.dart';

class StockInfo extends StatefulWidget {
  final String ticker;
  final double totalShares;
  final double currentPrice;
  final IconData iconData;
  const StockInfo({
    Key? key,
    this.ticker = '',
    this.totalShares = 0,
    this.currentPrice = 0,
    this.iconData = MaterialCommunityIcons.arrow_up
  }) : super(key: key);

  @override
  State<StockInfo> createState() => _StockInfoState();
}

class _StockInfoState extends State<StockInfo> {
  double tickerTextSize = 20;
  double gainTextSize = 15;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          margin: const EdgeInsets.only(left: 15, right: 10, top: 5),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: widget.ticker,
                          fontSize: tickerTextSize,
                        ),
                        CustomText(
                          topMargin: 5,
                          text: "${widget.totalShares} Shares",
                          fontSize: 12,
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  LineGraph(
                    height: 6,
                    width: 125,
                    maxX: 20,
                    maxY: 6,
                    previousCloseLineSize: 2,
                    graphLineColor: Color(global_styling.LOGO_COLOR),
                    previousCloseData: const [
                      FlSpot(0, 10),
                      FlSpot(20, 10)
                    ],
                    graphLineData: const [
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
                      FlSpot(13, 5.45),
                      FlSpot(17, 17.00),
                      FlSpot(20, 15.75)
                    ],
                  ),
                  const Spacer(),
                  Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Color(global_styling.LOGO_COLOR),
                          borderRadius: const BorderRadius.all(Radius.circular(5))
                      ),
                      child: Row(
                        children: [
                          Icon(
                            widget.iconData,
                            color: Color(global_styling.GREY_LOGO_COLOR),
                            size: gainTextSize,
                          ),
                          CustomText(
                            text: "\$${widget.currentPrice}",
                            fontSize: gainTextSize,
                            color: Color(global_styling.GREY_LOGO_COLOR),
                            alignment: Alignment.centerRight,
                          )
                        ],
                      )
                  ),
                ],
              ),
              const CustomDivider(thickness: 0.5)
            ],
          )
      ),
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: BasicStockInfo(
                    ticker: widget.ticker,
                  totalShares: widget.totalShares,
                ),
                type: PageTransitionType.rightToLeftWithFade));
      },
    );
  }
}

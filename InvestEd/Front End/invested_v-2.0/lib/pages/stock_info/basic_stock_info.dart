import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:invested/pages/stock_info/basic_stat_card/basic_stock_stat_card.dart';
import 'package:invested/util/widget/data/price_history/period_view/period_choice.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:invested/util/widget/page/to_previous_page.dart';
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/widget/text/page_title.dart';

import '../../../util/widget/graphs/line_graph.dart';

class BasicStockInfoPage extends StatefulWidget {
  const BasicStockInfoPage({Key? key}) : super(key: key);

  @override
  State<BasicStockInfoPage> createState() => _BasicStockInfoPageState();
}

class _BasicStockInfoPageState extends State<BasicStockInfoPage> {
  final double currentPrice = 0;
  final double previousClose = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height *
                    0.35, // Multiply to get 30%
                color: const Color(global_style.greenPrimaryColor))
          ],
        ),
        SingleChildScrollView(
            child: Column(children: [
          Container(
              margin: const EdgeInsets.only(top: 10, left: 5),
              child: const ToPrevPage()),
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.06),
            child: const PageTitle(
              title: "AMZN",
              fontSize: 19,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.06),
            child: const PageTitle(
              title: "Amazon.Com Inc",
              fontSize: 35,
            ),
          ),
          CustomText(
            leftMargin: 20,
            alignment: Alignment.centerLeft,
            text: '\$93.76',
            fontSize: 30,
            color: const Color(global_style.whiteAccentColor),
          ),
          // DisplayPortfolioGain(
          //   gainPercentage: ((previousClose - currentPrice).abs() /
          //           ((previousClose + currentPrice) / 2)) *
          //       100,
          //   cashGain: currentPrice - previousClose,
          // ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.only(
                              top: 35, left: 25, right: 25),
                          child: LineGraph(
                            width: MediaQuery.of(context).size.width,
                            maxY: 5,
                            maxX: 6,
                            graphLineData: const [
                              FlSpot(0, 5),
                              FlSpot(1, 3),
                              FlSpot(2, 5),
                              FlSpot(3, 2),
                              FlSpot(4, 3),
                              FlSpot(5, 5),
                              FlSpot(6, 2)
                            ],
                            previousCloseData: const [
                              FlSpot(0, 3),
                              FlSpot(6, 3)
                            ],
                          )),
                      Container(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: PeriodChoice(),
                      )
                    ],
                  )),
            ),
          ),
          const BasicStockStatCard()
        ]))
      ]),
    ));
  }
}

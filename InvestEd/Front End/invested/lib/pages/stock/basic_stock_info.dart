import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:invested/util/custom_divider.dart';
import 'package:invested/util/custom_text.dart';
import 'package:invested/util/page_title.dart';
import 'package:invested/util/to_previous_page.dart';
import 'package:invested/util/global_styling.dart' as global_styling;

import '../../util/line_graph.dart';
import '../portfolio/period_choice_picker.dart';
import '../portfolio/portfolio_gain.dart';

class BasicStockInfo extends StatefulWidget {
  final String ticker;
  final String companyName;
  const BasicStockInfo({
    Key? key,
    this.ticker = '',
    this.companyName = '',
  }) : super(key: key);

  @override
  State<BasicStockInfo> createState() => _BasicStockInfoState();
}

class _BasicStockInfoState extends State<BasicStockInfo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child:  SingleChildScrollView(
                  child: Column(
                    children: [
                      const ToPrevPage(),
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: PageTitle(
                          title: widget.ticker,
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: PageTitle(
                          title: widget.companyName,
                          fontSize: 35,
                        ),
                      ),
                      CustomText(
                        leftMargin: 30,
                        alignment: Alignment.centerLeft,
                        text: '\$245.5838',
                        fontSize: 30,
                      ),
                      DisplayPortfolioGain(),
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: LineGraph(
                              width: MediaQuery.of(context).size.width - 15,
                              maxX: 20,
                              maxY: 6,
                              graphLineColor: Color(global_styling.LOGO_COLOR),
                              previousCloseData: const [
                                FlSpot(0, 2.75),
                                FlSpot(20, 2.75)
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
                                FlSpot(17, 5),
                                FlSpot(20, 6)
                              ]
                          )
                      ),
                      PeriodChoicePicker(),
                      const CustomDivider(),
                      CustomText(
                        topMargin: 5,
                        bottomMargin: 5,
                        fontSize: 18,
                        text: widget.companyName,
                        alignment: Alignment.center,
                      ),
                      const CustomDivider(),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: const PageTitle(
                          title: "Total Position",
                          fontSize: 25,
                        ),
                      ),
                    ],
                  )
              )
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [

                    CustomText(
                      text: "Shares",
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {},
                      child: CustomText(
                        text: "Trade",
                      )
                    )
                  ],
                ),
              ),
            )
          ],
        )
      )
    );
  }
}

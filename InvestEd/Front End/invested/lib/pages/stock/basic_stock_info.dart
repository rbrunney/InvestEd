import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:invested/pages/stock/additional_info.dart';
import 'package:invested/pages/stock/buy_sell/bottom_trade_bar.dart';
import 'package:invested/pages/stock/stock_stat_row.dart';
import 'package:invested/pages/stock/total_position.dart';
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
                      const TotalPosition(),
                      PageTitle(
                        title: "About ${widget.ticker}",
                        fontSize: 25,
                      ),
                      const PageTitle(
                        title: 'Description',
                        fontSize: 18,
                      ),
                      CustomText(
                        leftMargin: 15,
                        rightMargin: 15,
                        bottomMargin: 15,
                        text: '     Microsoft develops and licenses consumer and enterprise software. It is known for its Windows operating systems and Office productivity suite. The company is organized into three equally sized broad segments: productivity and business processes (legacy Microsoft Office, cloud-based Office 365, Exchange, SharePoint, Skype, LinkedIn, Dynamics), intelligence cloud (infrastructure- and platform-as-a-service offerings Azure, Windows Server OS, SQL Server), and more personal computing (Windows Client, Xbox, Bing search, display advertising, and Surface laptops, tablets, and desktops).',
                      ),
                      const PageTitle(
                        title: 'Stats',
                        fontSize: 18,
                      ),
                      // Making Stat Table Here
                      const CustomDivider(),
                      const StatRow(rowName: "Open Price", rowData: "\$242.99"),
                      const StatRow(rowName: "Today's High", rowData: "\$247.99"),
                      const StatRow(rowName: "Today's Low", rowData: "\$241.11"),
                      const StatRow(rowName: "Today's Volume", rowData: "34620246"),
                      const StatRow(rowName: "Market Cap", rowData: "1842074858613.84"),
                      const StatRow(rowName: "Dividend Per Share", rowData: "\$0.68"),
                      // Adding additional info
                      const AdditionalInformation()
                    ],
                  )
              )
            ),
            BottomTradeBar(
              ticker: widget.ticker,
              currentPrice: 253.4545,
            )
          ],
        )
      )
    );
  }
}

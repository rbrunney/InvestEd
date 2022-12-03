import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:invested/pages/stock/additional_info.dart';
import 'package:invested/pages/stock/buy_sell/bottom_trade_bar.dart';
import 'package:invested/pages/stock/stock_stat_row.dart';
import 'package:invested/pages/stock/total_position.dart';
import 'package:invested/util/custom_divider.dart';
import 'package:invested/util/custom_text.dart';
import 'package:invested/util/page_title.dart';
import 'package:invested/util/requests.dart';
import 'package:invested/util/to_previous_page.dart';
import 'package:invested/util/global_styling.dart' as global_styling;
import 'package:invested/util/global_info.dart' as global_info;

import '../../util/line_graph.dart';
import '../portfolio/period_choice_picker.dart';
import '../portfolio/portfolio_gain.dart';

class BasicStockInfo extends StatefulWidget {
  final String ticker;
  final double totalShares;
  const BasicStockInfo({
    Key? key,
    this.ticker = '',
    this.totalShares = 0,
  }) : super(key: key);

  @override
  State<BasicStockInfo> createState() => _BasicStockInfoState();
}

class _BasicStockInfoState extends State<BasicStockInfo> {

  // Basic Stock Info
  String companyName = '';
  double currentPrice = 0;

  // Total Position Information
  double totalShares = 0;
  double totalMarketValue = 0;
  double portfolioDiversity = 0;

  // About Section
  String description = '';
  // ------------
  double openPrice = 0;
  double high = 0;
  double low = 0;
  double volume = 0;
  double marketCap = 0;
  double dividend = 0;

  // Additional Info
  String listDate = '';
  int totalEmployees = 0;
  String addressStreet = '';
  String addressCity = '';
  String addressState = '';
  String addressZipcode = '';

  // Used for Request
  Future<String>? futureStockInfo;

  @override
  void initState() {
    super.initState();
    futureStockInfo = getBasicStockInfo();
  }

  Future<String>? getBasicStockInfo() async {
    await Requests.makeGetRequest("${global_info.localhost_url}/invested_stock/${widget.ticker}/basic_info").
    then((value) {
      var response = json.decode(value);
      print(response);
      setState(() {
        companyName = response['results']['name'];
        description = response['results']['description'];
        openPrice = response['results']['open'];
        high = response['results']['high'];
        low = response['results']['low'];
        volume = response['results']['volume'];
        marketCap = response['results']['market_cap'];
        dividend = response['results']['last_dividend'];
        listDate = response['results']['list_date'];
        totalEmployees = response['results']['total_employees'];
        addressStreet = response['results']['hq_address']['street'];
        addressCity = response['results']['hq_address']['city'];
        addressState = response['results']['hq_address']['state'];
        addressZipcode = response['results']['hq_address']['zipcode'];
        // totalShares = widget.totalShares;
        // totalMarketValue = widget.totalShares * 245.5838;
        // portfolioDiversity = 0;
      });
    });

    return 'Done';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child:  SingleChildScrollView(
                  child: FutureBuilder<String>(
                    future: futureStockInfo,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        return Column(
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
                                title: companyName,
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
                                    maxY: high,
                                    graphLineColor: Color(global_styling.LOGO_COLOR),
                                    previousCloseData: [
                                      FlSpot(0, openPrice),
                                      FlSpot(20, openPrice)
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
                              text: '     $description',
                            ),
                            const PageTitle(
                              title: 'Stats',
                              fontSize: 18,
                            ),
                            // Making Stat Table Here
                            const CustomDivider(),
                            StatRow(rowName: "Open Price", rowData: "\$$openPrice"),
                            StatRow(rowName: "Today's High", rowData: "\$$high"),
                            StatRow(rowName: "Today's Low", rowData: "\$$low"),
                            StatRow(rowName: "Today's Volume", rowData: "$volume"),
                            StatRow(rowName: "Market Cap", rowData: "$marketCap"),
                            StatRow(rowName: "Dividend Per Share", rowData: "\$$dividend"),
                            // Adding additional info
                            AdditionalInformation(
                              totalEmployees: totalEmployees,
                              listDate: listDate,
                              street: addressStreet,
                              city: addressCity,
                              state: addressState,
                              zipcode: addressZipcode,
                            )
                          ],
                        );
                      }

                      return Center(
                          heightFactor: 20,
                          child: Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: Color(global_styling.LOGO_COLOR),
                            ),
                          ));
                    },
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

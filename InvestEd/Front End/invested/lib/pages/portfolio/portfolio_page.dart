import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:invested/pages/portfolio/period_choice_picker.dart';
import 'package:invested/util/custom_divider.dart';
import 'package:invested/util/page_title.dart';
import 'package:invested/util/line_graph.dart';
import 'package:invested/pages/portfolio/portfolio_gain.dart';
import 'package:invested/pages/portfolio/stock_info.dart';
import 'package:invested/util/custom_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:invested/util/global_styling.dart' as global_styling;
import 'package:invested/util/global_info.dart' as global_info;
import 'package:invested/util/requests.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {

  double totalCapitalValue = 0;
  double buyingPower = 0;
  double totalGain = 0;
  double totalCashGain = 0;
  List<Widget> stocksToDisplay = [];

  @override
  initState() {
    // Making Request to get information
    Requests.makeGetRequestWithAuth('${global_info.localhost_url}/invested_portfolio', global_info.access_token)
        .then((value) async {

      // Make Request to get Account Information
      await Requests.makeGetRequestWithAuth('${global_info.localhost_url}/invested_account/buying_power', global_info.access_token)
          .then((value) {
        var response = json.decode(value);
        setState(() {
          buyingPower = response;
        });
      });

      var response = json.decode(value);

      setState(() {
        totalGain = response['results']['portfolio']['total-gain'];
        totalCapitalValue = response['results']['portfolio']['total-value'] + buyingPower;
        for(var stock in response['results']['portfolio']['current-stocks']) {
          double currentStockPrice = 0;
          Requests.makeGetRequest('${global_info.localhost_url}/invested_stock/${stock['ticker']}/price')
          .then((value) async {
            var response = json.decode(value);
            currentStockPrice = response['results']['current_price'];
          });

          stocksToDisplay.add(StockInfo(
            ticker: stock['ticker'],
            totalShares: stock['totalShareQuantity'],
            currentPrice: currentStockPrice,
            portfolioValue: totalCapitalValue,
          ));
        }
        stocksToDisplay.add(StockInfo(
          ticker: "MSFT",
          totalShares: 1.25,
          currentPrice: 245.75,
          portfolioValue: totalCapitalValue,
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child : Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 25, left: 15),
                  child: const PageTitle(title: "Investing"),
                ),
                CustomText(
                  leftMargin: 30,
                  alignment: Alignment.centerLeft,
                  text: '\$$totalCapitalValue',
                  fontSize: 30,
                ),
                DisplayPortfolioGain(
                  gainPercentage: totalGain,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 40),
                  child: LineGraph(
                    width: MediaQuery.of(context).size.width - 15,
                    maxX: 20,
                    maxY: 6,
                    graphLineColor: Color(global_styling.LOGO_COLOR),
                    previousCloseData: const [
                      FlSpot(0, 2.75),
                      FlSpot(20, 2.75),
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
                  )
                ),
                PeriodChoicePicker(),
                const CustomDivider(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      CustomText(
                        text: 'Buying Power',
                        topMargin: 5,
                        bottomMargin: 5,
                        alignment: Alignment.centerLeft,
                        fontSize: 18,
                      ),
                      const Spacer(),
                      CustomText(
                        text: '\$$buyingPower',
                        topMargin: 5,
                        bottomMargin: 5,
                        alignment: Alignment.centerRight,
                        fontSize: 18,
                      ),
                    ],
                  ),
                ),
                const CustomDivider(),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: const PageTitle(
                    title: "Stocks",
                    fontSize: 30,
                  ),
                ),
                Column(
                  children: stocksToDisplay,
                )
              ],
            )
          )
        )
    );
  }
}

import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/util/custom_divider.dart';
import 'package:invested/util/line_graph.dart';
import 'package:invested/pages/stock/basic_stock_info.dart';
import 'package:invested/util/custom_text.dart';
import 'package:invested/util/global_styling.dart' as global_styling;
import 'package:invested/util/global_info.dart' as global_info;
import 'package:page_transition/page_transition.dart';

import '../../util/requests.dart';

class StockInfo extends StatefulWidget {
  final String ticker;
  final double totalShares;
  final double portfolioValue;
  final IconData iconData;
  const StockInfo({
    Key? key,
    this.ticker = '',
    this.totalShares = 0,
    this.portfolioValue = 0,
    this.iconData = MaterialCommunityIcons.arrow_up
  }) : super(key: key);

  @override
  State<StockInfo> createState() => _StockInfoState();
}

class _StockInfoState extends State<StockInfo> {
  double tickerTextSize = 20;
  double gainTextSize = 15;

  double currentPrice = 0;
  double chartMinY = 1000000;
  double chartMaxY = 0;
  double previousClose = 0;
  double openPrice = 0;
  List<FlSpot> stockPrices = [];

  @override
  void initState() {
    super.initState();
    Requests.makeGetRequest("${global_info.localhost_url}/invested_stock/${widget.ticker}/price")
        .then((value) {
      var response = json.decode(value);
      setState(() {
        currentPrice = response['results']['current_price'].toDouble();
      });
    });

    Requests.makeGetRequest("${global_info.localhost_url}/invested_stock/${widget.ticker}/DAY")
        .then((value) {
      var response = json.decode(value);
      for(int i=0; i<response['results']['period_info'].length; i++) {
        setState(() {
          if(response['results']['period_info'][i].toDouble() < chartMinY) {
            chartMinY = response['results']['period_info'][i].toDouble();
          }

          if(response['results']['period_info'][i].toDouble() > chartMaxY) {
            chartMaxY = response['results']['period_info'][i].toDouble();
          }
          stockPrices.add(FlSpot(i.toDouble(), response['results']['period_info'][i].toDouble()));
        });
      }
    });

    Requests.makeGetRequest("${global_info.localhost_url}/invested_stock/${widget.ticker}/basic_info").
    then((value) {
      var response = json.decode(value);
      setState(() {
        openPrice = response['results']['open'];
        previousClose = response['results']['previous_close'];
      });
    });
  }

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
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      child: LineGraph(
                          height: 25,
                          width: 125,
                          maxX: 250,
                          minY: chartMinY < openPrice ? (chartMinY < previousClose ? chartMinY : previousClose) : openPrice,
                          maxY: chartMaxY > currentPrice ? (chartMaxY > previousClose ? chartMaxY : previousClose) : currentPrice,
                          graphLineColor: previousClose < currentPrice ? Color(global_styling.LOGO_COLOR) : Colors.red,
                          previousCloseData: [
                            FlSpot(0, previousClose),
                            FlSpot(250, previousClose)
                          ],
                          graphLineData: stockPrices
                      )
                  ),
                  const Spacer(),
                  Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: previousClose < currentPrice ? Color(global_styling.LOGO_COLOR) : Colors.red,
                          borderRadius: const BorderRadius.all(Radius.circular(5))
                      ),
                      child: Row(
                        children: [
                          Icon(
                            previousClose < currentPrice ? Icons.arrow_upward : Icons.arrow_downward,
                            color: Color(global_styling.GREY_LOGO_COLOR),
                            size: gainTextSize,
                          ),
                          CustomText(
                            text: "\$${currentPrice.toStringAsFixed(2)}",
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
                  portfolioValue: widget.portfolioValue,
                ),
                type: PageTransitionType.rightToLeftWithFade));
      },
    );
  }
}

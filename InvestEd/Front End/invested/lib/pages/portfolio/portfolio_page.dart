import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/util/page_title.dart';
import 'package:invested/pages/portfolio/portfolio_graph.dart';
import 'package:invested/pages/portfolio/portfolio_gain.dart';
import 'package:invested/pages/portfolio/stock_info.dart';
import 'package:invested/util/custom_text.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
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
                  text: '\$5,000.00',
                  fontSize: 30,
                ),
                DisplayPortfolioGain(),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: const PortfolioGraph()
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Divider(
                    thickness: 1.5,
                    color: Colors.grey,
                  )
                ),
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
                        text: '\$5,000.00',
                        topMargin: 5,
                        bottomMargin: 5,
                        alignment: Alignment.centerRight,
                        fontSize: 18,
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Divider(
                      thickness: 1.5,
                      color: Colors.grey,
                    )
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: const PageTitle(
                    title: "Stocks",
                    fontSize: 30,
                  ),
                ),
                const StockInfo(
                  ticker: "MSFT",
                  totalShares: 1236.72183,
                  currentPrice: 1120.75,
                ),
                const StockInfo(
                  ticker: "AAPL",
                  totalShares: 32.05,
                  currentPrice: 132.75,
                ),
                const StockInfo(
                  ticker: "VOO",
                  totalShares: 32.05,
                  currentPrice: 132.75,
                ),
                const StockInfo(
                  ticker: "SPHD",
                  totalShares: 32.05,
                  currentPrice: 132.75,
                ),
                const StockInfo(
                  ticker: "XOM",
                  totalShares: 32.05,
                  currentPrice: 132.75,
                ),
              ],
            )
          )
        )
    );
  }
}

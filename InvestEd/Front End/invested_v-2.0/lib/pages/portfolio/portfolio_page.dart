import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/util/widget/data/cash_gain.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:invested/util/widget/data/price_history/price_history.dart';
import 'package:invested/util/widget/data/stock_card.dart';
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/widget/text/page_title.dart';

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
            body: Stack(
              children: [
                buildTopGreenPatch(),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      buildHeader(),
                      buildPortfolioValue(4500.75),
                      buildPortfolioTotalGain(0, 0),
                      buildPortfolioHistory(0, 0, 0, []),
                      buildPortfolioHeader(),
                      buildPortfolio()
                    ],
                  ),
                )
              ],
    )));
  }

  Column buildTopGreenPatch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height *
                0.35, // Multiply to get 30%
            color: const Color(global_style.greenPrimaryColor))
      ],
    );
  }

  Row buildHeader() {
    return Row(
      children: [
        Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              left: MediaQuery.of(context).size.width * 0.05
            ),
            child: const PageTitle(
              title: "Investing",
              fontSize: 45,
              color: Color(global_style.whiteAccentColor),
            ),
        ),
        const Spacer(),
        Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.04,
            right: MediaQuery.of(context).size.width * 0.05
          ),
          child: IconButton(
            icon: const Icon(
              Icons.search,
              size: 30,
              color: Color(global_style.whiteAccentColor),
            ),
            onPressed: () {
              print('Search');
            },
          )
        )
      ],
    );
  }

  Container buildPortfolioValue(double portfolioValue) {
    return Container(
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
      child: CustomText(
        alignment: Alignment.centerLeft,
        text: "\$$portfolioValue",
        fontSize: 35,
        color: const Color(global_style.whiteAccentColor)
      )
    );
  }

  Container buildPortfolioTotalGain(double cashGain, double percentageGain) {
    return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.01,
            left: MediaQuery.of(context).size.width * 0.05
        ),
        child: CashGainCard(cashGain: cashGain, percentageGain: percentageGain)
    );
  }

  Container buildPortfolioHistory(double minPrice, double maxPrice, double previousClose, List<double> pricePoints) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02, horizontal: MediaQuery.of(context).size.width * 0.05),
      child: PriceHistoryCard(
        minPrice: minPrice - 5,
        maxPrice: maxPrice + 5,
        previousClose: previousClose,
        pricePoints: pricePoints
      )
    );
  }

  Container buildPortfolioHeader() {
    return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.06,
        ),
        child: Row(
          children: [
            const PageTitle(title: 'Stocks', fontSize: 30, bottomMargin: 0),
            const Spacer(),
            IconButton(
              icon: const Icon(Ionicons.filter),
              onPressed: () {},
            )
          ],
        )
    );
  }

  Container buildPortfolio() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Row(
                children: const [
                  StockCard(
                      tickerLogo: 'https://api.polygon.io/v1/reference/company-branding/d3d3LmFtYXpvbi5jb20/images/2023-01-01_icon.jpeg?apiKey=pWnmnyskgOhWmfE226LWf4BH4vDY1i73',
                      ticker: 'AMZN',
                      totalGain: 35
                  ),
                  Spacer(),
                  StockCard(
                      tickerLogo: 'https://api.polygon.io/v1/reference/company-branding/d3d3LmFtYXpvbi5jb20/images/2023-01-01_icon.jpeg?apiKey=pWnmnyskgOhWmfE226LWf4BH4vDY1i73',
                      ticker: 'AMZN',
                      totalGain: 35
                  )
                ],
              )
          )
        ],
      )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:invested/pages/landing/landing_button.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:invested/util/widget/data/cash_gain.dart';
import 'package:invested/util/widget/data/price_history/price_history.dart';
import 'package:invested/util/widget/page/to_previous_page.dart';
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/widget/text/page_title.dart';

class BasicStockInfoPage extends StatefulWidget {
  final String ticker;
  const BasicStockInfoPage({Key? key, required this.ticker}) : super(key: key);

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
          body: Stack(
            children: [
              buildTopGreenPatch(),
              SingleChildScrollView(
                child: Column(
                  children: [
                    buildHeader(),
                    buildCurrentPrice(98.95),
                    buildTickerTotalGain(0, 0),
                    buildTickerPriceHistory(0, 0, 0, [])
                  ],
                ),
              ),Column(
                  children: [
                    Expanded(
                      child: Container(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              color: const Color(global_style.whiteAccentColor),
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01, horizontal: MediaQuery.of(context).size.width * 0.05),
                                child: LandingButton(
                                  onTap: () {},
                                  hasFillColor: true,
                                  text: 'Buy',
                                )
                              )
                            )
                          )
                      )
                    )
                  ],
                )
            ]
        ),
      )
    );
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

  Container buildHeader() {
    return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
        child: Column(
          children: [
            const ToPrevPage(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: PageTitle(
                title: widget.ticker,
                fontSize: 18,
                bottomMargin: 0,
                color: const Color(global_style.whiteAccentColor),
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: const PageTitle(
                title: 'Amazon.Com Inc',
                fontSize: 35,
                bottomMargin: 5,
                color: Color(global_style.whiteAccentColor),
              )
            ),
          ],
        )
    );
  }

  Container buildCurrentPrice(double currentPrice) {
    return Container(
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
        child: CustomText(
            alignment: Alignment.centerLeft,
            text: "\$$currentPrice",
            fontSize: 35,
            color: const Color(global_style.whiteAccentColor)
        )
    );
  }

  Container buildTickerTotalGain(double cashGain, double percentageGain) {
    return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(
            top: MediaQuery
                .of(context)
                .size
                .height * 0.01,
            left: MediaQuery
                .of(context)
                .size
                .width * 0.05
        ),
        child: CashGainCard(cashGain: cashGain, percentageGain: percentageGain)
    );
  }

  Container buildTickerPriceHistory(double minPrice, double maxPrice, double previousClose, List<double> pricePoints) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01, horizontal: MediaQuery.of(context).size.width * 0.05),
        child: PriceHistoryCard(
            minPrice: minPrice - 5,
            maxPrice: maxPrice + 5,
            previousClose: previousClose,
            pricePoints: pricePoints
        )
    );
  }
}

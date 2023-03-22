import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
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
                    buildTickerPriceHistory(0, 0, 0, []),
                    buildBasicTickerInfoCard(),
                    // buildAboutTickerCard('This is about Amazon Pretty Poggers')
                  ],
                ),
              ),
              buildBuyButton()
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

  Container buildBasicTickerInfoCard() {
    return Container (
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.025
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.18,
        width: MediaQuery.of(context).size.width,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.7
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              buildBasicStat("Open", "\$90.95"),
              buildBasicStat("High", "\$90.95"),
              buildBasicStat("Low", "\$90.95"),
              buildBasicStat("Volume", "\$90.95"),
              buildBasicStat("Market Cap", "\$90.95"),
              buildBasicStat("Dividend", "\$90.95")
            ],
          ),
        )
      )
    );
  }

  Container buildBasicStat(String title, String stat) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.015),
      child: Column(
        children: [
          CustomText(
            text: title,
            fontSize: 17,
            fontWeight: FontWeight.bold,
            bottomMargin: MediaQuery.of(context).size.height * 0.01,
            color: const Color(global_style.greenAccentTextColor),
          ),
          CustomText(
            text: stat,
            fontSize: 17,
          )
        ],
      )
    );
  }

  Container buildAboutTickerCard(String description) {
    return Container (
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.05,
          bottom: MediaQuery.of(context).size.width * 0.2,
          left: MediaQuery.of(context).size.height * 0.025,
          right: MediaQuery.of(context).size.height * 0.025
      ),
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.18,
          width: MediaQuery.of(context).size.width,
          child: Card(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                CustomText(
                  text: 'About ${widget.ticker}',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  bottomMargin: MediaQuery.of(context).size.height * 0.01,
                  color: const Color(global_style.greenAccentTextColor),
                ),
                CustomText(
                  text: '     $description',
                )
              ],
            )
          )
      )
    );
  }

  Column buildBuyButton() {
    return Column(
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
    );
  }
}

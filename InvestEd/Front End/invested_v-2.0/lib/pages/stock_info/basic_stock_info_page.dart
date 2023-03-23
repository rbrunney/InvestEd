import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:invested/models/stock.dart';
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

  late Stock currentStock;
  Future<List<double>>? futurePricePoints;
  List<double> pricePoints = [];
  double cashGain = 0;
  double percentageGain = 0;

  void getStockInformation() async {
    await currentStock.getCurrentPrice();
    await currentStock.getBasicInfo();
    futurePricePoints = currentStock.getPricePoints("DAY");

    futurePricePoints?.then((value) {
      setState(() {
        pricePoints = value;
        cashGain = currentStock.currentPrice - currentStock.previousClose;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    currentStock = Stock(ticker: widget.ticker);
    getStockInformation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: FutureBuilder<List<double>>(
            future: futurePricePoints,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return Stack(
                    children: [
                      buildTopPatch(),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            buildHeader(),
                            buildCurrentPrice(currentStock.currentPrice),
                            buildTickerTotalGain(cashGain, ((cashGain).abs()/ currentStock.previousClose) * 100),
                            buildTickerPriceHistory(currentStock),
                            buildBasicTickerInfoCard()
                          ],
                        ),
                      ),
                      buildBuyButton()
                    ]
                );
              }

              return Center(
                  heightFactor: 20,
                  child: Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: Color(global_style.greenPrimaryColor),
                    ),
                  ));
            }
          )
      )
    );
  }

  Column buildTopPatch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.35, // Multiply to get 30%
            color: cashGain < 0 ? const Color(global_style.redPrimaryColor) : const Color(global_style.greenPrimaryColor))
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
              child: PageTitle(
                title: currentStock.companyName,
                fontSize: 35,
                bottomMargin: 5,
                color: const Color(global_style.whiteAccentColor),
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
            text: "\$${currentPrice.toStringAsFixed(2)}",
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

  Container buildTickerPriceHistory(Stock stock) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01, horizontal: MediaQuery.of(context).size.width * 0.05),
        child: PriceHistoryCard(
            minPrice: stock.low < stock.open ? (stock.low < stock.previousClose ? stock.low : stock.previousClose) : stock.open,
            maxPrice: stock.high > stock.currentPrice ? (stock.high > stock.previousClose ? stock.high : stock.previousClose) : stock.currentPrice,
            previousClose: stock.previousClose,
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
              buildBasicStat("Open", "\$${currentStock.open.toStringAsFixed(2)}"),
              buildBasicStat("High", "\$${currentStock.high.toStringAsFixed(2)}"),
              buildBasicStat("Low", "\$${currentStock.low.toStringAsFixed(2)}"),
              buildBasicStat("Volume", NumberFormat.compact().format(currentStock.volume)),
              buildBasicStat("Market Cap", NumberFormat.compact().format(currentStock.marketCap)),
              buildBasicStat("Dividend", currentStock.dividend == null ? 'N/A' : "\$${currentStock.dividend?.toStringAsFixed(2)}")
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
            color: cashGain < 0 ? const Color(global_style.redAccentTextColor) : const Color(global_style.greenAccentTextColor),
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
                              color: cashGain < 0 ? const Color(global_style.redPrimaryColor) : const Color(global_style.greenPrimaryColor),
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

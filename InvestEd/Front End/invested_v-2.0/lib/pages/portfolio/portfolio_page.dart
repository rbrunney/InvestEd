import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/controllers/token_controllers/token_controller.dart';
import 'package:invested/controllers/url_controller/url_controller.dart';
import 'package:invested/controllers/user_data_controllers/user_data_controller.dart';
import 'package:invested/pages/search/search_page.dart';
import 'package:invested/util/requests/auth_request.dart';
import 'package:invested/util/widget/data/cash_gain.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:invested/util/widget/data/price_history/price_history.dart';
import 'package:invested/util/widget/data/stock_card.dart';
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/widget/text/page_title.dart';
import 'package:page_transition/page_transition.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {

  final userDataController = Get.put(UserDataController());
  final tokenController = Get.put(TokenController());
  final urlController = Get.put(URLController());
  double portfolioValue = 0;
  double totalGain = 0;

  late Future<String>? portfolioBuyingPower;
  List<Widget> stocks = [];

  Future<String> getBuyingPower() async {
    await AuthRequest.makeGetRequest("${urlController.localBaseURL}/invested_account/buying_power", tokenController.accessToken.toString())
        .then((value) async {
          var response = json.decode(value);
          setState(() {
            portfolioValue += response;
          });
          userDataController.buyingPower = response;
    });

    await AuthRequest.makeGetRequest("${urlController.localBaseURL}/invested_portfolio", tokenController.accessToken.toString())
        .then((value) {
      var response = json.decode(value);
      setState(() {
        portfolioValue += response['results']['totalValue'];
        totalGain = response['results']['totalGain'];
      });

      for (var stock in (response['results']['stocks'] as List)) {
        setState(() {
          stocks.add(
              StockCard(ticker: stock['ticker'], totalGain: totalGain)
          );
        });
      }
    });

    return '';
  }

  @override
  void initState() {
    super.initState();
    portfolioBuyingPower = getBuyingPower();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: FutureBuilder<String>(
              future: portfolioBuyingPower,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return Stack(
                    children: [
                      buildTopGreenPatch(),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            buildHeader(),
                            buildPortfolioValue(portfolioValue),
                            buildPortfolioTotalGain(portfolioValue * totalGain, totalGain),
                            buildPortfolioHistory(0, 0, 0, []),
                            buildPortfolioHeader(),
                            buildPortfolio()
                          ],
                        ),
                      )
                    ],
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
              Navigator.push(
                  context,
                  PageTransition(
                      child: const SearchPage(),
                      type: PageTransitionType.rightToLeftWithFade
                  )
              );
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
        text: "\$${portfolioValue.toStringAsFixed(2)}",
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
        children: stocks
      )
    );
  }

  // [
  // Container(
  // margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
  // child: Row(
  // children: const [
  // StockCard(
  // tickerLogo: 'https://api.polygon.io/v1/reference/company-branding/d3d3LmFtYXpvbi5jb20/images/2023-01-01_icon.jpeg?apiKey=pWnmnyskgOhWmfE226LWf4BH4vDY1i73',
  // ticker: 'AMZN',
  // totalGain: 35
  // ),
  // Spacer(),
  // StockCard(
  // tickerLogo: 'https://api.polygon.io/v1/reference/company-branding/d3d3LmFtYXpvbi5jb20/images/2023-01-01_icon.jpeg?apiKey=pWnmnyskgOhWmfE226LWf4BH4vDY1i73',
  // ticker: 'XOM',
  // totalGain: 35
  // )
  // ],
  // )
  // )
  // ],
}

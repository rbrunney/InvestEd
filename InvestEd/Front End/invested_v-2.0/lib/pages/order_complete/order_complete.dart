import 'package:flutter/material.dart';
import 'package:invested/main.dart';
import 'package:invested/pages/buy/buy_sell_info_row.dart';
import 'package:invested/pages/landing/landing_button.dart';
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/widget/text/page_title.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;

class OrderCompletePage extends StatefulWidget {
  final String ticker;
  final String tradeType;
  final String orderType;
  final String orderId;
  final double totalShares;
  final double currentPrice;
  final double finalPrice;
  const OrderCompletePage({
    Key? key,
    this.ticker = "",
    this.tradeType = "",
    this.orderType = "",
    this.orderId = "",
    this.totalShares = 0,
    this.currentPrice = 0,
    this.finalPrice = 0,
  }) : super(key: key);

  @override
  State<OrderCompletePage> createState() => _OrderCompletePageState();
}

class _OrderCompletePageState extends State<OrderCompletePage> {
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
                        buildOrderReceipt(),
                        buildCompleteButton()
                      ],
                    )
                ),
              ],
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

  Container buildHeader() {
    return Container(
        margin: const EdgeInsets.only(top: 55, bottom: 20),
        child:  const PageTitle(
          alignment: Alignment.center,
          title: "Order Submitted",
          color: Color(global_style.whiteAccentColor),
        )
    );
  }

  Container buildOrderReceipt() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: const PageTitle(
                alignment: Alignment.center,
                title: "Order Receipt",
                fontSize: 25,
              ),
            ),
            BuySellInfoRow(
              infoPrefixText: "Ticker:",
              infoSuffixText: widget.ticker,
            ),
            BuySellInfoRow(
              infoPrefixText: "Total Shares:",
              infoSuffixText: widget.totalShares.toStringAsFixed(2),
            ),
            BuySellInfoRow(
              infoPrefixText: "Price-Per-Share:",
              infoSuffixText: "\$${widget.currentPrice.toStringAsFixed(2)}",
            ),
            BuySellInfoRow(
              infoPrefixText: "Total Price:",
              infoSuffixText: "\$${widget.finalPrice.toStringAsFixed(2)}",
            ),
            BuySellInfoRow(
              infoPrefixText: "Trade Type:",
              infoSuffixText: widget.tradeType,
            ),
            BuySellInfoRow(
              infoPrefixText: "Order Id:",
              infoSuffixText: widget.orderId.split("-")[4],
            )
          ],
        ),
      ),
    );
  }

  Container buildCompleteButton() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
      child: LandingButton(
        text: 'Complete!',
        onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false);
        },
        hasFillColor: true,
      )
    );
  }
}

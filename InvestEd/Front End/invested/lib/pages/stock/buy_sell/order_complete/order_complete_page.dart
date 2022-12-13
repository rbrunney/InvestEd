import 'package:flutter/material.dart';
import 'package:invested/pages/navigation/bottom_tab_navigation.dart';
import 'package:invested/util/custom_text.dart';
import 'package:invested/util/page_title.dart';
import 'package:invested/util/global_styling.dart' as global_styling;

import '../util/buy_sell_info_row.dart';

class OrderCompletePage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 55, bottom: 20),
                  child:  const PageTitle(
                    alignment: Alignment.center,
                    title: "Order Submitted",
                  )
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Card(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: const PageTitle(
                            alignment: Alignment.center,
                            title: "Order Info",
                            fontSize: 25,
                          ),
                        ),
                        BuySellInfoRow(
                          infoPrefixText: "Ticker:",
                          infoSuffixText: ticker,
                        ),
                        BuySellInfoRow(
                          infoPrefixText: "Total Shares:",
                          infoSuffixText: totalShares.toStringAsFixed(2),
                        ),
                        BuySellInfoRow(
                            infoPrefixText: "Price-Per-Share:",
                          infoSuffixText: "\$${currentPrice.toStringAsFixed(2)}",
                        ),
                        BuySellInfoRow(
                          infoPrefixText: "Total Price:",
                          infoSuffixText: "\$${finalPrice.toStringAsFixed(2)}",
                        ),
                        BuySellInfoRow(
                          infoPrefixText: "Trade Type:",
                          infoSuffixText: tradeType,
                        ),
                        BuySellInfoRow(
                          infoPrefixText: "Order Id:",
                          infoSuffixText: orderId.split("-")[4],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 35),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const PageNavigation()),
                              (Route<dynamic> route) => false);
                    },
                    child: SizedBox(
                        height: 40,
                        width: 200,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Color(global_styling.LOGO_COLOR),
                              borderRadius: const BorderRadius.all(Radius.circular(5))
                          ),
                          child: CustomText(
                            color: Color(global_styling.GREY_LOGO_COLOR),
                            text: "Finish!",
                          ),
                        )
                    ),
                  )
                )
              ],
            )
          ),
        )
    );
  }
}

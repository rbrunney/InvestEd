import 'package:flutter/material.dart';
import 'package:invested/pages/stock/buy_sell/buy/buy_page.dart';
import 'package:invested/pages/stock/buy_sell/sell/sell_page.dart';
import 'package:page_transition/page_transition.dart';

import '../../../util/global_styling.dart' as global_styling;
import '../../../util/custom_divider.dart';
import '../../../util/custom_text.dart';

class BottomTradeBar extends StatelessWidget {
  final String ticker;
  final double currentPrice;
  final double previousClose;
  final bool isPortfolioStock;
  const BottomTradeBar({
    Key? key,
    this.ticker = "",
    this.currentPrice = 0,
    this.previousClose = 0,
    this.isPortfolioStock = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: MediaQuery.of(context).size.width,
      child: Container(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              const CustomDivider(thickness: 0.5),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Visibility(
                      visible: isPortfolioStock,
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: SellPage(
                                        ticker: ticker,
                                        currentPrice: currentPrice,
                                      ),
                                      type: PageTransitionType.bottomToTop));
                            },
                            child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 50),
                                decoration: BoxDecoration(
                                    color: previousClose < currentPrice ? Color(global_styling.LOGO_COLOR) : Colors.red,
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: CustomText(
                                  text: "Sell",
                                  color: Color(global_styling.GREY_LOGO_COLOR),
                                )
                            )
                        )
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: BuyPage(
                                  ticker: ticker,
                                  currentPrice: currentPrice,
                                  previousClose: previousClose
                                ),
                                type: PageTransitionType.bottomToTop));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 50),
                        decoration: BoxDecoration(
                            color: previousClose < currentPrice ? Color(global_styling.LOGO_COLOR) : Colors.red,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: CustomText(
                              text: "Buy",
                              color: Color(global_styling.GREY_LOGO_COLOR),
                            )
                        )
                    )
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
}

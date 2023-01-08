import 'package:flutter/material.dart';
import 'package:invested/util/global_styling.dart' as global_styling;
import 'package:page_transition/page_transition.dart';

import '../../../../util/close_page_icon.dart';
import '../../../../util/custom_text.dart';
import '../../../../util/custom_text_field.dart';
import '../../../../util/page_title.dart';
import '../order_complete/order_complete_page.dart';
import '../util/buy_sell_info_row.dart';

class SellPage extends StatefulWidget {
  final String ticker;
  final double currentPrice;
  const SellPage({
    Key? key,
    this.ticker = "",
    this.currentPrice = 0
  }) : super(key: key);

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  double totalShares = 0;
  double estimatedOrderPrice = 0;
  String estimatedOrderDisplay = "0.00";
  String orderType = "market_order";
  bool hasLimitPrice = false;
  bool hasStopPrice = false;

  TextEditingController numberOfSharesController = TextEditingController();
  TextEditingController limitPriceController = TextEditingController();
  TextEditingController stopPriceController = TextEditingController();

  String? get numOfSharesErrorText {
    final String text = numberOfSharesController.text;

    try {
      // Try to parse to double if fail then it is not a valid number
      setState(() {
        totalShares = double.parse(text);
        estimatedOrderPrice = totalShares * widget.currentPrice;
        estimatedOrderDisplay = estimatedOrderPrice.toStringAsFixed(2);
      });
      return null;
    } catch(error) {
      return "Invalid Total Shares!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                child: Column(
                  children: [
                    const ClosePageIcon(),
                    Container(
                        margin: const EdgeInsets.only(top: 50, bottom: 20),
                        child: PageTitle(
                          alignment: Alignment.centerLeft,
                          title: "Sell ${widget.ticker}",
                          fontSize: 30,
                        )
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      child: DropdownButton(
                        value: orderType,
                        items: [
                          DropdownMenuItem(
                            value: "market_order",
                            child: CustomText(text: "Market Order"),
                          ),
                          DropdownMenuItem(
                              value: "limit_order",
                              child: CustomText(text: "Limit Order")
                          ),
                          DropdownMenuItem(
                              value: "stop_loss_order",
                              child: CustomText(text: "Stop Loss Order")
                          ),
                          DropdownMenuItem(
                              value: "stop_price_order",
                              child: CustomText(text: "Stop Price Order")
                          ),
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            orderType = value!;

                            if(orderType == "market_order") {
                              hasLimitPrice = false;
                              hasStopPrice = false;
                            } else if (orderType == "limit_order") {
                              hasLimitPrice = true;
                              hasStopPrice = false;
                            } else if (orderType == "stop_loss_order") {
                              hasLimitPrice = false;
                              hasStopPrice = true;
                            } else if (orderType == "stop_price_order") {
                              hasLimitPrice = true;
                              hasStopPrice = true;
                            }
                          });
                        },
                      ),
                    ),
                    CustomTextField(
                      textCallBack: (value) {
                        try {
                          totalShares = double.parse(value);
                        } catch(error) {
                          totalShares = 0;
                        }

                        setState(() {
                          estimatedOrderPrice = totalShares * widget.currentPrice;
                          estimatedOrderDisplay = estimatedOrderPrice.toStringAsFixed(2);
                        });
                      },
                      prefixIcon: Icons.numbers_outlined,
                      textInputType: TextInputType.number,
                      labelText: "Number of Shares",
                      hintText: "Number of Shares...",
                      errorText: numOfSharesErrorText,
                      textController: numberOfSharesController,
                    ),
                    Visibility(
                        visible: hasLimitPrice,
                        child: CustomTextField(
                            textCallBack: (value) {},
                            prefixIcon: Icons.attach_money_outlined,
                            labelText: "Enter Limit Price",
                            hintText: "Enter Limit Price...",
                            textController: limitPriceController
                        )
                    ),
                    Visibility(
                        visible: hasStopPrice,
                        child: CustomTextField(
                            textCallBack: (value) {},
                            prefixIcon: Icons.attach_money_outlined,
                            labelText: "Enter Stop Price",
                            hintText: "Enter Stop Price...",
                            textController: stopPriceController
                        )
                    ),
                    BuySellInfoRow(
                      infoPrefixText: "Market Price:",
                      infoSuffixText: "\$${widget.currentPrice.toStringAsFixed(2)}",
                    ),
                    BuySellInfoRow(
                      infoPrefixText: "Estimate Sell Price:",
                      infoSuffixText: "\$$estimatedOrderDisplay",
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 35),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: OrderCompletePage(
                                      ticker: widget.ticker,
                                      tradeType: "SELL",
                                      orderType: orderType,
                                      totalShares: totalShares,
                                      currentPrice: widget.currentPrice,
                                      finalPrice: estimatedOrderPrice,
                                      orderId: "123d-da23-232s-oi78",
                                    ),
                                    type: PageTransitionType.bottomToTop));
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
                                  text: "Place Order",
                                ),
                              )
                          ),
                        )
                    )

                  ],
                )
            )
        )
    );
  }
}

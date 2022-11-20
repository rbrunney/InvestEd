import 'dart:io';

import 'package:flutter/material.dart';
import 'package:invested/pages/stock/buy_sell/util/buy_sell_info_row.dart';
import 'package:invested/util/close_page_icon.dart';
import 'package:invested/util/custom_text_field.dart';
import 'package:invested/util/global_styling.dart' as global_styling;

import '../../../../util/custom_text.dart';
import '../../../../util/page_title.dart';

class BuyPage extends StatefulWidget {
  final String ticker;
  final double currentPrice;
  const BuyPage({
    Key? key,
    this.ticker = "",
    this.currentPrice = 0
  }) : super(key: key);

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  double totalShares = 0;
  String orderType = "market_order";
  double estimatedOrderPrice = 0;

  TextEditingController numberOfSharesController = TextEditingController();

  String? get numOfSharesErrorText {
    final String text = numberOfSharesController.text;

    try {
      // Try to parse to double if fail then it is not a valid number
      setState(() {
        totalShares = double.parse(text);
        estimatedOrderPrice = totalShares * widget.currentPrice;
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
                  margin: const EdgeInsets.only(top: 110, bottom: 20),
                  child: PageTitle(
                    alignment: Alignment.centerLeft,
                    title: "Buy ${widget.ticker}",
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
                    onChanged: (value) {  },
                  ),
                ),
                CustomTextField(
                  prefixIcon: Icons.numbers_outlined,
                  textInputType: TextInputType.number,
                  labelText: "Number of Shares",
                  hintText: "Number of Shares...",
                  errorText: numOfSharesErrorText,
                  textController: numberOfSharesController,
                ),
                BuySellInfoRow(
                  infoPrefixText: "Market Price:",
                  infoSuffixText: "\$${widget.currentPrice.toStringAsFixed(2)}",
                ),
                BuySellInfoRow(
                  infoPrefixText: "Estimate Order Price:",
                  infoSuffixText: "\$${estimatedOrderPrice.toStringAsFixed(2)}",
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 85),
                  child: InkWell(
                    onTap: () {},
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

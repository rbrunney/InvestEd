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
  double totalShares = 21.75;
  String orderType = "Market Order";

  @override
  Widget build(BuildContext context) {
    TextEditingController numberOfSharesController = TextEditingController();

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
                CustomTextField(
                  prefixIcon: Icons.numbers_outlined,
                  textInputType: TextInputType.number,
                  labelText: "Number of Shares",
                  hintText: "Number of Shares...",
                  textController: numberOfSharesController,
                ),
                BuySellInfoRow(
                  infoPrefixText: "Market Price:",
                  infoSuffixText: "\$${widget.currentPrice}",
                ),
                BuySellInfoRow(
                  infoPrefixText: "Estimate Order Price:",
                  infoSuffixText: "\$${(widget.currentPrice * totalShares)}",
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 75),
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

import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:invested/controllers/token_controllers/token_controller.dart';
import 'package:invested/controllers/url_controller/url_controller.dart';
import 'package:invested/controllers/user_data_controllers/user_data_controller.dart';
import 'package:invested/pages/buy/buy_sell_info_row.dart';
import 'package:invested/pages/landing/landing_button.dart';
import 'package:invested/pages/order_complete/order_complete.dart';
import 'package:invested/util/requests/auth_request.dart';
import 'package:invested/util/requests/basic_request.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:invested/util/widget/page/alert.dart';
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/widget/text/page_title.dart';

import '../../util/widget/page/to_previous_page_circle.dart';
import '../../util/widget/text/custom_text_field.dart';

class BuyPage extends StatefulWidget {
  final String ticker;
  final double currentPrice;
  final double previousClose;
  const BuyPage({
    Key? key,
    this.ticker = "",
    this.currentPrice = 0,
    this.previousClose = 0
  }) : super(key: key);

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  final userDataController = Get.put(UserDataController());
  final tokenController = Get.put(TokenController());
  final urlController = Get.put(URLController());

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

      if(estimatedOrderPrice > userDataController.buyingPower) {
        return "Not Enough Buying Power!";
      }

      return null;
    } catch(error) {
      return "Invalid Total Shares!";
    }
  }

  Future<String>? getLogo;
  String logo = '';

  Future<String> getTickerLogo() async {
    await BasicRequest.makeGetRequest("${urlController.localBaseURL}/invested_stock/${widget.ticker}/logo")
        .then((value) {
      var response = json.decode(value);
      setState(() {
        try {
          logo = response['results']['logo'];
        } catch(exception) {
          logo = 'https://static.vecteezy.com/system/resources/previews/002/261/149/original/black-icon-dollar-symbol-sign-isolate-on-white-background-illustration-eps-10-free-vector.jpg';
        }
      });
    });

    return '';
  }

  @override
  void initState() {
    super.initState();
    getLogo = getTickerLogo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(
              children: [
                buildTopPatch(),
                SingleChildScrollView(
                    child: Column(
                      children: [
                        const ToPrevPageCircle(),
                        buildHeader(),
                        buildDropdown(),
                        buildTextField(),
                        buildBuyInfoRows(),
                        buildPlaceOrderButton()
                      ],
                    )
                )
              ],
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
            height: MediaQuery.of(context).size.height *
                0.37, // Multiply to get 30%
            color: widget.previousClose > widget.currentPrice ? const Color(global_style.redPrimaryColor) : const Color(global_style.greenPrimaryColor))
      ],
    );
  }

  Container buildHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Column(
        children: [
          FutureBuilder(
            future: getLogo,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return buildTickerLogo();
              }

              return Center(
                  child: Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: Color(global_style.greenPrimaryColor),
                    ),
                  ));
            },
          ),
          PageTitle(
            alignment: Alignment.centerLeft,
            title: "Buy ${widget.ticker}",
            fontSize: 40,
            color: const Color(global_style.whiteAccentColor)
          ),
          CustomText(
              fontSize: 20,
              alignment: Alignment.centerLeft,
              text: "Buying Power: \$${userDataController.buyingPower.toStringAsFixed(2)}",
            color: const Color(global_style.whiteAccentColor)
          ),
        ],
      )
    );
  }

  Container buildTickerLogo() {
    return Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            logo,
            height: 125,
            width: 125,
          ),
        )
    );
  }

  Container buildDropdown() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.075),
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
    );
  }

  Container buildTextField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
      child: CustomTextField(
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
      )
    );
  }

  Container buildBuyInfoRows() {
    return Container(
      child: Column(
        children: [
          BuySellInfoRow(
            infoPrefixText: "Market Price:",
            infoSuffixText: "\$${widget.currentPrice.toStringAsFixed(2)}",
          ),
          BuySellInfoRow(
            infoPrefixText: "Estimate Order Price:",
            infoSuffixText: "\$$estimatedOrderDisplay",
          ),
        ],
      )
    );
  }

  Container buildPlaceOrderButton() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.045),
      child: LandingButton(
        text: 'Place Order',
        hasFillColor: true,
        color: widget.previousClose > widget.currentPrice ? const Color(global_style.redPrimaryColor) : const Color(global_style.greenPrimaryColor),
        onTap: () async {
          if(estimatedOrderPrice < userDataController.buyingPower) {

            // Update Buying Power
            Map<String, dynamic> requestBody = {
              "buying_power_to_add" : -estimatedOrderPrice
            };

            await AuthRequest.makePutRequest("${urlController.localBaseURL}/invested_account", requestBody, tokenController.accessToken.toString())
            .then((value) async {
              Map<String, dynamic> requestBody = {
                "ticker" : widget.ticker,
                "trade_type" : "BUY",
                "stock_quantity" : totalShares,
                "price_per_share" : widget.currentPrice,
                "order_type" : "basic-order"
              };

              await AuthRequest.makePostRequest('${urlController.localBaseURL}/invested_order/order?portfolioId=${userDataController.portfolioId}', requestBody, tokenController.accessToken.toString())
                  .then((value) {
                var response = json.decode(value);
                Navigator.push(
                    context,
                    MaterialPageRoute (
                      builder: (BuildContext context) =>  OrderCompletePage(
                        ticker: widget.ticker,
                        tradeType: "BUY",
                        orderType: orderType,
                        totalShares: totalShares,
                        currentPrice: widget.currentPrice,
                        finalPrice: estimatedOrderPrice,
                        orderId: response['results']['order_id'],
                      ),
                    )
                );
              });
            });
          } else {
            await showDialog<void>(context: context, builder: (BuildContext context) {
              return const Alert(
                title: "Order Failed!",
                message: "Not Enough Buying Power!",
                buttonMessage: "Ok",
                width: 50,
              );
            });
          }
        },
      ),
    );
  }
}

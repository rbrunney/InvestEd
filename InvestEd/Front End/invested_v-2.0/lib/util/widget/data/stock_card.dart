import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/controllers/url_controller/url_controller.dart';
import 'package:invested/pages/stock_info/basic_stock_info_page.dart';
import 'package:invested/util/requests/basic_request.dart';
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/widget/text/page_title.dart';
import 'package:page_transition/page_transition.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;

class StockCard extends StatefulWidget {
  final String ticker;
  final double totalGain;
  const StockCard({
    Key? key,
    required this.ticker,
    required this.totalGain,
  }) : super(key: key);

  @override
  State<StockCard> createState() => _StockCardState();
}

class _StockCardState extends State<StockCard> {

  final urlController = Get.put(URLController());
  String logo = '';

  Future<String>? getLogo;

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
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: BasicStockInfoPage(ticker: widget.ticker),
                type: PageTransitionType.rightToLeftWithFade)
        );
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.23,
        width: MediaQuery.of(context).size.width * 0.43,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              FutureBuilder(
                future: getLogo,
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return buildTickerLogo();
                  }

                  return Center(
                      heightFactor: 20,
                      child: Container(
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          color: Color(global_style.greenPrimaryColor),
                        ),
                      ));
                },
              ),
              buildTickerTitle(),
              buildTickerGain(),
            ],
          )
        )
      )
    );
  }

  Container buildTickerLogo() {
    return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            logo,
            height: 65,
            width: 65,
          ),
        )
    );
  }

  Container buildTickerTitle() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
      child: PageTitle(
        alignment: Alignment.center,
        title: widget.ticker,
        fontSize: 25,
        bottomMargin: 0,
      ),
    );
  }

  Container buildTickerGain() {
    bool isNegative = widget.totalGain < 0;

    Color currentTextColor = isNegative ? const Color(global_style.redAccentTextColor) : const Color(global_style.greenAccentTextColor);
    Color currentBackgroundColor =  isNegative ? const Color(global_style.redAccentColor) : const Color(global_style.greenAccentColor);

    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.005),
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.04,
          child: IntrinsicWidth(
              child: Card(
                  color: currentBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                      child: Row(
                        children: [
                          Icon(
                              isNegative ? Ionicons.arrow_down_outline : Ionicons.arrow_up_outline,
                              size: 15,
                              color: currentTextColor
                          ),
                          CustomText(
                              text: "\$${widget.totalGain.toStringAsFixed(2)}",
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: currentTextColor
                          ),
                        ],
                      )
                  )
              )
          )
      )
    );
  }
}

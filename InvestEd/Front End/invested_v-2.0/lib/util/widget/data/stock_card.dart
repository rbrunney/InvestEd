import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/pages/stock_info/basic_stock_info.dart';
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/widget/text/page_title.dart';
import 'package:page_transition/page_transition.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;

class StockCard extends StatefulWidget {
  final String tickerLogo;
  final String ticker;
  final double totalGain;
  const StockCard({
    Key? key,
    required this.tickerLogo,
    required this.ticker,
    required this.totalGain,
  }) : super(key: key);

  @override
  State<StockCard> createState() => _StockCardState();
}

class _StockCardState extends State<StockCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: const BasicStockInfoPage(),
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
              buildTickerLogo(),
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
            widget.tickerLogo,
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

import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/controllers/token_controllers/token_controller.dart';
import 'package:invested/controllers/url_controller/url_controller.dart';
import 'package:invested/util/requests/auth_request.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:invested/util/widget/text/custom_text.dart';

class CashGainCard extends StatefulWidget {
  final double cashGain;
  final double percentageGain;
  const CashGainCard({
    Key? key,
    this.cashGain = 0,
    this.percentageGain = 0
  }) : super(key: key);

  @override
  State<CashGainCard> createState() => _CashGainCardState();
}

class _CashGainCardState extends State<CashGainCard> {
  @override
  Widget build(BuildContext context) {
    bool isNegative = widget.cashGain < 0;
    double fontSize = 17;

    Color currentTextColor = isNegative ? const Color(global_style.redAccentTextColor) : const Color(global_style.greenAccentTextColor);
    Color currentBackgroundColor =  isNegative ? const Color(global_style.redAccentColor) : const Color(global_style.greenAccentColor);

    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
        child: IntrinsicWidth(
          child: Card(
              color: currentBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: Row(
                    children: [
                      CustomText(
                          text: "\$${widget.cashGain.toStringAsFixed(2)}",
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: currentTextColor
                      ),
                      const Text("  "),
                      Icon(
                          isNegative ? Ionicons.arrow_down_outline : Ionicons.arrow_up_outline,
                          size: fontSize,
                          color: currentTextColor
                      ),
                      CustomText(
                          text: "(${widget.percentageGain.toStringAsFixed(2)}%)",
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: currentTextColor
                      )
                    ],
                  )
              )
          )
        )
    );
  }
}


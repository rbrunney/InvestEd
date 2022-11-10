import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/util/global_styling.dart' as global_styling;

import '../../util/custom_text.dart';

class DisplayPortfolioGain extends StatefulWidget {
  String gainPeriod;
  double gainPercentage;
  double cashGain;

  DisplayPortfolioGain({
    Key? key,
    this.gainPeriod = 'Today',
    this.gainPercentage = 0,
    this.cashGain = 0
  }) : super(key: key);

  @override
  State<DisplayPortfolioGain> createState() => _DisplayPortfolioGainState();
}

class _DisplayPortfolioGainState extends State<DisplayPortfolioGain> {
  Color gainColor = Color(global_styling.LOGO_COLOR);

  double gainTextSize = 14;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 30),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Icon(
                MaterialCommunityIcons.arrow_up,
                size: gainTextSize,
                color: gainColor,
              ),
            ),
            CustomText(
              leftMargin: 2,
              rightMargin: 2,
              text: "\$${widget.cashGain}",
              fontSize: gainTextSize,
              color: gainColor,
            ),
            CustomText(
              leftMargin: 2,
              rightMargin: 2,
              text: "(${widget.gainPercentage}%)",
              fontSize: gainTextSize,
              color: gainColor
            ),
            CustomText(
              leftMargin: 2,
              rightMargin: 2,
              text: widget.gainPeriod,
              fontSize: gainTextSize,
            )
          ],
        )
    );
  }
}

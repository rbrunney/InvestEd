import 'package:flutter/material.dart';

import '../../util/custom_text.dart';
import '../../util/page_title.dart';

class TotalPosition extends StatelessWidget {
  final double totalShares;
  final double currentPrice;
  final double portfolioDiversity;
  const TotalPosition({
    Key? key,
    this.totalShares = 0,
    this.currentPrice = 0,
    this.portfolioDiversity = 0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30),
          child: const PageTitle(
            title: "Total Position",
            fontSize: 25,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.center,
          child: Row(
            children: [
              Column(
                children: [
                  CustomText(
                    text: "Shares",
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                  CustomText(
                    text: totalShares.toStringAsFixed(2),
                    fontSize: 18,
                  )
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  CustomText(
                    text: "Market Value",
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                  CustomText(
                    text: "\$${(currentPrice * totalShares).toStringAsFixed(2)}",
                    fontSize: 18,
                  )
                ],
              )
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomText(
              topMargin: 30,
              text: "Portfolio Diversity",
              color: Colors.grey,
              fontSize: 15,
            ),
            CustomText(
              text: "${portfolioDiversity.toStringAsFixed(2)}%",
              fontSize: 18,
              bottomMargin: 30,
            )
          ],
        )
      ],
    );
  }
}

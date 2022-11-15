import 'package:flutter/material.dart';

import '../../util/custom_text.dart';
import '../../util/page_title.dart';

class TotalPosition extends StatelessWidget {
  const TotalPosition({Key? key}) : super(key: key);

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
                    text: "1236.72183",
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
                    text: "\$1234767.123",
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
              text: "30.55%",
              fontSize: 18,
              bottomMargin: 30,
            )
          ],
        )
      ],
    );
  }
}

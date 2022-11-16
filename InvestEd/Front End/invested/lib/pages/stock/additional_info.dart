import 'package:flutter/material.dart';

import '../../util/custom_text.dart';
import '../../util/page_title.dart';

class AdditionalInformation extends StatelessWidget {
  const AdditionalInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: const PageTitle(
            title: "Additional Info",
            fontSize: 18,
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
                    text: "List Date",
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                  CustomText(
                    text: "1986-03-13",
                    fontSize: 18,
                  )
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  CustomText(
                    text: "Total Employees",
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                  CustomText(
                    text: "221000",
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
              text: "Address",
              color: Colors.grey,
              fontSize: 15,
            ),
            // Start of Address
            CustomText(
              text: "ONE MICROSOFT WAY",
              fontSize: 18,
            ),
            CustomText(
              text: "REDMOND, WA",
              fontSize: 18,
            ),
            CustomText(
              text: "98052-6399",
              fontSize: 18,
              bottomMargin: 30,
            )
          ],
        )
      ],
    );
  }
}



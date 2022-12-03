import 'package:flutter/material.dart';

import '../../util/custom_text.dart';
import '../../util/page_title.dart';

class AdditionalInformation extends StatelessWidget {
  final String listDate;
  final int totalEmployees;
  final String street;
  final String city;
  final String state;
  final String zipcode;
  const AdditionalInformation({
    Key? key,
    this.listDate = '',
    this.street = '',
    this.city = '',
    this.state = '',
    this.zipcode = '',
    this.totalEmployees = 0
  }) : super(key: key);

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
                    text: listDate,
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
                    text: '$totalEmployees',
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
              text: street,
              fontSize: 18,
            ),
            CustomText(
              text: "$city, $state",
              fontSize: 18,
            ),
            CustomText(
              text: zipcode,
              fontSize: 18,
              bottomMargin: 30,
            )
          ],
        )
      ],
    );
  }
}



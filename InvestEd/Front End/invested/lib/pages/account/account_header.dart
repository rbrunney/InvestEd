import 'package:flutter/material.dart';
import 'package:invested/util/custom_text.dart';

class AccountHeader extends StatefulWidget {
  const AccountHeader({Key? key}) : super(key: key);

  @override
  State<AccountHeader> createState() => _AccountHeaderState();
}

class _AccountHeaderState extends State<AccountHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 65, left: 20, right: 20, bottom: 65),
      child: Row(
          children: [
            const Icon(
              Icons.account_circle_outlined,
              size: 60,
            ),
            Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Robert Brunney",
                      fontSize: 25,
                    ),
                    CustomText(
                        text: "Member Since: 11-15-2022",
                        fontSize: 14,
                        color: Colors.grey
                    )
                  ],
                )
            )
          ]
      ),
    );
  }
}


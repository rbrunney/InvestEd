import 'package:flutter/material.dart';
import 'package:invested/pages/account/settings_tab.dart';

import '../../util/page_title.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15),
            child: const PageTitle(
              title: "Account",
              fontSize: 20,
            ),
          ),
          const SettingsTab(
            iconData: Icons.account_circle_outlined,
            name: "Account Info",
          ),
          const SettingsTab(
            iconData: Icons.history,
            name: "Order History",
          )
        ],
      )
    );
  }
}

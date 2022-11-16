import 'package:flutter/material.dart';
import 'package:invested/pages/account/settings_tab.dart';

import '../../../util/page_title.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15),
            child: const PageTitle(
              title: "Account",
              fontSize: 20,
            ),
          ),
          SettingsTab(
            iconData: Icons.account_circle_outlined,
            name: "Account Info",
            onTap: () {},
          ),
          SettingsTab(
            iconData: Icons.history,
            name: "Order History",
            onTap: () {},
          ),
          SettingsTab(
            iconData: Icons.bubble_chart_outlined,
            name: "Appearance",
            onTap: () {},
          ),
          SettingsTab(
            iconData: Icons.lock_outline,
            name: "Password",
            onTap: () {},
          ),
        ],
      )
    );
  }
}

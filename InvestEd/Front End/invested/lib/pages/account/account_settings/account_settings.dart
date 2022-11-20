import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/pages/account/settings_tab.dart';
import 'package:invested/util/global_styling.dart' as global_styling;

import '../../../util/custom_text.dart';
import '../../../util/page_title.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  bool darkMode = true;

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
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                  children: [
                    Icon(darkMode ? Ionicons.md_moon_outline : Ionicons.md_sunny_outline),
                    CustomText(
                      leftMargin: 20,
                      text: "Appearance",
                      fontSize: 18,
                    ),
                    const Spacer(),
                    Switch(
                      activeColor: Color(global_styling.LOGO_COLOR),
                        value: false,
                        onChanged: (value) => setState(() {
                          darkMode = !darkMode;
                        })
                    )
                  ],
              )
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


import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/pages/account/account_settings/order_history_page.dart';
import 'package:invested/pages/account/settings_tab.dart';
import 'package:invested/pages/login/forgot_password_page.dart';
import 'package:invested/util/global_styling.dart' as global_styling;
import 'package:page_transition/page_transition.dart';

import '../../../util/custom_text.dart';
import '../../../util/page_title.dart';
import 'account_info_page.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
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
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const AccountInfoPage(),
                        type: PageTransitionType.rightToLeftWithFade));
              },
            ),
            SettingsTab(
              iconData: Icons.history,
              name: "Order History",
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const OrderHistoryPage(),
                        type: PageTransitionType.rightToLeftWithFade));
              },
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                  children: [
                    Icon(global_styling.ThemeChanger.isDark ? Ionicons.md_moon_outline : Ionicons.md_sunny_outline),
                    CustomText(
                      leftMargin: 20,
                      text: "Appearance",
                      fontSize: 18,
                    ),
                    const Spacer(),
                    Switch(
                      activeColor: Color(global_styling.LOGO_COLOR),
                        value: global_styling.ThemeChanger.isDark,
                        onChanged: (value) => setState(() {
                          global_styling.currentTheme.switchTheme();
                        }
                      )
                    )
                  ],
              )
            ),
            SettingsTab(
              iconData: Icons.lock_outline,
              name: "Password",
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const ForgotPasswordPage(title: "Update",),
                        type: PageTransitionType.rightToLeftWithFade));
              },
            ),
          ],
        )
    );
  }
}


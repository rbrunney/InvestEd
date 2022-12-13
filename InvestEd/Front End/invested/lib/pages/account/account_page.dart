import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/pages/account/account_header.dart';
import 'package:invested/pages/account/account_settings/account_settings.dart';
import 'package:invested/pages/account/logout_settings/logout_settings.dart';
import 'package:invested/pages/account/settings_tab.dart';
import 'package:invested/pages/account/support_settings/contact_page.dart';
import 'package:invested/pages/account/support_settings/privacy_policy.dart';
import 'package:invested/pages/account/support_settings/support_settings.dart';
import 'package:page_transition/page_transition.dart';
import 'package:invested/util/global_styling.dart' as global_styling;

import '../../util/custom_text.dart';
import '../../util/page_title.dart';
import '../login/forgot_password_page.dart';
import '../login/login_page.dart';
import 'account_settings/account_info_page.dart';
import 'account_settings/order_history_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
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
                  ),
                  Container(
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
                  ),
                  Container(
                      margin:  const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: const PageTitle(
                              title: "Help & Support",
                              fontSize: 20,
                            ),
                          ),
                          SettingsTab(
                            iconData: Icons.email_outlined,
                            name: "Contact",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: const ContactPage(),
                                      type: PageTransitionType.rightToLeftWithFade));
                            },
                          ),
                          SettingsTab(
                            iconData: Icons.notes_outlined,
                            name: "Privacy Policy",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: const PrivacyPolicy(),
                                      type: PageTransitionType.rightToLeftWithFade));
                            },
                          )
                        ],
                      )
                  ),
                  Container(
                      margin:  const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                      child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: const PageTitle(
                                title: "Logout",
                                fontSize: 20,
                              ),
                            ),
                            SettingsTab(
                              iconData: MaterialCommunityIcons.exit_run,
                              name: "Log Out",
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const LoginPage()),
                                        (Route<dynamic> route) => false);
                              },
                            )
                          ]
                      )
                  )
                ],
              )
            )
        )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:invested/pages/account/settings_tab.dart';
import 'package:invested/pages/account/support_settings/contact_page.dart';
import 'package:invested/pages/account/support_settings/privacy_policy.dart';
import 'package:page_transition/page_transition.dart';

import '../../../util/page_title.dart';

class SupportSettings extends StatelessWidget {
  const SupportSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

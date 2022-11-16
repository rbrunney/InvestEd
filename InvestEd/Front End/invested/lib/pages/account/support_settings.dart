import 'package:flutter/material.dart';
import 'package:invested/pages/account/settings_tab.dart';

import '../../util/page_title.dart';

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
            const SettingsTab(
              iconData: Icons.email_outlined,
              name: "Contact",
            ),
            const SettingsTab(
              iconData: Icons.notes_outlined,
              name: "Terms of Service",
            ),
            const SettingsTab(
              iconData: Icons.history,
              name: "Privacy Policy",
            )
          ],
        )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/pages/account/settings_tab.dart';

import '../../util/page_title.dart';

class LogoutSettings extends StatelessWidget {
  const LogoutSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15),
              child: const PageTitle(
                title: "Logout",
                fontSize: 20,
              ),
            ),
            const SettingsTab(
              iconData: MaterialCommunityIcons.exit_run,
              name: "Log Out",
            )
          ]
        )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:invested/pages/account/account_header.dart';
import 'package:invested/pages/account/account_settings/account_settings.dart';
import 'package:invested/pages/account/logout_settings/logout_settings.dart';
import 'package:invested/pages/account/settings_tab.dart';
import 'package:invested/pages/account/support_settings/support_settings.dart';
import 'package:invested/util/page_title.dart';

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
                children: const [
                  AccountHeader(),
                  AccountSettings(),
                  SupportSettings(),
                  LogoutSettings()
                ],
              )
            )
        )
    );
  }
}

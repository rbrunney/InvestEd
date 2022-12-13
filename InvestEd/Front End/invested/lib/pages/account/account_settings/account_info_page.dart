import 'package:flutter/material.dart';
import 'package:invested/util/custom_text.dart';
import 'package:invested/util/to_previous_page.dart';

import '../../../util/page_title.dart';

class AccountInfoPage extends StatelessWidget {
  const AccountInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const ToPrevPage(),
              const PageTitle(
                alignment: Alignment.center,
                title: "Account Info",
              ),
              CustomText(
                text: "rbrunney",
              )
            ],
          ),
        ),
      )
    );
  }
}

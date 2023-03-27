import 'package:flutter/material.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:invested/util/widget/page/to_previous_page.dart';
import 'package:invested/util/widget/text/page_title.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(
                children: [
                  buildTopGreenPatch(),
                  buildHeader()
                ]
            )
        )
    );
  }

  Column buildTopGreenPatch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.35,
            color: const Color(global_style.greenPrimaryColor)
        )
      ],
    );
  }

  Container buildHeader() {
    return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
        child: Column(
          children: [
            const ToPrevPage(),
            Container(
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.01),
                child: const PageTitle(
                  title: "Settings",
                  fontSize: 35,
                  bottomMargin: 5,
                  color: Color(global_style.whiteAccentColor),
                )
            )
          ],
        )
    );
  }
}

import "package:flutter/material.dart";
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:invested/util/widget/data/lesson_card.dart';
import 'package:invested/util/widget/text/page_title.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({Key? key}) : super(key: key);

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            buildTopGreenPatch(),
            SingleChildScrollView(
              child: Column(
                children: [
                  buildHeader(),
                  const LessonCard()
                ]
              )
            )
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
            height: MediaQuery.of(context).size.height *
                0.35, // Multiply to get 30%
            color: const Color(global_style.greenPrimaryColor))
      ],
    );
  }

  Container buildHeader() {
      return Container(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.05,
          left: MediaQuery.of(context).size.width * 0.05
        ),
        child: const PageTitle(
          title: "Lessons",
          fontSize: 45,
          color: Color(global_style.whiteAccentColor),
        ),
      );
  }
}

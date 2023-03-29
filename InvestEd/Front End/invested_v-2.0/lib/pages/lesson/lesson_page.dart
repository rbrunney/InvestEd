import "package:flutter/material.dart";
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:invested/util/widget/data/lesson_card.dart';
import 'package:invested/util/widget/text/custom_text.dart';
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
                  CustomText(
                    text: 'Complete Lessons to earn more buying power!',
                    fontSize: 15,
                    color: const Color(global_style.whiteAccentColor)
                  ),
                  const LessonCard(
                    title: 'Evaluating Goals',
                    thumbnail: 'https://www.simplilearn.com/ice9/free_resources_article_thumb/smart_goals.jpg',
                    totalExercises: 6,
                    totalCashReward: 250,
                  ),
                  const LessonCard(
                    title: 'Risk Management',
                    thumbnail: 'https://www.itprotoday.com/sites/itprotoday.com/files/styles/article_featured_retina/public/GettyImages-1343006928-1401x788-49696df.jpeg?itok=5BgyVhCG',
                    totalExercises: 3,
                    totalCashReward: 150,
                  ),
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

  Column buildHeader() {
      return Column(
        children: [
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                left: MediaQuery.of(context).size.width * 0.05
              ),
              child: const PageTitle(
              title: "Lessons",
              fontSize: 45,
              color: Color(global_style.whiteAccentColor),
            ),
          )
        ],
      );
  }
}

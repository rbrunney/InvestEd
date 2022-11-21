import 'package:flutter/material.dart';
import 'package:invested/pages/lesson/subcategory/lesson_sub_category.dart';
import 'package:invested/pages/lesson/progress_radial.dart';
import 'package:invested/util/close_page_icon.dart';
import 'package:invested/util/custom_divider.dart';
import 'package:invested/util/page_title.dart';

import '../../util/custom_text.dart';

class LessonInfo extends StatelessWidget {
  final String title;
  final double reward;
  final IconData iconData;
  final double percentageComplete;
  const LessonInfo({
    Key? key,
    this.title = "",
    this.reward = 0,
    this.iconData = Icons.abc_outlined,
    this.percentageComplete = 0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const ClosePageIcon(),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: PageTitle(
                  alignment: Alignment.center,
                  title: title,
                ),
              ),
              CustomText(
                alignment: Alignment.center,
                text: "Reward: \$$reward",
                color: Colors.grey,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 50),
                alignment: Alignment.center,
                child: ProgressRadial(
                    percentageComplete: percentageComplete,
                    percentageFontSize: 25,
                    size: 150
                )
              ),
              const CustomDivider(),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: const PageTitle(
                  alignment: Alignment.centerLeft,
                  title: "Lessons",
                  fontSize: 30,
                ),
              ),
              Column(
                children: const [
                  LessonSubCategory(subCategoryName: "How Life and Investment Goals Intersect"),
                  LessonSubCategory(subCategoryName: "Set Up an Investment Goals Workflow"),
                  LessonSubCategory(subCategoryName: "Managing Time Frames"),
                  LessonSubCategory(subCategoryName: "How Much Do You Need to Save?"),
                  LessonSubCategory(subCategoryName: "How to Overcome Investment Obstacles"),
                ],
              ),
              const CustomDivider(),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: const PageTitle(
                  alignment: Alignment.centerLeft,
                  title: "Take Quiz",
                  fontSize: 30,
                ),
              ),
              LessonSubCategory(subCategoryName: "$title Quiz")
            ],
          ),
        ),
      ),
    );
  }
}

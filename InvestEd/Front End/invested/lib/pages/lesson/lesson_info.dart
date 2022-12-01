import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:invested/pages/lesson/subcategory/lesson_sub_category.dart';
import 'package:invested/pages/lesson/progress_radial.dart';
import 'package:invested/util/close_page_icon.dart';
import 'package:invested/util/custom_divider.dart';
import 'package:invested/util/page_title.dart';
import 'package:invested/util/requests.dart';
import 'package:invested/util/global_styling.dart' as global_styling;
import 'package:invested/util/global_info.dart' as global_info;
import 'package:path_provider/path_provider.dart';

import '../../util/custom_text.dart';

class LessonInfo extends StatefulWidget {
  final String title;
  final double reward;
  final IconData iconData;
  late double percentageComplete;
  LessonInfo({
    Key? key,
    this.title = "",
    this.reward = 0,
    this.iconData = Icons.abc_outlined,
    this.percentageComplete = 0
  }) : super(key: key);

  @override
  State<LessonInfo> createState() => _LessonInfoState();
}

class _LessonInfoState extends State<LessonInfo> {

  List<LessonSubCategory> lessonInfo = [];
  int totalSubCategoryCount = 0;

  @override
  void initState() {
    super.initState();
    getLessonInformation();
  }

  Future<void> getLessonInformation() async {
    lessonInfo.clear();
    Requests.makeGetRequest("${global_info.localhost_url}/invested_lesson/${widget.title}")
        .then((value) async {
      var response = json.decode(value);

      String completedLessons = '';
      int totalCompleted = 0;

      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/${global_info.username}.txt');

      try {
        completedLessons = await file.readAsString();
      } catch (e) {
        completedLessons = '';
      }

      for(int i=0; i< response['lessonInfo'].length; i++) {
        setState(() {
          bool completedLesson = completedLessons.contains(response['lessonInfo'][i]['header']);
          if(completedLesson) {
            totalCompleted += 1;
          }

          lessonInfo.add(LessonSubCategory(
            subCategoryName: response['lessonInfo'][i]['header'],
            snippets: response['lessonInfo'][i]['snippets'],
            hasFinished: completedLesson,
          ));
        });
      }

      setState(() {
        totalSubCategoryCount = response['lessonInfo'].length;
        widget.percentageComplete = (totalCompleted / totalSubCategoryCount) * 100;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          color: Color(global_styling.LOGO_COLOR),
          onRefresh: getLessonInformation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const ClosePageIcon(),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: PageTitle(
                    alignment: Alignment.center,
                    title: widget.title,
                  ),
                ),
                CustomText(
                  alignment: Alignment.center,
                  text: "Reward: \$${widget.reward}",
                  color: Colors.grey,
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 50),
                    alignment: Alignment.center,
                    child: ProgressRadial(
                        percentageComplete: widget.percentageComplete,
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
                  children: lessonInfo,
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
                LessonSubCategory(subCategoryName: "${widget.title} Quiz")
              ],
            ),
          ),
        )
      ),
    );
  }
}

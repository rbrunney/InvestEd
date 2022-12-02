import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/pages/lesson/lesson_marker.dart';
import 'package:invested/util/page_title.dart';
import 'package:invested/util/requests.dart';
import 'package:invested/util/global_styling.dart' as global_styling;
import 'package:invested/util/global_info.dart' as global_info;
import 'package:path_provider/path_provider.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({Key? key}) : super(key: key);

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  late List<double> percentagesCompleted = [];
  int totalSubCategoryCount = 0;

  @override
  void initState() {
    super.initState();
    getLessonInformation();
  }

  Future<void> getLessonInformation() async {
    List<String> lessonNames = [
      "Evaluating Goals",
      "Risk Management",
      "Stock 101",
      "Order Types"
    ];

    for (String lessonName in lessonNames) {
      Requests.makeGetRequest(
          "${global_info.localhost_url}/invested_lesson/$lessonName")
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

        for (int i = 0; i < response['lessonInfo'].length; i++) {
          setState(() {
            bool completedLesson = completedLessons.contains(
                response['lessonInfo'][i]['header']);
            if (completedLesson) {
              totalCompleted += 1;
            }
          });
        }

        setState(() {
          totalSubCategoryCount = response['lessonInfo'].length + 1;
          percentagesCompleted.add((totalCompleted / totalSubCategoryCount) * 100);
        });
      });
    }
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
                      Container(
                        margin: const EdgeInsets.only(top: 25, left: 15),
                        child: const PageTitle(title: "All Lessons"),
                      ),
                      LessonMarker(
                        iconData: MaterialCommunityIcons
                            .checkbox_marked_outline,
                        name: "Evaluating Goals",
                        reward: 500,
                        percentageComplete: (percentagesCompleted.isNotEmpty) ? percentagesCompleted[0] : 0,
                      ),
                      LessonMarker(
                        iconData: MaterialCommunityIcons.alert_octagram_outline,
                        name: "Risk Management",
                        reward: 750,
                        percentageComplete: (percentagesCompleted.isNotEmpty && percentagesCompleted.length > 1) ? percentagesCompleted[1] : 0,
                      ),
                      LessonMarker(
                        iconData: Ionicons.md_cash_outline,
                        name: "Stock 101",
                        reward: 1000,
                        percentageComplete: (percentagesCompleted.isNotEmpty && percentagesCompleted.length > 2) ? percentagesCompleted[2] : 0,
                      ),
                      LessonMarker(
                        iconData: MaterialCommunityIcons.script_text_outline,
                        name: "Order Types",
                        reward: 350,
                        percentageComplete: (percentagesCompleted.isNotEmpty && percentagesCompleted.length > 3) ? percentagesCompleted[3] : 0,
                      )
                    ],
                  )
              ),
            )
        )
    );
  }
}

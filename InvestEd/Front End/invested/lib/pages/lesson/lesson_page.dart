import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/pages/lesson/lesson_marker.dart';
import 'package:invested/util/page_title.dart';

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
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 25, left: 15),
                  child: const PageTitle(title: "All Lessons"),
                ),
                const LessonMarker(
                  iconData: MaterialCommunityIcons.checkbox_marked_outline,
                  name: "Evaluating Goals",
                  reward: 500,
                ),
                const LessonMarker(
                  iconData: MaterialCommunityIcons.alert_octagram_outline,
                  name: "Risk Management",
                  reward: 750,
                ),
                const LessonMarker(
                  iconData: Ionicons.md_cash_outline,
                  name: "Stock 101",
                  reward: 1000,
                ),
                const LessonMarker(
                  iconData: MaterialCommunityIcons.script_text_outline,
                  name: "Order Types",
                  reward: 350,
                )
              ],
            )
          ),
        )
    );
  }
}

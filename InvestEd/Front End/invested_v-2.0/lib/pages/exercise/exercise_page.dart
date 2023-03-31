import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invested/controllers/user_data_controllers/user_data_controller.dart';
import 'package:invested/pages/exercise/sub_category_snippet.dart';
import 'package:invested/pages/landing/landing_button.dart';
import 'package:invested/util/widget/page/to_previous_page_circle.dart';
import 'package:invested/util/widget/text/page_title.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;

class ExercisePage extends StatefulWidget {
  final String title;
  final List<dynamic> snippets;
  const ExercisePage({Key? key,
    this.title = "",
    this.snippets = const []
  }) : super(key: key);

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  final userDataController = Get.put(UserDataController());
  List<SubCategorySnippet> lessonInfo = [];

  @override
  void initState() {
    super.initState();
    for (var snippet in widget.snippets) {
      setState(() {
        lessonInfo.add(SubCategorySnippet(
          snippet: snippet,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      color: const Color(global_style.greenPrimaryColor),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                        child: PageTitle(
                          topMargin: 35,
                          alignment: Alignment.center,
                          color: const Color(global_style.whiteAccentColor),
                          title: widget.title,
                          fontSize: 25,
                          bottomMargin: 0,
                        ),
                      )
                    ),
                    const ToPrevPageCircle()
                  ],
                ),
                Column(
                    children: lessonInfo
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.05),
                  child: LandingButton(onTap: () {
                    Navigator.pop(context);
                  }, hasFillColor: true, text: 'Complete!',)
                )
              ],
            ),
          ),
        )
    );
  }
}

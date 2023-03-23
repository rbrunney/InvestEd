import 'package:flutter/material.dart';
import 'package:invested/pages/lesson_info/lesson_info_header.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:invested/util/widget/page/horizontal_card_slider.dart';
import 'package:invested/util/widget/video/video_player.dart';

class LessonInfoPage extends StatefulWidget {
  final String lessonTitle;
  const LessonInfoPage({
    Key? key,
    this.lessonTitle = 'Lesson Title'
  }) : super(key: key);

  @override
  State<LessonInfoPage> createState() => _LessonInfoPageState();
}

class _LessonInfoPageState extends State<LessonInfoPage> {

  String videoId = 'BsGnMpSVixg';
  List<Widget> questionCards = [];


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(global_style.whiteBackgroundColor),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  LessonHeader(headerText: widget.lessonTitle),
                  VideoPlayer(youtubeVideoId: videoId),
                  Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: HorizontalCardSlider(
                          cards: questionCards
                      )
                  )
                ],
              ),
            )));
  }
}

import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:invested/controllers/url_controller/url_controller.dart';
import 'package:invested/pages/landing/landing_button.dart';
import 'package:invested/pages/quiz/quiz_page.dart';
import 'package:invested/util/requests/basic_request.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:invested/util/widget/data/exercise_card.dart';
import 'package:invested/util/widget/page/horizontal_card_slider.dart';
import 'package:invested/util/widget/page/to_previous_page.dart';
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/widget/text/page_title.dart';
import 'package:invested/util/widget/video/video_player.dart';

class LessonInfoPage extends StatefulWidget {
  final String lessonTitle;
  final double cashReward;
  const LessonInfoPage({
    Key? key,
    this.lessonTitle = 'Lesson Title',
    this.cashReward = 0
  }) : super(key: key);

  @override
  State<LessonInfoPage> createState() => _LessonInfoPageState();
}

class _LessonInfoPageState extends State<LessonInfoPage> {

  final urlController = Get.put(URLController());
  String videoId = 'BsGnMpSVixg';
  List<String> lessonHeaders = [];
  List<List<dynamic>> lessonSnippets = [];

  Future<String>? lessonInfo;

  Future<String> getLessonInfo() async {
    await BasicRequest.makeGetRequest("${urlController.localBaseURL}/invested_lesson/${widget.lessonTitle}")
        .then((value) {
       var response = json.decode(value);

       setState(() {
         videoId = response['videoId'];
       });

       for(var lesson in response['lessonInfo']) {
         setState(() {
           lessonHeaders.add(lesson['header']);
           lessonSnippets.add((lesson['snippets'] as List));
         });
       }
    });

    return '';
  }

  @override
  void initState() {
    super.initState();
    lessonInfo = getLessonInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(global_style.whiteBackgroundColor),
            body: Stack(
              children: [
                buildTopGreenPatch(),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      buildHeader(),
                      buildVideoPlayer(),
                      buildExerciseCards()
                    ],
                  ),
                ),
                buildTakeQuizButton()
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
            height: MediaQuery.of(context).size.height * 0.35, // Multiply to get 30%
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
                child: PageTitle(
                  title: widget.lessonTitle,
                  fontSize: 35,
                  bottomMargin: 5,
                  color: const Color(global_style.whiteAccentColor),
                )
            ),
            buildRewardCard()
          ],
        )
    );
  }

  Container buildRewardCard() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, bottom: MediaQuery.of(context).size.height * 0.01),
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          child: IntrinsicWidth(
              child: Card(
                  color: const Color(global_style.greenAccentColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: CustomText(
                        alignment: Alignment.centerLeft,
                        text: "Reward: \$${widget.cashReward.toStringAsFixed(2)}",
                        fontSize: 20,
                        bottomMargin: 5,
                        color: const Color(global_style.greenAccentTextColor),
                      )
                  )
              )
          )
      )
    );
  }

  Container buildVideoPlayer() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
      child:  FutureBuilder<String>(
        future: lessonInfo,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return VideoPlayer(youtubeVideoId: videoId);
          }

          return Center(
              child: Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: Color(global_style.greenPrimaryColor),
                ),
              ));
        },
      ),
    );
  }

  Container buildExerciseCards() {
    List<Widget> exerciseCards = [];

    for(int i=0; i<lessonSnippets.length; i++) {
      exerciseCards.add(
          ExerciseCard(title: lessonHeaders.elementAt(i), snippets: lessonSnippets.elementAt(i))
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.015),
      child: Column(
        children: [
          const PageTitle(
            title: 'Exercises',
            fontSize: 30,
            bottomMargin: 0,
          ),
          HorizontalCardSlider(
              cards: exerciseCards
          )
        ],
      )
    );
  }

  Column buildTakeQuizButton() {
    return Column(
      children: [
        Expanded(
            child: Container(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                        color: const Color(global_style.whiteAccentColor),
                        child: Container(
                            margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01, horizontal: MediaQuery.of(context).size.width * 0.05),
                            child: LandingButton(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                        builder: (BuildContext context) => QuizPage(lessonTitle: widget.lessonTitle,)));
                              },
                              hasFillColor: true,
                              color: const Color(global_style.greenPrimaryColor),
                              text: 'Take Quiz',
                            )
                        )
                    )
                )
            )
        )
      ],
    );
  }
}

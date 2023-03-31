import 'package:flutter/material.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:invested/util/widget/data/question_card.dart';
import 'package:invested/util/widget/page/to_previous_page.dart';
import 'package:invested/util/widget/text/page_title.dart';

class QuizPage extends StatefulWidget {
  final String lessonTitle;
  const QuizPage({
    Key? key,
    this.lessonTitle = ''
  }) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
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
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03, vertical: MediaQuery.of(context).size.height * 0.05),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: const QuestionCard(
                              question: "What is the acronym for setting goals?",
                              correctAnswer: "S.M.A.R.T.",
                              answers: ["P.I.L.E.", "S.M.A.R.T.", "S.H.O.R.T."],
                            )
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: const QuestionCard(
                                question: "What % of men don't prepare for retirement",
                                correctAnswer: "74%",
                                answers: ["28%", "74%", "60%"],
                              )
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: const QuestionCard(
                                question: "Should you write down your goals?",
                                correctAnswer: "True",
                                answers: ["Maybe", "True", "False"],
                              )
                          ),
                        ],
                      )
                    )
                  ],
                ),
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
                  title: "${widget.lessonTitle} Quiz",
                  fontSize: 35,
                  bottomMargin: 0,
                  color: const Color(global_style.whiteAccentColor),
                )
            )
          ],
        )
    );
  }
}

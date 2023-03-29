import 'package:invested/pages/landing/landing_button.dart';
import 'package:flutter/material.dart';
import 'package:invested/pages/lesson_info/lesson_info_page.dart';
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;

class LessonCard extends StatefulWidget {
  final int lessonId;
  final String title;
  final String thumbnail;
  final int totalExercises;
  final double totalCashReward;
  const LessonCard({
      super.key,
      this.lessonId = 0,
      this.title = 'Title',
      this.thumbnail = 'https://i.pinimg.com/736x/ba/92/7f/ba927ff34cd961ce2c184d47e8ead9f6.jpg',
      this.totalExercises = 0,
      this.totalCashReward = 0
  });

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Column(
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: Column(
                      children: [
                         buildThumbnail(),
                         buildLessonTitleRow(),
                         buildExerciseRow(),
                         buildLessonButton('Begin')
                      ],
                    )),
              ],
            )));
  }

  Container buildThumbnail() {
    return Container(
        margin: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: Image.network(
            widget.thumbnail,
            width: 350,
            height: 120,
            fit: BoxFit.cover,
          ),
        )
    );
  }

  Container buildLessonTitleRow() {
    return Container(
        margin: const EdgeInsets.symmetric(
            horizontal: 15, vertical: 10),
        child: Row(
          children: [
            CustomText(
                text: widget.title,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
            const Spacer(),
            CustomText(
                text: '\$${widget.totalCashReward.toStringAsFixed(2)}',
                fontSize: 18,
                fontWeight: FontWeight.bold
            )
          ],
        )
    );
  }

  Container buildExerciseRow() {
    List<Widget> dots = [];

    for(int i=0; i< widget.totalExercises; i++) {
      dots.add(buildExerciseDot(const Color(global_style.greenAccentColor)));
    }

    return Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
        child: Row(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                margin:
                const EdgeInsets.symmetric(horizontal: 15),
                child: CustomText(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  text: '${widget.totalExercises} exercises',
                )
            ),
            const Spacer(),
            Container(
                margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.03),
                child: Row(
                  children: dots,
                )
            )
          ],
        )
    );
  }

  Container buildExerciseDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Container buildLessonButton(String buttonText) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width* 0.03),
        child: LandingButton(
          text: buttonText,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => LessonInfoPage(lessonTitle: widget.title, cashReward: widget.totalCashReward)));
          },
          hasFillColor: true,
        )
    );
  }
}
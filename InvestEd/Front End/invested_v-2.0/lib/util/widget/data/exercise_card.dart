import 'package:flutter/material.dart';
import 'package:invested/pages/exercise/exercise_page.dart';
import 'package:invested/pages/landing/landing_button.dart';
import 'package:invested/util/widget/text/custom_text.dart';

class ExerciseCard extends StatefulWidget {
  final String title;
  final List<dynamic> snippets;
  const ExerciseCard({
    Key? key,
    this.title = '',
    this.snippets = const []
  }) : super(key: key);

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
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
                        buildExerciseTitle(),
                        buildExerciseButton('Begin')
                      ],
                    )),
              ],
            )));
  }

  Container buildExerciseTitle() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.06, horizontal: MediaQuery.of(context).size.width * 0.05),
      child: CustomText(
        text: widget.title,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      )
    );
  }

  Container buildExerciseButton(String buttonText) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.05,
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
        child: LandingButton(
          text: buttonText,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => const ExercisePage()));
          },
          hasFillColor: true,
        )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:invested/pages/exercise/exercise_page.dart';
import 'package:invested/pages/landing/landing_button.dart';
import 'package:invested/util/widget/text/custom_text.dart';

class ExerciseCard extends StatefulWidget {
  final String thumbnail;
  const ExerciseCard({
    Key? key,
    this.thumbnail = 'https://i.pinimg.com/736x/ba/92/7f/ba927ff34cd961ce2c184d47e8ead9f6.jpg'
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
                        buildThumbnail(),
                        buildExerciseTitle(),
                        buildExerciseButton('Begin')
                      ],
                    )),
              ],
            )));
  }

  Container buildThumbnail() {
    return Container(
        margin: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius:
          const BorderRadius.all(Radius.circular(15)),
          child: Image.network(
            widget.thumbnail,
            width: 350,
            height: 110,
            fit: BoxFit.cover,
          ),
        )
    );
  }

  Container buildExerciseTitle() {
    return Container(
      child: CustomText(
        text: ,
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

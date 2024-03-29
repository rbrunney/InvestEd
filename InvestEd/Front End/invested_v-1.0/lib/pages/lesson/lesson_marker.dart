import 'package:flutter/material.dart';
import 'package:invested/pages/lesson/lesson_info.dart';
import 'package:invested/pages/lesson/progress_radial.dart';
import 'package:page_transition/page_transition.dart';

import '../../util/custom_text.dart';

class LessonMarker extends StatelessWidget {
  final String name;
  final double reward;
  final IconData iconData;
  final double percentageComplete;
  const LessonMarker({
    Key? key,
    this.name = '',
    this.reward = 0,
    this.percentageComplete = 0,
    this.iconData = Icons.abc_outlined
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: LessonInfo(
                  title: name,
                  reward: reward,
                  percentageComplete: percentageComplete,
                  iconData: iconData,
                ),
                type: PageTransitionType.fade));
      },
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Icon(iconData),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: name,
                            fontSize: 20,
                          ),
                          CustomText(
                            text: "Reward: \$$reward",
                            fontSize: 14,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    ProgressRadial(percentageComplete: percentageComplete)
                  ],
                ),
              )
          )
      )
    );
  }
}

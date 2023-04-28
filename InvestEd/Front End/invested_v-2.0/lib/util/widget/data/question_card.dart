import 'package:flutter/material.dart';
import 'package:invested/pages/landing/landing_button.dart';
import 'package:invested/util/widget/page/alert.dart';
import 'package:invested/util/widget/text/page_title.dart';

class QuestionCard extends StatefulWidget {
  final String question;
  final String correctAnswer;
  final List<String> answers;
  const QuestionCard({Key? key, this.question = '', this.correctAnswer = '', this.answers = const []}) : super(key: key);

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
              child: PageTitle(title: widget.question, fontSize: 20, alignment: Alignment.center),
            ),
            ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  try {
                    return Container(
                        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                        child: LandingButton(
                            text: widget.answers[index],
                            hasFillColor: true,
                            onTap: () async {
                              if(widget.correctAnswer == widget.answers[index]) {
                                await showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const Alert(
                                        title: "Correct",
                                        message: "Good Job that was right!",
                                        buttonMessage: "Continue!",
                                        width: 50,
                                      );
                                    });
                              } else {
                                await showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const Alert(
                                        title: "Wrong",
                                        message: "Be Built Different Try Again!",
                                        buttonMessage: "Continue!",
                                        width: 50,
                                      );
                                    });
                              }
                            }
                        )
                    );
                  } catch(exception) {}
                  return null;
                },
                separatorBuilder:
                    (BuildContext context, int index) =>
                const Divider()
            )
          ],
        )
    );
  }
}

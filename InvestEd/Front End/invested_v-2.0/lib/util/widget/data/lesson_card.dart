import 'package:invested/pages/landing/landing_button.dart';
import 'package:flutter/material.dart';
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;

class LessonCard extends StatefulWidget {
  final int lessonId;
  final String lessonTitle;
  final String lessonThumbnail;
  final String videoId;
  final int totalExcercise;
  final int totalRewardPoints;
  const LessonCard(
      {super.key,
        this.lessonId = 0,
        this.lessonTitle = 'Title',
        this.lessonThumbnail =
        'https://i.pinimg.com/736x/ba/92/7f/ba927ff34cd961ce2c184d47e8ead9f6.jpg',
        this.videoId = '',
        this.totalExcercise = 0,
        this.totalRewardPoints = 0});

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  List<Widget> excerciseDots = [];
  List<dynamic> questions = [];

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
                        Container(
                            margin: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                              child: Image.network(
                                widget.lessonThumbnail,
                                width: 350,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            )),
                        Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Row(
                              children: [
                                CustomText(
                                    text: widget.lessonTitle,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                                const Spacer(),
                                CustomText(
                                  text: '\$${widget.totalRewardPoints}',
                                  fontSize: 18,
                                    fontWeight: FontWeight.bold
                                )
                              ],
                            )),
                        Container(
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
                                  text: '${excerciseDots.length} exercises',
                                )
                              ),
                              const Spacer(),
                              Container(
                                margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.03),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      margin: const EdgeInsets.symmetric(horizontal: 2),
                                      decoration: const BoxDecoration(
                                        color: Color(global_style.greenAccentColor),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Container(
                                      width: 12,
                                      height: 12,
                                      margin: const EdgeInsets.symmetric(horizontal: 2),
                                      decoration: const BoxDecoration(
                                        color: Color(global_style.greenAccentColor),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Container(
                                      width: 12,
                                      height: 12,
                                      margin: const EdgeInsets.symmetric(horizontal: 2),
                                      decoration: const BoxDecoration(
                                        color: Color(global_style.greenAccentColor),
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  ],
                                )

                                )

                            ],
                              )
                        ),
                        // Row(
                        //   children: [
                        //     FutureBuilder<String>(
                        //         future: BasicRequest.makeGetRequest(''),
                        //         builder: (context, snapshot) {
                        //           if(snapshot.hasData) {
                        //             List<dynamic> response = json.decode(snapshot.data!);
                        //
                        //             for(var question in response) {
                        //               if(question['lesson_id'] == widget.lessonId) {
                        //                 excerciseDots.add(Container(
                        //                   width: 12,
                        //                   height: 12,
                        //                   margin: const EdgeInsets.symmetric(horizontal: 2),
                        //                   decoration: const BoxDecoration(
                        //                     color: Color(global_style.greenAccentColor),
                        //                     shape: BoxShape.circle,
                        //                   ),
                        //                 ));
                        //
                        //                 questions.add(question);
                        //               }
                        //             }
                        //
                        //             return Container(
                        //               alignment: Alignment.centerLeft,
                        //               margin:
                        //               const EdgeInsets.symmetric(horizontal: 15),
                        //               child: Text(
                        //                   style: TextStyle(
                        //                       fontSize: 16,
                        //                       fontFamily: global_style.textFont,
                        //                       fontWeight: FontWeight.bold),
                        //                   '${excerciseDots.length} exercises'),
                        //             );
                        //           }
                        //
                        //           return Center(
                        //               heightFactor: 20,
                        //               child: Container(
                        //                 alignment: Alignment.center,
                        //                 child: const CircularProgressIndicator(
                        //                   color: Color(global_style.greenAccentColor),
                        //                 ),
                        //               ));
                        //         }
                        //     ),
                        //     const Spacer(),
                        //     FutureBuilder<String>(
                        //         future: BasicRequest.makeGetRequest(''),
                        //         builder: (context, snapshot) {
                        //           if(snapshot.hasData) {
                        //             return Container(
                        //                 margin:
                        //                 const EdgeInsets.symmetric(horizontal: 15),
                        //                 child: Row(
                        //                   children: excerciseDots,
                        //                 ));
                        //           }
                        //           return Center(
                        //               heightFactor: 20,
                        //               child: Container(
                        //                 alignment: Alignment.center,
                        //                 child: const CircularProgressIndicator(
                        //                   color: Color(global_style.greenAccentColor),
                        //                 ),
                        //               ));
                        //         }
                        //     )
                        //   ],
                        // ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width* 0.03),
                          child: LandingButton(
                            text: 'Begin',
                            onTap: () {  },
                            hasFillColor: true,
                          )
                        )
                      ],
                    )),
              ],
            )));
  }
}
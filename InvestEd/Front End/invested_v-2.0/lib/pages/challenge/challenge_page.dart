import 'package:flutter/material.dart';
import 'package:invested/util/global_styling.dart' as global_style;

class ChallengePage extends StatefulWidget {
  const ChallengePage({Key? key}) : super(key: key);

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.35, // Multiply to get 30%
                          color: const Color(global_style.greenPrimaryColor)
                      )
                    ],
                  ),
                  SingleChildScrollView(
                      child: Column(
                          children: const []
                      )
                  )
                ]
            )
        )
    );
  }
}

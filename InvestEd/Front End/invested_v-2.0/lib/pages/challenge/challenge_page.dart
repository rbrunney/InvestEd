import 'package:flutter/material.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:invested/util/widget/data/leaderboard_card.dart';
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/widget/text/page_title.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({Key? key}) : super(key: key);

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {

  bool isSelected = true;

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
                            buildTabSelection(),
                            buildTopThree(),
                            buildLeaderboard()
                          ]
                      )
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
            height: MediaQuery.of(context).size.height * 0.35,
            color: const Color(global_style.greenPrimaryColor)
        )
      ],
    );
  }

  Container buildHeader() {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.05,
          left: MediaQuery.of(context).size.width * 0.05
      ),
      child: const PageTitle(
        title: "Leaderboard",
        fontSize: 45,
        bottomMargin: 0,
        color: Color(global_style.whiteAccentColor),
      ),
    );
  }

  Container buildTabSelection() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.03),
        decoration: const BoxDecoration(
          color: Color(global_style.whiteBackgroundColor),
          borderRadius: BorderRadius.all(Radius.circular(15))
        ),
      child: Row(
        children: [
          Expanded(
            child: buildSelector('Global', isSelected),
          ),
          Expanded(
            child: buildSelector('Friends', !isSelected),
          )
        ],
      )
    );
  }

  InkWell buildSelector(String text, bool isTouched) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: isTouched ? const Color(global_style.greenAccentColor) : const Color(global_style.whiteBackgroundColor),
            borderRadius: const BorderRadius.all(Radius.circular(12))
        ),
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01, vertical: MediaQuery.of(context).size.height * 0.005),
        child: CustomText(
          text: text,
          color: const Color(global_style.greenAccentTextColor),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )
      )
    );
  }

  SizedBox buildTopThree() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.05),
            child: Column(
              children: const [
                Expanded(
                    child: LeaderboardCard(place: 1, color: Color(global_style.firstPlace))
                ),
                Expanded(
                    child: LeaderboardCard(place: 2, color: Color(global_style.secondPlace))
                ),
                Expanded(
                    child: LeaderboardCard(place: 3, color: Color(global_style.thirdPlace))
                )
              ],
            )
          )
        )
    );
  }

  Column buildLeaderboard() {
    return Column(
      children: const [
        LeaderboardCard(place: 4, color: Color(global_style.whiteAccentColor)),
        LeaderboardCard(place: 4, color: Color(global_style.whiteAccentColor)),
        LeaderboardCard(place: 4, color: Color(global_style.whiteAccentColor)),
        LeaderboardCard(place: 4, color: Color(global_style.whiteAccentColor)),
        LeaderboardCard(place: 4, color: Color(global_style.whiteAccentColor)),
        LeaderboardCard(place: 4, color: Color(global_style.whiteAccentColor))
      ],
    );
  }
}

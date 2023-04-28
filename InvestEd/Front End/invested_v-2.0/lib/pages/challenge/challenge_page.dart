import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invested/controllers/user_data_controllers/user_data_controller.dart';
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
    final userDataController = Get.put(UserDataController());


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
              children: [
                Expanded(
                    child: LeaderboardCard(
                      place: 1,
                      color: const Color(global_style.firstPlace),
                      name: userDataController.name,
                      photo: userDataController.photoUrl,
                      portfolioValue: userDataController.buyingPower,
                    )
                ),
                const Expanded(
                    child: LeaderboardCard(
                      place: 2,
                      color: Color(global_style.secondPlace),
                      name: "Alex Turro",
                      photo: "https://media.licdn.com/dms/image/C4E03AQG_JzuhI9g9Xg/profile-displayphoto-shrink_200_200/0/1644863063721?e=1683158400&v=beta&t=aqYRDO70nlaXlbTGOksVsfSmfyON2biCgamnLPTJIcI",
                      portfolioValue: 4237.45,
                    )
                ),
                const Expanded(
                    child: LeaderboardCard(
                      place: 3,
                      color: Color(global_style.thirdPlace),
                      name: "Nirvik Sharma",
                      photo: "https://media.licdn.com/dms/image/C4D03AQHf3_ZulJPOvw/profile-displayphoto-shrink_200_200/0/1637709857399?e=1684972800&v=beta&t=5VeTgpM3TrrNED7mySPrRAQVqJrvzirquO2jXKejCvk",
                      portfolioValue: 4135.79,
                    )
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
        LeaderboardCard(
          place: 4,
          color: Color(global_style.whiteAccentColor),
          name: "Chris Stanley",
          photo: "https://media.licdn.com/dms/image/C5603AQGho2h3lCyg_A/profile-displayphoto-shrink_200_200/0/1644949516950?e=1685577600&v=beta&t=CO7eBVZHbjSuffMUL-UYoPEnHobnqUTsipulK-Ne0TI",
          portfolioValue: 4017.32,
        ),
        LeaderboardCard(
          place: 5,
          color: Color(global_style.whiteAccentColor),
          name: "David Ngo",
          photo: "https://media.licdn.com/dms/image/C4D03AQGvfpuEbKNvcw/profile-displayphoto-shrink_200_200/0/1644867826683?e=1685577600&v=beta&t=BitgUGYQRHXfpdXXO3wwuMnZLgJoVj3B6ywA2mTpdMw",
          portfolioValue: 3985.12,
        ),
        LeaderboardCard(
          place: 6,
          color: Color(global_style.whiteAccentColor),
          name: "Liam Douglass",
          photo: "https://media.licdn.com/dms/image/D5603AQFs2cjVYBiIkg/profile-displayphoto-shrink_200_200/0/1665758366799?e=1685577600&v=beta&t=3iZ8bkqwInBjVUvGHgokWy3ZE4mOEjlL3oGQmRICdFI",
          portfolioValue: 3834.14,
        ),
        LeaderboardCard(
          place: 7,
          color: Color(global_style.whiteAccentColor),
          name: "Josh Johnson",
          photo: "https://media.licdn.com/dms/image/D5603AQGCq0v9EiWA6g/profile-displayphoto-shrink_200_200/0/1673041935049?e=1685577600&v=beta&t=oIs_xK2r0bFhnGMgxvR37633W1uum64I4YX-CtyQnfM",
          portfolioValue: 1590.01,
        )
      ],
    );
  }
}

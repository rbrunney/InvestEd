import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:invested/controllers/user_data_controllers/user_data_controller.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/widget/text/page_title.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final userDataController = Get.put(UserDataController());
  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(
                children: [
                  buildTopGreenPatch(),
                  Stack(
                    children: [
                      buildProfileCard(),
                      buildProfilePicture(),
                      buildSettingsButton()
                    ],
                  )
                ]
            )
        )
    );
  }

  Container buildProfilePicture() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1, left: MediaQuery.of(context).size.width * 0.35),
      child:  InkWell(
        onTap: () {
          print('Profile Settings');
        },
        child: CircleAvatar(
            radius: 60,
            backgroundColor: const Color(global_style.greenAccentColor),
            child: CircleAvatar(
              radius: 57,
              backgroundImage: userDataController.photoUrl != ""
                  ? NetworkImage(userDataController.photoUrl)
                  : null,
              child: userDataController.photoUrl != ""
                  ? null
                  : const Icon(
                Icons.account_circle_outlined,
                size: 57,
              ),
            )
        )
      )
    );
  }

  Container buildSettingsButton() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2, left: MediaQuery.of(context).size.width * 0.55),
      child: InkWell(
        onTap: () {
          print('Profile Settings');
        },
        child: const CircleAvatar(
          radius: 20,
          backgroundColor: Color(global_style.greenAccentColor),
          child: CircleAvatar(
              radius: 17,
              backgroundColor: Color(global_style.whiteAccentColor),
              child: Icon(Icons.settings, color: Color(global_style.greenAccentTextColor))
          ),
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

  Container buildProfileCard() {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02, vertical: MediaQuery.of(context).size.height * 0.01),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: const Color(global_style.whiteAccentColor),
          child: Column(
            children: [
              buildCardUsername(),
              buildCardHeader(),
            ],
          ),
        )
      )
    );
  }

  Container buildCardUsername() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
      child: PageTitle(
        alignment: Alignment.center,
        title: userDataController.name,
        fontSize: 30,
      )
    );
  }

  Container buildCardHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.01),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.13,
        width: MediaQuery.of(context).size.width,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: const Color(global_style.greenPrimaryColor),
          child: Row(
            children: [
              Expanded(
                child: buildHeaderTab(Ionicons.globe_outline, 'Rank', '# 1')
              ),
              Expanded(
                child: InkWell(
                    onTap: () {
                      print('Friends List');
                    },
                    child: buildHeaderTab(Ionicons.people_outline, 'Friends', '0')
                )
              )
            ],
          ),
        )
      )
    );
  }

  Container buildHeaderTab(IconData icon, String tabHeader, String statNumber) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.015),
      child: Column(
        children: [
          Expanded(
            child: Icon(
              icon,
              color: const Color(global_style.whiteAccentColor),
              size: 25,
            ),
          ),
          Expanded(
              child: CustomText(
                text: tabHeader,
                color: const Color(global_style.greenAccentColor),
              )
          ),
          Expanded(
              child:  CustomText(
                text: statNumber,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: const Color(global_style.whiteAccentColor),
              )
          )
        ],
      )
    );
  }
}
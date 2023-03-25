import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:invested/controllers/user_data_controllers/user_data_controller.dart';
import 'package:invested/util/widget/text/custom_text.dart';

class LeaderboardCard extends StatefulWidget {
  final Color color;
  final int place;
  const LeaderboardCard({Key? key, required this.place, required this.color}) : super(key: key);

  @override
  State<LeaderboardCard> createState() => _LeaderboardCardState();
}

class _LeaderboardCardState extends State<LeaderboardCard> {

  final userDataController = Get.put(UserDataController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.85,
      child: Card(
        color: widget.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: CustomText(
                  text: "${widget.place}.",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex: 1,
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: userDataController.photoUrl != ""
                      ? NetworkImage(userDataController.photoUrl)
                      : null,
                  child: userDataController.photoUrl != ""
                      ? null
                      : const Icon(
                    Icons.account_circle_outlined,
                    size: 25,
                  ),
                )
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: userDataController.name,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      text: "\$4500.75",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                )
              )
            ],
          )
      ),
    );
  }
}

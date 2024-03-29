import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/pages/login/login_page.dart';
import 'package:invested/util/page_image.dart';
import 'package:invested/util/page_title.dart';
import 'package:invested/util/custom_text_field.dart';
import 'package:invested/util/requests.dart';
import 'package:invested/util/to_previous_page.dart';
import '../../util/custom_text.dart';
import '../../util/global_styling.dart' as global_styling;
import '../../util/global_info.dart' as global_info;

class AccountDetailsPage extends StatefulWidget {
  final String username;
  final String email;
  final String password;
  const AccountDetailsPage({
    Key? key,
    this.username = '',
    this.email = '',
    this.password = ''
  }) : super(key: key);

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  TextEditingController birthdayController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();

  String? get birthdayErrorText {
    final text = birthdayController.text;

    List<String> dateInfo = text.split("-");
    RegExp birthdayCheck = RegExp(r'^([0-9]{2})-([0-9]{2})-([0-9]{4})$');

    int MAX_MONTH = 12;
    int MAX_FULL_MONTH_DAY = 31;
    int MAX_PARTIAL_MONTH_DAY = 30;
    int MAX_FEBRUARY_DAY = 28;
    int MAX_FEBRUARY_LEAP_DAY = 29;
    int APRIL = 4;
    int JUNE = 6;
    int SEPTEMBER = 9;
    int NOVEMBER = 11;

    if(!birthdayCheck.hasMatch(text)) {
      return 'Birthday does not match MM-DD-YYYY';
    } else if (int.parse(dateInfo[0]) > MAX_MONTH) {
      return 'Invalid Month!';
    }
    // Checking to see if the date in APRIL, JUNE, SEPTEMBER, NOVEMBER is over 30
    else if ([APRIL, JUNE, SEPTEMBER, NOVEMBER].contains(int.parse(dateInfo[0])) && int.parse(dateInfo[1]) > MAX_PARTIAL_MONTH_DAY) {
      return 'Invalid Day!';
    }
    // Checking any other month hat was not listed before
    else if (int.parse(dateInfo[0]) != 2 && int.parse(dateInfo[1]) > MAX_FULL_MONTH_DAY) {
      return 'Invalid Day!';
    }
    // Checking to see if the year is dividable by 4, meaning its a leap year, and need to check FEBRUARY date
    else if (int.parse(dateInfo[2]) % 4 == 0 && int.parse(dateInfo[0]) == 2 && int.parse(dateInfo[1]) > MAX_FEBRUARY_LEAP_DAY) {
      return 'Invalid Day!';
    }
    // Checking to see if FEBRUARY date is valid when it is not a leap year
    else if (int.parse(dateInfo[2]) % 4 != 0 && int.parse(dateInfo[0]) == 2 && int.parse(dateInfo[1]) > MAX_FEBRUARY_DAY) {
      return 'Invalid Day!';
    }

    return null;
  }

  void onSubmit() async {
    if (fnameController.text.isNotEmpty && lnameController.text.isNotEmpty && birthdayErrorText == null) {
      Future<List<String>> getAllItems() async {
        List<String> userInfo = [
          widget.username, widget.password, fnameController.text, lnameController.text, birthdayController.text, widget.email
        ];

        return Future.wait<String>(
            userInfo.map((item) =>
            Requests.makeGetRequest('${global_info.localhost_url}/invested_account/encrypt/$item')
                .then((value) {
              return value;
            })).toList()
        );
      }

      List<String> userInfo = await getAllItems();

      Map<String, dynamic> requestBody = {
        "username" : userInfo[0],
        "password" : userInfo[1],
        "firstName" : userInfo[2],
        "lastName" : userInfo[3],
        "birthdate" : userInfo[4],
        "email" : userInfo[5],
        "buyingPower" : 5000
      };

      Requests.makePostRequest('${global_info.localhost_url}/invested_account', requestBody)
      .then((value) {

        requestBody = {
          "username" : userInfo[0],
          "password" : userInfo[1]
        };

        Requests.makePostRequest('${global_info.localhost_url}/invested_account/authenticate', requestBody)
        .then((value) async {
          var response = json.decode(value);
          await Requests.makePostRequestWithAuth('${global_info.localhost_url}/invested_portfolio', requestBody, response['results']['access-token'])
          .then((value) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false);
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold (
          body: SingleChildScrollView(
            child: Column(
              children: [
                const ToPrevPage(),
                const PageImage(assetImg: 'assets/images/icon.png', marginTop: 7),
                const PageTitle(title: 'Final Steps'),
                CustomText(
                  leftMargin: 15,
                  rightMargin: 15,
                  topMargin: 10,
                  bottomMargin: 10,
                  text: "Almost Finished! We just need a little bit more information about you!",
                  fontSize: 15,
                ),
                CustomTextField(
                    textCallBack: (value) {},
                    labelText: 'Enter First Name',
                    hintText: 'Enter First Name...',
                    errorText: null,
                    prefixIcon: MaterialCommunityIcons.account_edit_outline,
                    textController: fnameController
                ),
                CustomTextField(
                    textCallBack: (value) {},
                    labelText: 'Enter Last Name',
                    hintText: 'Enter Last Name...',
                    errorText: null,
                    prefixIcon: MaterialCommunityIcons.account_edit_outline,
                    textController: lnameController
                ),
                CustomTextField(
                    textCallBack: (value) {},
                    labelText: 'Enter Birthday',
                    hintText: 'MM-DD-YYYY',
                    errorText: birthdayErrorText,
                    prefixIcon: Icons.calendar_today_outlined,
                    textController: birthdayController
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width - 30,
                        child: ElevatedButton(
                            onPressed: fnameController.text.isNotEmpty && lnameController.text.isNotEmpty && birthdayController.text.isNotEmpty?
                            onSubmit :
                                () {},
                            style: ElevatedButton.styleFrom(
                              primary: Color(global_styling.LOGO_COLOR),
                            ),
                            child: Text(
                              "Create Account",
                              style: TextStyle(
                                  fontFamily: global_styling.TITLE_FONT
                              ),
                            )
                        )
                    )
                ),
              ],
            ),
          )
        )
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invested/pages/login/change_password_page.dart';
import 'package:invested/util/page_image.dart';
import 'package:invested/util/page_title.dart';
import 'package:invested/util/custom_text_field.dart';
import 'package:invested/util/requests.dart';
import 'package:invested/util/to_previous_page.dart';
import 'package:page_transition/page_transition.dart';
import '../../util/alert.dart';
import '../../util/custom_text.dart';
import '../../util/global_styling.dart' as global_styling;
import '../../util/global_info.dart' as global_info;

class VerificationCodePage extends StatefulWidget {
  final String userEmail;
  const VerificationCodePage({
    Key? key,
    this.userEmail = ''
  }) : super(key: key);

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  TextEditingController codeController = TextEditingController();

  String? get verificationCodeErrorText {
    final text = codeController.text;

    if(text.isEmpty) {
      return 'Field is Empty!';
    } else if (text.length > 6 || text.length < 6) {
      return 'Invalid Code!';
    }

    return null;
  }

  void onSubmit() {
    if (verificationCodeErrorText == null) {

      Map<String, dynamic> requestBody = {
        "user_email" : widget.userEmail,
        "verification_code" : codeController.text
      };

      Requests.makePostRequest('${global_info.localhost_url}/invested_account/verify_code', requestBody)
      .then((value) async {
        var response = json.decode(value);
        print(response);
        if(response['results']['status-code'] == 400) {
          await showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return Alert(
                  title: "Verification Failed!",
                  message: "Please try again!",
                  buttonMessage: "Retry",
                  width: 50,
                  popExtra: true,
                );
              }
          );
        } else if (response['results']['status-code'] == 200) {
          print(response['results']);
          // Send code off to get validated
          Navigator.push(
              context,
              PageTransition(
                  child: const ChangePasswordPage(),
                  type: PageTransitionType.rightToLeftWithFade
              )
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const ToPrevPage(),
                  const PageImage(assetImg: 'assets/images/icon.png', marginTop: 7),
                  const PageTitle(title: "Enter Code"),
                  CustomText(
                    leftMargin: 15,
                    rightMargin: 15,
                    topMargin: 10,
                    bottomMargin: 10,
                    text: "We have sent an email with your verification code! Please check your email.",
                    fontSize: 15,
                  ),
                  CustomTextField(
                      textCallBack: (value) {},
                      hintText: 'Enter Verification Code...',
                      labelText: 'Enter Verification Code',
                      errorText: verificationCodeErrorText,
                      textInputType: TextInputType.number,
                      textFormatters: [FilteringTextInputFormatter.digitsOnly],
                      prefixIcon: Icons.dialpad_outlined,
                      textController: codeController
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width - 30,
                          child: ElevatedButton(
                              onPressed: codeController.text.isNotEmpty ? onSubmit : () {},
                              style: ElevatedButton.styleFrom(
                                primary: Color(global_styling.LOGO_COLOR),
                              ),
                              child: Text(
                                "Submit Code",
                                style: TextStyle(
                                    fontFamily: global_styling.TITLE_FONT
                                ),
                              )
                          )
                      )
                  ),
                ],
              )
            )
        )
    );
  }
}



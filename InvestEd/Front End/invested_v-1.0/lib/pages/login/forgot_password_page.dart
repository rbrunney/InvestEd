import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:invested/util/page_image.dart';
import 'package:invested/util/page_title.dart';
import 'package:invested/pages/login/verification_code_page.dart';
import 'package:invested/util/custom_text.dart';
import 'package:invested/util/custom_text_field.dart';
import 'package:invested/util/requests.dart';
import 'package:invested/util/to_previous_page.dart';
import 'package:page_transition/page_transition.dart';
import '../../util/global_styling.dart' as global_styling;
import '../../util/global_info.dart' as global_info;

class ForgotPasswordPage extends StatefulWidget {
  final String title;
  const ForgotPasswordPage({
    Key? key,
    this.title = "",
  }) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();

  String? get emailErrorText {
    final text = emailController.text;
    RegExp emailCheck = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    // Simple checks to see if empty or doesn't match regex
    if (!emailCheck.hasMatch(text)) {
      return 'Invalid Email!';
    }

    // Return null is string is valid
    return null;
  }

  void onSubmit() {
    if (emailErrorText == null) {

      Requests.makeGetRequest('${global_info.localhost_url}/invested_account/forgot_password/${emailController.text}')
      .then((value){
        var response = json.decode(value);
        if(response['results']['status-code'] == 200) {
          Navigator.push(
              context,
              PageTransition(
                  child: VerificationCodePage(userEmail: emailController.text),
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
        body: SingleChildScrollView (
          child: Column(
              children: [
                const ToPrevPage(),
                const PageImage(assetImg: 'assets/images/icon.png', marginTop: 7),
                PageTitle(title: widget.title),
                const PageTitle(title: "Password?"),
                CustomText(
                  leftMargin: 15,
                  rightMargin: 15,
                  topMargin: 10,
                  bottomMargin: 10,
                  text: "Don't worry! We will send you a one time code! Please enter your email.",
                  fontSize: 15,
                ),
                CustomTextField(
                  textCallBack: (value) {},
                  hintText: 'Enter Email...',
                  labelText: 'Enter Email',
                  prefixIcon: Icons.email_outlined,
                  textController: emailController,
                  errorText: emailErrorText,
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width - 30,
                        child: ElevatedButton(
                            onPressed: emailController.value.text.isNotEmpty ?
                            onSubmit :
                            () {},
                            style: ElevatedButton.styleFrom(
                              primary: Color(global_styling.LOGO_COLOR),
                            ),
                            child: Text(
                              "Send Email",
                              style: TextStyle(
                                  fontFamily: global_styling.TITLE_FONT
                              ),
                            )
                        )
                    )
                ),
              ]
          ),
        )
      )
    );
  }
}

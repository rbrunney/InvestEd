import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:invested/pages/login/account_detail_page.dart';
import 'package:invested/util/custom_text_field.dart';
import 'package:invested/util/requests.dart';
import 'package:invested/util/to_previous_page.dart';
import 'package:invested/util/page_image.dart';
import 'package:invested/util/page_title.dart';
import 'package:page_transition/page_transition.dart';
import '../../util/alert.dart';
import '../../util/global_styling.dart' as global_styling;
import '../../util/global_info.dart' as global_info;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  double verticalMargin = 10;

  // /////////////////////////////////////////////////////////////////////////
  // Checks for Register Password Validation
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  String? get newPassErrorText {
    final text = newPasswordController.text;

    RegExp specialCharacter = RegExp('[^a-z0-9A-Z]');
    RegExp capitalCharacter = RegExp('[A-Z]');
    RegExp numberCharacter = RegExp('[0-9]');

    if(text.length < 8) {
      return 'New Password must contain at least 8 characters!';
    } else if (!specialCharacter.hasMatch(text)) {
      return 'New Password must contain a special character!';
    } else if (!capitalCharacter.hasMatch(text)) {
      return 'New Password must contain a capital character!';
    } else if (!numberCharacter.hasMatch(text)) {
      return 'New Password must contain a number!';
    }

    return null;
  }

  String? get confirmNewPassErrorText {
    final newPassText = newPasswordController.text;
    final confirmText = confirmNewPasswordController.text;

    if (confirmText != newPassText) {
      return 'Confirm Password does not match!';
    }

    return null;
  }

  // /////////////////////////////////////////////////////////
  // Checks for Email Validation
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

  // //////////////////////////////////////////////////////////
  // On Submit
  void onSubmit() async {
    if (newPassErrorText == null && confirmNewPassErrorText == null && emailErrorText == null && usernameController.text.isNotEmpty) {
      await Requests.makeGetRequest('${global_info.localhost_url}/invested_account/check_taken?email=${emailController.text}&username=${usernameController.text}')
      .then((value) async {
        var response = json.decode(value);
        if(response['results']['status-code'] == 400) {
          if(response['message'].toString().contains("Username")) {
            await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return Alert(
                    title: "Username Taken!",
                    message: "Please choose another username!",
                    buttonMessage: "Ok",
                    width: 50,
                  );
                }
            );
          } else if (response['message'].toString().contains("Email")) {
            await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return Alert(
                    title: "Email Taken!",
                    message: "Please use another email!",
                    buttonMessage: "Ok",
                    width: 50,
                  );
                }
            );
          }
        } else if(response['results']['status-code'] == 200) {
          Navigator.push(
              context,
              PageTransition(
                  child: AccountDetailsPage(
                    username: usernameController.text,
                    password: newPasswordController.text,
                    email: emailController.text,
                  ),
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
                  const PageTitle(title: 'Sign Up'),
                  CustomTextField(
                      textCallBack: (value) {},
                      hintText: "Enter Username...",
                      labelText: "Enter Username",
                      errorText: null,
                      verticalMargin: verticalMargin,
                      prefixIcon: Icons.account_circle_outlined,
                      textController: usernameController
                  ),
                  CustomTextField(
                      textCallBack: (value) {},
                      hintText: "Enter Email...",
                      labelText: "Enter Email",
                      errorText: emailErrorText,
                      verticalMargin: verticalMargin,
                      prefixIcon: Icons.email_outlined,
                      textController: emailController
                  ),
                  CustomTextField(
                      textCallBack: (value) {},
                      hintText: "Enter Password...",
                      labelText: "Enter Password",
                      errorText: newPassErrorText,
                      isObscure: true,
                      hasSuffixIcon: true,
                      suffixIcon: Icons.visibility_off_outlined,
                      pressedSuffixIcon: Icons.visibility_outlined,
                      verticalMargin: verticalMargin,
                      prefixIcon: Icons.lock_outline,
                      textController: newPasswordController
                  ),
                  CustomTextField(
                      textCallBack: (value) {},
                      hintText: "Confirm Password...",
                      labelText: "Confirm Password",
                      errorText: confirmNewPassErrorText,
                      isObscure: true,
                      hasSuffixIcon: true,
                      suffixIcon: Icons.visibility_off_outlined,
                      pressedSuffixIcon: Icons.visibility_outlined,
                      verticalMargin: verticalMargin,
                      prefixIcon: Icons.lock_outline,
                      textController: confirmNewPasswordController
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width - 30,
                          child: ElevatedButton(
                              onPressed: (usernameController.text.isNotEmpty && emailController.text.isNotEmpty
                              && newPasswordController.text.isNotEmpty && confirmNewPasswordController.text.isNotEmpty) ?
                              onSubmit :
                              () {},
                              style: ElevatedButton.styleFrom(
                                primary: Color(global_styling.LOGO_COLOR),
                              ),
                              child: Text(
                                "Submit",
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


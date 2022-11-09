import 'package:flutter/material.dart';
import 'package:invested/pages/login/page_image.dart';
import 'package:invested/pages/login/page_title.dart';
import 'package:invested/pages/login/verification_code_page.dart';
import 'package:invested/util/custom_text_field.dart';
import 'package:invested/util/to_previous_page.dart';
import 'package:page_transition/page_transition.dart';
import '../../util/global_styling.dart' as global_styling;

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();

  String? get emailErrorText {
    final text = emailController.text;

    RegExp emailCheck = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    // Simple checks to see if empty or doesn;t match regex
    if(text.isEmpty) {
      return 'Field is Empty!';
    } else if (!emailCheck.hasMatch(text)) {
      return 'Invalid Email!';
    }

    // Return null is string is valid
    return null;
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
                const PageTitle(title: "Forgot"),
                const PageTitle(title: "Password?"),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Text(
                      "Don't worry! We will send you a one time code! Please enter your email.",
                      style: TextStyle(
                          fontFamily: global_styling.TEXT_FONT,
                          fontSize: 15
                      ),
                    )
                ),
                CustomTextField(
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
                            onPressed: () {
                              // Make request to send get digit and send to next page
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: const VerificationCodePage(),
                                      type: PageTransitionType.rightToLeftWithFade
                                  )
                              );
                              // Need to update the Enter Email Box to Red and say is Required
                            },
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

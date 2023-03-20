import 'package:flutter/material.dart';
import 'package:invested/pages/forgot_password/verification_code/verification_code_page.dart';
import 'package:invested/pages/landing/landing_button.dart';
import 'package:invested/util/widget/page/page_image.dart';
import 'package:invested/util/widget/page/to_previous_page.dart';
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/widget/text/custom_text_field.dart';
import 'package:invested/util/widget/text/page_title.dart';
import 'package:page_transition/page_transition.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 5,
                  child: buildHeader()
              ),
              Expanded(
                  flex: 6,
                  child: buildForgotPasswordForm()
              )
            ],
          ),
        )
    );
  }

  Column buildHeader() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.05),
          child: const ToPrevPage(color: Color(global_style.blackAccentColor)),
        ),
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.06, left: MediaQuery.of(context).size.width * 0.03),
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Image.asset('./assets/images/updated-icon.png')
          ),
        )
      ],
    );
  }

  Column buildForgotPasswordForm() {
    return Column(
      children: [
        buildFormHeader(),
        buildMessage(),
        buildEmailTextField(),
        buildSendEmailButton()
      ],
    );
  }

  Container buildFormHeader() {
    return Container(
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
      child: Column(
          children: const [
            PageTitle(title: 'Forgot', bottomMargin: 0),
            PageTitle(title: 'Password?')
          ]
      )
    );
  }

  CustomText buildMessage() {
    return CustomText(
      leftMargin: MediaQuery.of(context).size.width * 0.05,
      rightMargin: MediaQuery.of(context).size.width * 0.05,
      topMargin: 10,
      bottomMargin: 10,
      text: "Don't worry! We will send you a one time code! Please enter your email.",
      fontSize: 15,
    );
  }

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
      Navigator.push(
          context,
          PageTransition(
              child: const VerificationCodePage(),
              type: PageTransitionType.rightToLeftWithFade));
    }
  }

  CustomTextField buildEmailTextField() {
    return CustomTextField(
      horizontalMargin: MediaQuery.of(context).size.width * 0.05,
      textCallBack: (value) {},
      hintText: 'Enter Email...',
      labelText: 'Enter Email',
      prefixIcon: Icons.email_outlined,
      textController: emailController,
      errorText: emailErrorText,
    );
  }

  Container buildSendEmailButton() {
    return Container(
        margin: const EdgeInsets.only(top: 15),
        child: LandingButton(onTap: (emailController.text.isNotEmpty)
            ? onSubmit : () {},
            text: 'Send Email', hasFillColor: true)
    );
  }
}

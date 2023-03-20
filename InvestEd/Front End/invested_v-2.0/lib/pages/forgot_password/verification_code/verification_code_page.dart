import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invested/pages/forgot_password/change_password/change_password_page.dart';
import 'package:invested/pages/landing/landing_button.dart';
import 'package:invested/util/widget/page/to_previous_page.dart';
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/widget/text/custom_text_field.dart';
import 'package:invested/util/widget/text/page_title.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:page_transition/page_transition.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({Key? key}) : super(key: key);

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {

  void onSubmit() {
    if (verificationCodeErrorText == null) {
      Navigator.push(
          context,
          PageTransition(
              child: const ChangePasswordPage(),
              type: PageTransitionType.rightToLeftWithFade
          )
      );
    }
  }

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
                    child: buildVerifyCodeForm()
                )
              ],
            )
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

  Column buildVerifyCodeForm() {
    return Column(
      children: [
        buildFormHeader(),
        buildMessage(),
        buildVerifyCodeTextField(),
        buildVerifyCodeButton()
      ],
    );
  }

  Container buildFormHeader() {
    return Container(
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
        child: Column(
            children: const [
              PageTitle(title: 'Enter Code')
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
      text: "We have sent an email with your verification code! Please check your email.",
      fontSize: 15,
    );
  }

  CustomTextField buildVerifyCodeTextField() {
    return CustomTextField(
        horizontalMargin: MediaQuery.of(context).size.width * 0.05,
        textCallBack: (value) {},
        hintText: 'Enter Verification Code...',
        labelText: 'Enter Verification Code',
        errorText: verificationCodeErrorText,
        textInputType: TextInputType.number,
        textFormatters: [FilteringTextInputFormatter.digitsOnly],
        prefixIcon: Icons.dialpad_outlined,
        textController: codeController
    );
  }

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

  Container buildVerifyCodeButton() {
    return Container(
        margin: const EdgeInsets.only(top: 15),
        child: LandingButton(onTap: (codeController.text.isNotEmpty)
            ? onSubmit : () {},
            text: 'Submit Code', hasFillColor: true)
    );
  }
}


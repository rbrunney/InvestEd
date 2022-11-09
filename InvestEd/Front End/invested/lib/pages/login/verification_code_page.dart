import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invested/pages/login/change_password_page.dart';
import 'package:invested/pages/login/page_image.dart';
import 'package:invested/pages/login/page_title.dart';
import 'package:invested/util/custom_text_field.dart';
import 'package:invested/util/to_previous_page.dart';
import 'package:page_transition/page_transition.dart';
import '../../util/global_styling.dart' as global_styling;

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({Key? key}) : super(key: key);

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
      // Send code off to get validated
      print('Yes');
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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const ToPrevPage(),
                  const PageImage(assetImg: 'assets/images/icon.png', marginTop: 7),
                  const PageTitle(title: "Enter Code"),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Text(
                        "We have sent an email with your verification code! Please check your email.",
                        style: TextStyle(
                            fontFamily: global_styling.TEXT_FONT,
                            fontSize: 15
                        ),
                      )
                  ),
                  CustomTextField(
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



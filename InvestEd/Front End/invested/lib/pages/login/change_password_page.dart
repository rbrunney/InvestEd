import 'package:flutter/material.dart';
import 'package:invested/pages/login/login_page.dart';
import 'package:invested/util/page_image.dart';
import 'package:invested/util/page_title.dart';
import 'package:invested/util/custom_text_field.dart';
import 'package:invested/util/to_previous_page.dart';
import '../../util/global_styling.dart' as global_styling;

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
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

  void onSubmit() {
    if (newPassErrorText == null && confirmNewPassErrorText == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const LoginPage()),
              (Route<dynamic> route) => false);
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
                  const PageTitle(title: 'Reset Password'),
                  CustomTextField(
                      labelText: 'Enter New Password',
                      hintText: 'Enter New Password...',
                      isObscure: true,
                      hasSuffixIcon: true,
                      suffixIcon: Icons.visibility_off_outlined,
                      pressedSuffixIcon: Icons.visibility_outlined,
                      errorText: newPassErrorText,
                      prefixIcon: Icons.lock_outline,
                      textController: newPasswordController
                  ),
                  CustomTextField(
                      labelText: 'Confirm New Password',
                      hintText: 'Confirm New Password...',
                      isObscure: true,
                      hasSuffixIcon: true,
                      suffixIcon: Icons.visibility_off_outlined,
                      pressedSuffixIcon: Icons.visibility_outlined,
                      errorText: confirmNewPassErrorText,
                      prefixIcon: Icons.lock_outline,
                      textController: confirmNewPasswordController
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width - 30,
                          child: ElevatedButton(
                              onPressed: newPasswordController.text.isNotEmpty && confirmNewPasswordController.text.isNotEmpty ?
                              onSubmit :
                              () {},
                              style: ElevatedButton.styleFrom(
                                primary: Color(global_styling.LOGO_COLOR),
                              ),
                              child: Text(
                                "Change Password",
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


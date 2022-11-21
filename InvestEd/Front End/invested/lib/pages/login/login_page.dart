import 'package:flutter/material.dart';
import 'package:invested/pages/login/forgot_password_page.dart';
import 'package:invested/pages/login/register_page.dart';
import 'package:invested/pages/navigation/bottom_tab_navigation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:invested/util/page_image.dart';
import 'package:invested/util/page_title.dart';
import 'package:invested/util/custom_text_field.dart';
import '../../util/global_styling.dart' as global_styling;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Login Page State
class _LoginPageState extends State<LoginPage> {
  // Making Controllers so we can get the text information later
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? get usernameErrorText {
    final text = _usernameController.text;

    if (text.isEmpty) {
      return 'Field is Empty!';
    }

    return null;
  }

  String? get passwordErrorText {
    final text = _passwordController.text;

    if (text.isEmpty) {
      return 'Field is Empty!';
    }

    return null;
  }

  void printInfo() {
    print(_usernameController.text);
    print(_passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: Column(
        children: [
          const PageImage(assetImg: 'assets/images/icon.png', marginTop: 55),
          const PageTitle(title: "Login"),
          CustomTextField(
            textCallBack: (value) {},
            hintText: "Enter Username...",
            labelText: "Enter Username",
            prefixIcon: Icons.account_circle_outlined,
            textController: _usernameController,
            errorText: usernameErrorText,
          ),
          CustomTextField(
            textCallBack: (value) {},
            hintText: "Enter Password...",
            labelText: "Enter Password",
            isObscure: true,
            hasSuffixIcon: true,
            prefixIcon: Icons.lock_outline,
            suffixIcon: Icons.visibility_off_outlined,
            pressedSuffixIcon: Icons.visibility_outlined,
            textController: _passwordController,
            errorText: passwordErrorText,
          ),
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const ForgotPasswordPage(title: "Forgot",),
                        type: PageTransitionType.rightToLeftWithFade));
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Text("Forgot Password?",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                          fontFamily: global_styling.TITLE_FONT)))),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: const PageNavigation(),
                                type: PageTransitionType.rightToLeftWithFade));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(global_styling.LOGO_COLOR),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(fontFamily: global_styling.TITLE_FONT),
                      )))),
          Container(
              margin: const EdgeInsets.only(top: 15),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      "New to InvestEd?",
                      style: TextStyle(
                        fontFamily: global_styling.TITLE_FONT,
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: const RegisterPage(),
                                type: PageTransitionType.rightToLeftWithFade));
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontFamily: global_styling.TITLE_FONT),
                      ))
                ],
              ))
        ],
      ),
    )));
  }
}

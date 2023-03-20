import 'package:flutter/material.dart';
import 'package:invested/main.dart';
import 'package:invested/pages/forgot_password/forgot_password_page.dart';
import 'package:invested/pages/landing/landing_button.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:invested/util/widget/page/to_previous_page.dart';
import 'package:invested/util/widget/text/custom_text_field.dart';
import 'package:invested/util/widget/text/page_title.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  void onSubmit() async {
    Navigator.push(
        context,
        PageTransition(
            child: const HomePage(),
            type: PageTransitionType.rightToLeftWithFade));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(global_style.whiteBackgroundColor),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 5,
                child: buildHeader()
            ),
            Expanded(
                flex: 6,
                child: buildLoginForm()
            )
          ],
        ),
      ),
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

  Column buildLoginForm() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
          child: const PageTitle(title: 'Login'),
        ),
        buildUsernameTextField(),
        buildPasswordTextField(),
        buildLoginButton(),
        buildForgotPasswordButton()
      ],
    );
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? get usernameErrorText {
    final text = usernameController.text;

    if (text.isEmpty) {
      return 'Field is Empty!';
    }

    return null;
  }

  CustomTextField buildUsernameTextField() {
    return CustomTextField(
      horizontalMargin: MediaQuery.of(context).size.width * 0.05,
      textCallBack: (value) {},
      hintText: "Enter Username...",
      labelText: "Enter Username",
      prefixIcon: Icons.account_circle_outlined,
      textController: usernameController,
      errorText: usernameErrorText,
    );
  }

  String? get passwordErrorText {
    final text = passwordController.text;

    if (text.isEmpty) {
      return 'Field is Empty!';
    }

    return null;
  }

  CustomTextField buildPasswordTextField() {
    return CustomTextField(
      horizontalMargin: MediaQuery.of(context).size.width * 0.05,
      textCallBack: (value) {},
      hintText: "Enter Password...",
      labelText: "Enter Password",
      isObscure: true,
      hasSuffixIcon: true,
      prefixIcon: Icons.lock_outline,
      suffixIcon: Icons.visibility_off_outlined,
      pressedSuffixIcon: Icons.visibility_outlined,
      textController: passwordController,
      errorText: passwordErrorText,
    );
  }

  Container buildLoginButton() {
    return Container(
        margin: const EdgeInsets.only(top: 15),
        child: LandingButton(onTap: (usernameController.text.isNotEmpty && passwordController.text.isNotEmpty)
            ? onSubmit : () {},
            text: 'Login', hasFillColor: true)
    );
  }

  Container buildForgotPasswordButton() {
    return Container(
        margin: const EdgeInsets.only(top: 5),
        child: LandingButton(onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  child: const ForgotPasswordPage(),
                  type: PageTransitionType.rightToLeftWithFade));
        },
            text: 'Forgot Password?', hasBorder: true)
    );
  }
}

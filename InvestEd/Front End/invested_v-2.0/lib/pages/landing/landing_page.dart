import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invested/controllers/login_controllers/google_login_controller.dart';
import 'package:invested/controllers/login_controllers/invested_login_controller.dart';
import 'package:invested/controllers/user_data_controllers/user_data_controller.dart';
import 'package:invested/main.dart';
import 'package:invested/pages/landing/landing_button.dart';
import 'package:invested/pages/login/login_page.dart';
import 'package:invested/pages/register/register_page.dart';
import 'package:invested/util/security/RSA.dart';
import 'package:invested/util/widget/page/alert.dart';
import 'package:invested/util/widget/text/page_title.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:page_transition/page_transition.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final googleController = Get.put(GoogleLoginController());
  final investedController = Get.put(InvestedLoginController());
  final userDataController = Get.put(UserDataController());

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(global_style.whiteBackgroundColor),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 3,
                  child: buildHeader()
              ),
              Expanded(
                  flex: 2,
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Column(
                          children: [
                            buildMessage(),
                            buildRegisterButton(),
                            buildGoogleSignInButton(),
                            buildLoginButton()
                          ],
                      )
                  )
              )
            ],
          )),
    );
  }

  Container buildHeader() {
    return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.13, left: MediaQuery.of(context).size.width * 0.05),
        child: Column(
            children : [
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.40,
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Image.asset('./assets/images/updated-icon.png')
                ),
              )
            ]
        ));
  }

  Column buildMessage() {
    return Column(
      children: const [
        PageTitle(
          title: 'Empowering Investors',
          alignment: Alignment.center,
          fontSize: 30,
          bottomMargin: 0,
        ),
        PageTitle(
          title: 'Made-Simple',
          alignment: Alignment.center,
          fontSize: 30,
        ),
      ],
    );
  }

  LandingButton buildRegisterButton() {
    return LandingButton(
      onTap: () {
        pushToNewPage(const RegisterPage(), PageTransitionType.fade);
      },
      text: 'Register',
      hasFillColor: true,
    );
  }

  LandingButton buildGoogleSignInButton() {
    return LandingButton(
      onTap: () async {
        await googleController.login();
        if (userDataController.email != null) {
          userDataController.showData();
          pushToNewPage(const HomePage(), PageTransitionType.fade);
        } else {
          if (context.mounted) {
            await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return const Alert(
                    title: "Google Login Failed!",
                    message: "Google login not available at this time!",
                    buttonMessage: "Ok",
                    width: 50,
                  );
                }
            );
          }
        }
      },
      hasBorder: true,
      text: 'Continue with Google',
      prefixImagePath: './assets/images/google_logo.png',
    );
  }

  LandingButton buildLoginButton() {
    return LandingButton(
      onTap: () async {
        pushToNewPage(const LoginPage(), PageTransitionType.fade);
      },
      hasBorder: true,
      text: 'Login'
    );
  }

  void pushToNewPage(Widget newPage, PageTransitionType transitionType) {
    Navigator.push(
        context,
        PageTransition(
          type: transitionType,
          child: newPage,
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invested/controllers/login_controllers/facebook_login_controller.dart';
import 'package:invested/controllers/login_controllers/google_login_controller.dart';
import 'package:invested/controllers/login_controllers/invested_login_controller.dart';
import 'package:invested/controllers/user_data_controllers/user_data_controller.dart';
import 'package:invested/main.dart';
import 'package:invested/pages/landing/landing_button.dart';
import 'package:invested/pages/login/login_page.dart';
import 'package:invested/pages/register/register_page.dart';
import 'package:invested/util/widget/page/alert.dart';
import 'package:invested/util/widget/text/custom_text.dart';
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
  final facebookController = Get.put(FacebookLoginController());
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
              Expanded(child: buildHeader()),
              Expanded(
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Column(
                        children: [
                          buildMessage(),
                          buildRegisterButton(),
                          buildGoogleSignInButton(),
                          buildFacebookSignInButton(),
                          buildLoginButton()
                        ],
                      )))
            ],
          )),
    );
  }

  Container buildHeader() {
    return Container(
        margin: const EdgeInsets.only(top: 60, left: 25),
        child: Column(
            children : [
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: SizedBox(
                    height: 275,
                    width: 275,
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
        if (userDataController.email != '') {
          userDataController.showData();
          pushToNewPage(const HomePage(), PageTransitionType.bottomToTop);
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
      text: 'Sign in with Google',
      prefixImagePath: './assets/images/google_logo.png',
    );
  }

  LandingButton buildFacebookSignInButton() {
    return LandingButton(
      onTap: () async {
        await facebookController.login();
        if(userDataController.email != '') {
          userDataController.showData();
          pushToNewPage(const HomePage(), PageTransitionType.bottomToTop);
        } else {
          if (context.mounted) {
            await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return const Alert(
                    title: "Facebook Login Failed!",
                    message: "Facebook login not available at this time!",
                    buttonMessage: "Ok",
                    width: 50,
                  );
                }
            );
          }
        }
      },
      hasBorder: true,
      text: 'Sign in with Facebook',
      prefixImagePath: './assets/images/facebook_logo.png',
    );
  }

  InkWell buildLoginButton() {
    return InkWell(
        onTap: () async {
          await investedController.login();
          print(investedController.userData);
          pushToNewPage(const LoginPage(), PageTransitionType.fade);
        },
        child: SizedBox(
            height: 45,
            width: MediaQuery.of(context).size.width * 0.90,
            child: CustomText(
              text: 'Login',
              alignment: Alignment.center,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )));
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

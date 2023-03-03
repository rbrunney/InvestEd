import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invested/controllers/facebook_login_controller.dart';
import 'package:invested/main.dart';
import 'package:invested/controllers/google_login_controller.dart';
import 'package:invested/pages/landing/landing_button.dart';
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/widget/text/page_title.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:page_transition/page_transition.dart';
import 'package:invested/util/data/global_data.dart' as global_data;

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final googleController = Get.put(GoogleLoginController());
  final facebookController = Get.put(FacebookLoginController());

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
        margin: const EdgeInsets.only(top: 40),
        child: const PageTitle(
          title: 'InvestEd',
          alignment: Alignment.center,
          fontSize: 20,
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

  InkWell buildLoginButton() {
    return InkWell(
        onTap: () {},
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

  LandingButton buildRegisterButton() {
    return LandingButton(
      onTap: () async {
        await googleController.logout();
        await facebookController.logout();
        global_data.currentLoginType = global_data.LoginType.none;
      },
      text: 'Register',
      hasFillColor: true,
    );
  }

  LandingButton buildGoogleSignInButton() {
    return LandingButton(
      onTap: () async {
        await googleController.login();

        // Update Globabl User Data
        global_data.userData["name"] =
            googleController.googleAccount.value!.displayName;
        global_data.userData["email"] =
            googleController.googleAccount.value!.email;
        global_data.userData["username"] =
            googleController.googleAccount.value!.displayName;
        global_data.userData["photoUrl"] =
            googleController.googleAccount.value!.photoUrl;

        print(global_data.userData);

        global_data.currentLoginType = global_data.LoginType.google;

        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: const HomePage(),
            ));
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

        // Update Globabl User Data
        global_data.userData["name"] = facebookController.userData!["name"];
        global_data.userData["email"] = facebookController.userData!["email"];
        global_data.userData["username"] = facebookController.userData!["name"];
        global_data.userData["photoUrl"] =
            facebookController.userData!["picture"]["data"]["url"];

        print(global_data.userData);

        global_data.currentLoginType = global_data.LoginType.facebook;

        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: const HomePage(),
            ));
      },
      hasBorder: true,
      text: 'Sign in with Facebook',
      prefixImagePath: './assets/images/facebook_logo.png',
    );
  }
}

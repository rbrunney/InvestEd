import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invested/main.dart';
import 'package:invested/pages/landing/login_controller.dart';
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
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(global_style.whiteBackgroundColor),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: const PageTitle(
                      title: 'InvestEd',
                      alignment: Alignment.center,
                      fontSize: 30,
                    )),
                buildRegisterButton(),
                Obx(() {
                  if (controller.googleAccount.value == null) {
                    return buildGoogleSignInButton();
                  } else {
                    return const Text('Logged In');
                  }
                })
              ],
            ),
          )),
    );
  }

  InkWell buildRegisterButton() {
    return InkWell(
        onTap: () {
          controller.logout();
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: const BoxDecoration(
              color: Color(global_style.greenPrimaryColor),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width * 0.90,
              child: CustomText(
                text: 'Register',
                color: const Color(global_style.whiteAccentColor),
                fontSize: 18,
                leftMargin: 10,
              )),
        ));
  }

  InkWell buildGoogleSignInButton() {
    return InkWell(
      onTap: () async {
        await controller.login();

        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: const HomePage(),
            ));
      },
      child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              border:
                  Border.all(color: const Color(global_style.greenAccentColor)),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: SizedBox(
            height: 45,
            width: MediaQuery.of(context).size.width * 0.90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('./assets/images/google_logo.png',
                    height: 32, width: 32),
                CustomText(
                  text: 'Sign in with Google',
                  color: const Color(global_style.blackAccentColor),
                  fontSize: 18,
                  leftMargin: 10,
                )
              ],
            ),
          )),
    );
  }
}

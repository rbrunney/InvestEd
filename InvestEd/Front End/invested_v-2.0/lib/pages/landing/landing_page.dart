import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/widget/text/page_title.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> handleSignIn() async {
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

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
                InkWell(
                  onTap: () {},
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Color(global_style.greenPrimaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: SizedBox(
                        height: 45,
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: CustomText(
                          text: 'Register',
                          color: const Color(global_style.whiteAccentColor),
                          fontSize: 16,
                        ),
                      )),
                ),
                InkWell(
                  onTap: () async {
                    handleSignIn();
                  },
                  child: const Text('Sign In'),
                )
              ],
            ),
          )),
    );
  }
}

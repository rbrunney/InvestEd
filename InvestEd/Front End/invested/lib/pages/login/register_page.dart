import 'package:flutter/material.dart';
import 'package:invested/util/custom_text_field.dart';
import 'package:invested/util/to_previous_page.dart';
import 'package:invested/pages/login/page_image.dart';
import 'package:invested/pages/login/page_title.dart';
import '../../util/global_styling.dart' as global_styling;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  double verticalMargin = 10;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const ToPrevPage(),
                  const PageImage(assetImg: 'assets/images/icon.png', marginTop: 7),
                  const PageTitle(title: 'Sign Up'),
                  CustomTextField(
                      hintText: "Enter Username...",
                      labelText: "Enter Username",
                      verticalMargin: verticalMargin,
                      prefixIcon: Icons.account_circle_outlined,
                      textController: usernameController
                  ),
                  CustomTextField(
                      hintText: "Enter Email...",
                      labelText: "Enter Email",
                      verticalMargin: verticalMargin,
                      prefixIcon: Icons.email_outlined,
                      textController: emailController
                  ),
                  CustomTextField(
                      hintText: "Enter Password...",
                      labelText: "Enter Password",
                      verticalMargin: verticalMargin,
                      prefixIcon: Icons.lock_outline,
                      textController: emailController
                  ),
                  CustomTextField(
                      hintText: "Confirm Password...",
                      labelText: "Confirm Password",
                      verticalMargin: verticalMargin,
                      prefixIcon: Icons.lock_outline,
                      textController: emailController
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width - 30,
                          child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                primary: Color(global_styling.LOGO_COLOR),
                              ),
                              child: Text(
                                "Submit",
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


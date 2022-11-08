import 'package:flutter/material.dart';
import 'package:invested/pages/login/page_image.dart';
import 'package:invested/pages/login/page_title.dart';
import 'package:invested/util/custom_text_field.dart';
import '../../util/global_styling.dart' as global_styling;


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key:key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Login Page State
class _LoginPageState extends State<LoginPage> {
  // Making Controllers so we can get the text information later
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void printInfo() {
    print(_usernameController.text);
    print(_passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
      Scaffold(
        body: Column(
          children: [
            const PageImage(assetImg: 'assets/images/icon.png', marginTop: 55),
            const PageTitle(title: "Login"),
            CustomTextField(
              hintText: "Enter Username...",
              labelText: "Enter Username",
              prefixIcon: Icons.account_circle_outlined,
              textController: _usernameController,
            ),
            CustomTextField(
              hintText: "Enter Password...",
              labelText: "Enter Password",
              isObscure: true,
              hasSuffixIcon: true,
              prefixIcon: Icons.lock_outline,
              suffixIcon: Icons.visibility_off_outlined,
              pressedSuffixIcon: Icons.visibility_outlined,
              textController: _passwordController,
            ),
            InkWell(
              onTap: () => {},
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    fontFamily: global_styling.TITLE_FONT
                  )
                )
              )
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
                        "Login",
                        style: TextStyle(
                            fontFamily: global_styling.TITLE_FONT
                        ),
                      )
                  )
              )
          ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child:Text(
                      "New to InvestEd?",
                      style: TextStyle(
                        fontFamily: global_styling.TITLE_FONT,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => {},
                    child: Text(
                        "Register",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                          fontFamily: global_styling.TITLE_FONT
                      ),
                    )
                  )
                ],
              )

            )
          ],
        ),
      )
    );
  }
}
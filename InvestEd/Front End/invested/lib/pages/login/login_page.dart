import 'package:flutter/material.dart';
import 'package:invested/util/custom_text_field.dart';

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
  final int LOGO_COLOR = 0xFF33cc66;

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
            Container(
              margin: const EdgeInsets.only(top: 55),
              child: const Image(image: AssetImage('assets/images/logo.png')), // Display Logo
            ),
            CustomTextField(
              hintText: "Enter Username...",
              labelText: "Enter Username",
              icon: Icons.account_circle_outlined,
              textController: _usernameController,
            ),
            CustomTextField(
              hintText: "Enter Password...",
              labelText: "Enter Password",
              icon: Icons.lock_outline,
              textController: _passwordController,
            ),
            ElevatedButton(
                onPressed: printInfo,
                style: ElevatedButton.styleFrom(
                  primary: Color(LOGO_COLOR)
                ),
                child: const Text("Login")
            )
          ],
        ),
      )
    );
  }
}
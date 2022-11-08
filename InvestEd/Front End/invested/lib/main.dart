import 'package:flutter/material.dart';
import 'package:invested/pages/login/forgot_password_page.dart';
import 'package:invested/pages/login/login_page.dart';

void main() {
  runApp(const InvestEd());
}

class InvestEd extends StatelessWidget {
  const InvestEd({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InvestEd',
      theme: ThemeData.dark(),
      home: const LoginPage(),
    );
  }
}

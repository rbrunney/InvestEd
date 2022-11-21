import 'package:flutter/material.dart';
import 'package:invested/pages/login/forgot_password_page.dart';
import 'package:invested/pages/login/login_page.dart';
import 'package:invested/util/global_styling.dart';

void main() {
  runApp(const InvestEd());
}

class InvestEd extends StatefulWidget {
  const InvestEd({Key? key}) : super(key: key);

  @override
  State<InvestEd> createState() => _InvestEdState();
}

class _InvestEdState extends State<InvestEd> {

  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InvestEd',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: currentTheme.currentTheme(),
      home: const LoginPage(),
    );
  }
}

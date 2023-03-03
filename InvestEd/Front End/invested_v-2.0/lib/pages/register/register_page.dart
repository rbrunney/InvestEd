import 'package:flutter/material.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:invested/util/widget/page/to_previous_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Scaffold(
      backgroundColor: const Color(global_style.whiteBackgroundColor),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            ToPrevPage(),
            Text('Register Page')
          ],
        ),
      ),
    ));
  }
}
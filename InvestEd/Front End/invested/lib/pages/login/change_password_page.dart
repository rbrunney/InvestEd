import 'package:flutter/material.dart';
import 'package:invested/util/to_previous_page.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: const [
              ToPrevPage()
            ],
          )
        )
    );
  }
}

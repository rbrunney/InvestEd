import 'package:flutter/material.dart';
import 'package:invested/util/to_previous_page.dart';

class VerificationCodePage extends StatelessWidget {
  const VerificationCodePage({Key? key}) : super(key: key);

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

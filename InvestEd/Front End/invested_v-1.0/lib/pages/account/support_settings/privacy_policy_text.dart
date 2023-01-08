import 'package:flutter/material.dart';

import '../../../util/custom_text.dart';

class PolicyText extends StatelessWidget {
  final String text;
  const PolicyText({
    Key? key,
    this.text = ''
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomText(
      topMargin: 10,
      bottomMargin: 10,
      leftMargin: 30,
      rightMargin: 30,
      text: text
    );
  }
}

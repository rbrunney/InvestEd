import 'package:flutter/material.dart';
import 'package:invested/util/widget/text/custom_text.dart';

class SubCategorySnippet extends StatelessWidget {
  final String snippet;
  const SubCategorySnippet({
    Key? key,
    this.snippet = ""
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: CustomText(
        text: "     $snippet",
      ),
    );
  }
}
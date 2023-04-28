import 'package:flutter/material.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;

class PageTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  final double topMargin;
  final double bottomMargin;
  final Alignment alignment;
  final Color color;
  const PageTitle({
    Key? key,
    this.title = '',
    this.fontSize = 40,
    this.topMargin = 0,
    this.bottomMargin = 15,
    this.alignment = Alignment.centerLeft,
    this.color = const Color(global_style.blackAccentColor),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: alignment,
        margin: EdgeInsets.only(top: topMargin, bottom: bottomMargin),
        child: Text(
          title,
          style: TextStyle(
              fontFamily: global_style.titleFont,
              fontSize: fontSize,
              color: color),
        ));
  }
}

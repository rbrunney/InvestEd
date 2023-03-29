import 'package:flutter/material.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;

class ToPrevPageCircle extends StatelessWidget {
  final Color color;
  const ToPrevPageCircle({Key? key, this.color = const Color(global_style.whiteAccentColor)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.04, top: MediaQuery.of(context).size.height * 0.025),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: const CircleAvatar(
          radius: 15,
          backgroundColor: Color(global_style.whiteAccentColor),
          child: Icon(Icons.close)
        )
      )
    );
  }
}
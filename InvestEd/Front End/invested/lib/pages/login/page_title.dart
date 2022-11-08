import 'package:flutter/material.dart';
import '../../util/global_styling.dart' as global_styling;

class PageTitle extends StatelessWidget {
  final String title;
  const PageTitle({
    Key? key,
    this.title = ''
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(left: 15, bottom: 15),
        child: Text(
          title,
          style: TextStyle(
              fontFamily: global_styling.TITLE_FONT,
              fontSize: 40
          ),
        )
    );
  }
}

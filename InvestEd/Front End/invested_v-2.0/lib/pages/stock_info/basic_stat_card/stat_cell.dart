import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/widget/text/page_title.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;

class StatCell extends StatelessWidget {
  final String stat;
  final String statTitle;
  final String statPrefix;
  final String statSuffix;
  const StatCell(
      {super.key,
      this.stat = '',
      this.statTitle = '',
      this.statPrefix = '',
      this.statSuffix = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(top:15),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 5),
                  child: PageTitle(
                    title: statTitle,
                    fontSize: 20,
                    bottomMargin: 0,
                    color: const Color(global_style.greenAccentColor),
                  ),
                ),
                const Icon(MaterialCommunityIcons.information_outline, size: 20, color: Color(global_style.greenAccentColor),)
              ],
            )
        )),
      ],
    );
  }
}

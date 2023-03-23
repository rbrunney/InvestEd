import 'package:flutter/material.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;

class LessonHeader extends StatefulWidget {
  final String headerText;
  const LessonHeader({
    super.key,
    this.headerText = ''
  });

  @override
  State<LessonHeader> createState() => _LessonHeaderState();
}

class _LessonHeaderState extends State<LessonHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.05,
          horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: SizedBox(
              height: 50,
              width: 50,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_rounded),
              ),
            ),
          ),
          const Spacer(),
          Text(
            widget.headerText,
            style: TextStyle(
                fontSize: 18,
                fontFamily: global_style.textFont,
                fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          SizedBox(
            height: 50,
            width: 50,
            child: Card(
              color: const Color(global_style.greenPrimaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.checklist_rounded,
                color: Color(global_style.whiteAccentColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
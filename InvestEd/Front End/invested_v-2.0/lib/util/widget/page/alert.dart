import 'package:flutter/material.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;

class Alert extends StatelessWidget {
  final String title;
  final String message;
  final String buttonMessage;
  final double height;
  final double width;
  final bool popExtra;
  const Alert({
    Key? key,
    this.title = '',
    this.message = '',
    this.buttonMessage = '',
    this.height = 0,
    this.width = 0,
    this.popExtra = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: width,
        child: AlertDialog(
          title: Text(title, style: TextStyle(fontFamily: global_style.textFont)),
          content: Text(message, style: TextStyle(fontFamily: global_style.textFont)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if(popExtra) {
                  Navigator.pop(context);
                }
              },
              child: Text(buttonMessage, style: TextStyle(fontFamily: global_style.textFont)),
            ),
          ],
        )
    );
  }
}
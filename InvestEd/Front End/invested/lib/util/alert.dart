import 'package:flutter/material.dart';
import 'package:invested/util/global_styling.dart' as global_styling;

class Alert extends StatelessWidget {
  String title;
  String message;
  String buttonMessage;
  double height;
  double width;
  Alert({
    Key? key,
    this.title = '',
    this.message = '',
    this.buttonMessage = '',
    this.height = 0,
    this.width = 0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: width,
        child: AlertDialog(
          title: Text(title, style: TextStyle(fontFamily: global_styling.TITLE_FONT)),
          content: Text(message, style: TextStyle(fontFamily: global_styling.TEXT_FONT)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(buttonMessage, style: TextStyle(fontFamily: global_styling.TEXT_FONT)),
            ),
          ],
        )
    );
  }
}

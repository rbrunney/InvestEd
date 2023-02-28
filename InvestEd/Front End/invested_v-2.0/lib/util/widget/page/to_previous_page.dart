import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;

class ToPrevPage extends StatelessWidget {
  const ToPrevPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: const Icon(Ionicons.chevron_back_outline),
        iconSize: 35,
        color: const Color(global_style.whiteAccentColor),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
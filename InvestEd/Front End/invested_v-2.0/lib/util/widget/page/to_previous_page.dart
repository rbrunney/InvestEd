import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;

class ToPrevPage extends StatelessWidget {
  final Color color;
  const ToPrevPage({Key? key, this.color = const Color(global_style.whiteAccentColor)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: const Icon(Ionicons.chevron_back_outline),
        iconSize: 35,
        color: color,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
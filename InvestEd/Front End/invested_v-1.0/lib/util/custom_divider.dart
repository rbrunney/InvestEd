import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double thickness;
  const CustomDivider({
    Key? key,
    this.thickness = 1.5
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Divider(
          thickness: thickness,
          color: Colors.grey,
        )
    );
  }
}

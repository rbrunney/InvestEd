import 'package:flutter/material.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:invested/util/widget/text/custom_text.dart';

class LandingButton extends StatelessWidget {
  final String text;
  final String prefixImagePath;
  final bool hasBorder;
  final bool hasFillColor;
  final Color color;
  final VoidCallback onTap;
  const LandingButton(
      {super.key,
      this.text = '',
      this.prefixImagePath = '',
      this.hasBorder = false,
      this.hasFillColor = false,
      this.color = const Color(global_style.greenPrimaryColor),
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: hasFillColor ? color : const Color(global_style.whiteBackgroundColor),
              border: hasBorder ? Border.all(color: const Color(global_style.greenAccentColor)) : null,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: SizedBox(
            height: 45,
            width: MediaQuery.of(context).size.width * 0.90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                prefixImagePath != ''
                    ? Image.asset(prefixImagePath, height: 32, width: 32)
                    : const Text(''),
                CustomText(
                  text: text,
                  color: hasFillColor ? const Color(global_style.whiteAccentColor) : const Color(global_style.blackAccentColor),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  leftMargin: prefixImagePath != '' ? 10 : 0,
                )
              ],
            ),
          )),
    );
  }
}

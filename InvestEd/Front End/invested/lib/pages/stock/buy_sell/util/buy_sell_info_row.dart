import 'package:flutter/material.dart';
import 'package:invested/util/custom_divider.dart';
import 'package:invested/util/custom_text.dart';

class BuySellInfoRow extends StatefulWidget {
  final String infoPrefixText;
  final String infoSuffixText;
  final bool hasTextField;
  const BuySellInfoRow({
    Key? key,
    this.infoPrefixText = '',
    this.infoSuffixText = '',
    this.hasTextField = false
  }) : super(key: key);

  @override
  State<BuySellInfoRow> createState() => _BuySellInfoRowState();
}

class _BuySellInfoRowState extends State<BuySellInfoRow> {

  double textSize = 15;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Container(
        child: Row(
          children: [
            CustomText(
              fontSize: textSize,
                text: widget.infoPrefixText
            ),
            const Spacer(),
            widget.hasTextField ?
            TextFormField() : CustomText(
              fontSize: textSize,
              text: widget.infoSuffixText,
            ),
          ],
        )
      )
    );
  }
}

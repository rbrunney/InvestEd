import 'package:flutter/material.dart';
import 'package:invested/util/widget/text/custom_text.dart';

class BuySellInfoRow extends StatefulWidget {
  final String infoPrefixText;
  String infoSuffixText;
  BuySellInfoRow({
    Key? key,
    this.infoPrefixText = '',
    this.infoSuffixText = ''
  }) : super(key: key);

  @override
  State<BuySellInfoRow> createState() => _BuySellInfoRowState();
}

class _BuySellInfoRowState extends State<BuySellInfoRow> {

  double textSize = 15;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: 30),
        child: Container(
            child: Row(
              children: [
                CustomText(
                    fontSize: textSize,
                    text: widget.infoPrefixText
                ),
                const Spacer(),
                CustomText(
                  fontSize: textSize,
                  text: widget.infoSuffixText,
                ),
              ],
            )
        )
    );
  }
}
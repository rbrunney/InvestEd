import 'package:flutter/material.dart';

import '../../util/custom_divider.dart';
import '../../util/custom_text.dart';

class StatRow extends StatelessWidget {
  final String rowName;
  final String rowData;

  const StatRow({Key? key, this.rowName = '', this.rowData = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomText(
                      text: rowName,
                    ),
                    const Spacer(),
                    CustomText(text: rowData)
                  ],
                ),
              ],
            )
        ),
        const CustomDivider()
      ],
    );
  }
}

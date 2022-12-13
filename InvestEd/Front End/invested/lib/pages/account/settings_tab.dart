import 'package:flutter/material.dart';

import '../../util/custom_text.dart';

class SettingsTab extends StatelessWidget {
  final IconData iconData;
  final String name;
  final VoidCallback onTap;
  const SettingsTab({
    Key? key,
    this.iconData = Icons.abc_outlined,
    this.name = '',
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(iconData),
            CustomText(
              leftMargin: 20,
              text: name,
              fontSize: 18,
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_outlined)
          ],
        )
      )
    );
  }
}


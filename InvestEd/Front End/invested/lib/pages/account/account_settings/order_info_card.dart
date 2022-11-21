import 'package:flutter/material.dart';

class OrderCardInfo extends StatelessWidget {
  const OrderCardInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Card(
        child: Row(
          children: const [
            Text("Text")
          ],
        ),
      ),
    );
  }
}

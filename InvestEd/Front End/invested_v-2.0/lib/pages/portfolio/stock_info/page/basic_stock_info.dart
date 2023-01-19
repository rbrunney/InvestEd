import 'package:flutter/material.dart';
import 'package:invested/util/global_styling.dart' as global_style;
import 'package:invested/util/page/to_previous_page.dart';

class BasicStockInfoPage extends StatefulWidget {
  const BasicStockInfoPage({Key? key}) : super(key: key);

  @override
  State<BasicStockInfoPage> createState() => _BasicStockInfoPageState();
}

class _BasicStockInfoPageState extends State<BasicStockInfoPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.35, // Multiply to get 30%
                      color: const Color(global_style.greenPrimaryColor)
                  )
                ],
              ),
              SingleChildScrollView(
                child: Column(
                  children: const [
                    ToPrevPage()
                  ]
                )
              )
            ]
          ),
        )
    );
  }
}

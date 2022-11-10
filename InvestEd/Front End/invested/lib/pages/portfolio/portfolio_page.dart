import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/pages/login/page_title.dart';
import 'package:invested/pages/portfolio/portfolio_graph.dart';
import 'package:invested/pages/portfolio/portoflio_gain.dart';
import 'package:invested/util/custom_text.dart';
import '../../util/global_styling.dart' as global_styling;

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child : Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 25, left: 15),
                  child: const PageTitle(title: "Investing"),
                ),
                CustomText(
                  leftMargin: 30,
                  alignment: Alignment.centerLeft,
                  text: '\$5,000.00',
                  fontSize: 30,
                ),
                DisplayPortfolioGain(),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: const PortfolioGraph()
                ),
                CustomText(
                  text: 'Buying Power: \$5,000.00',
                  topMargin: 10,
                  leftMargin: 30,
                  alignment: Alignment.centerLeft,
                  fontSize: 18,
                )
              ],
            )
          )
        )
    );
  }
}

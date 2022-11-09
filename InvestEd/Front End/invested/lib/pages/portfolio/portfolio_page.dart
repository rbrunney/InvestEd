import 'package:flutter/material.dart';
import 'package:invested/pages/login/page_title.dart';
import 'package:invested/pages/portfolio/portfolio_graph.dart';
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
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "\$5,000.00",
                      style: TextStyle(
                          fontFamily: global_styling.TEXT_FONT,
                          fontSize: 30
                      ),
                    )
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: const PortfolioGraph()
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 30),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Buying Power: \$5,000.00",
                    style: TextStyle(
                      fontFamily: global_styling.TEXT_FONT,
                      fontSize: 18
                    ),
                  )
                )
              ],
            )
          )
        )
    );
  }
}

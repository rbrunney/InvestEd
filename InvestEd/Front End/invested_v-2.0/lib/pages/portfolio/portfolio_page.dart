import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/pages/portfolio/period_view/period_choice.dart';
import 'package:invested/pages/portfolio/stock_info/stock_card.dart';
import 'package:invested/util/global_styling.dart' as global_style;
import 'package:invested/util/line_graph.dart';

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
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05
                      ),
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: Text(
                        "Investing",
                        style: TextStyle(
                            fontFamily: global_style.titleFont,
                            fontSize: 45,
                            color: const Color(global_style.whiteAccentColor)
                        ),
                      )
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: Text(
                        "\$4,500.75",
                        style: TextStyle(
                            fontFamily: global_style.textFont,
                            fontSize: 35,
                            color: const Color(global_style.whiteAccentColor)
                        ),
                      )
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 5, bottom: 10),
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.40,
                        child: Card(
                          color: const Color(global_style.greenAccentColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "\$258.79 (^5.75%)",
                              style: TextStyle(
                                  fontFamily: global_style.titleFont,
                                  fontSize: 17,
                                  color: const Color(global_style.greenAccentTextColor)
                              ),
                            )
                          )
                        ),
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(top: 35, left: 25, right: 25),
                                  child: LineGraph(
                                    width: MediaQuery.of(context).size.width,
                                    maxY: 5,
                                    maxX: 6,
                                    graphLineData: const [
                                      FlSpot(0, 5),
                                      FlSpot(1, 3),
                                      FlSpot(2, 5),
                                      FlSpot(3, 2),
                                      FlSpot(4, 3),
                                      FlSpot(5, 5),
                                      FlSpot(6, 2)
                                    ],
                                    previousCloseData: const [
                                      FlSpot(0, 3),
                                      FlSpot(6, 3)
                                    ],
                                  )
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 25, right: 25),
                                child: PeriodChoice(),
                              )
                            ],
                          )
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.06),
                      child: Text(
                        "Stocks",
                        style: TextStyle(
                            fontFamily: global_style.titleFont,
                            fontSize: 30,
                            color: const Color(global_style.blackAccentColor)
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: StockInfoCard(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width,
                        logo: "https://api.polygon.io/v1/reference/company-branding/d3d3LmFtYXpvbi5jb20/images/2023-01-01_icon.jpeg?apiKey=pWnmnyskgOhWmfE226LWf4BH4vDY1i73",
                      )
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 15),
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                        child: StockInfoCard(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width,
                          logo: "https://api.polygon.io/v1/reference/company-branding/d3d3Lm1pY3Jvc29mdC5jb20/images/2023-01-01_icon.jpeg?apiKey=pWnmnyskgOhWmfE226LWf4BH4vDY1i73",
                        )
                    )
                  ],
                ),
              )
            ],
          )
      )
    );
  }
}

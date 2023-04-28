import 'package:flutter/material.dart';
import 'package:invested/pages/stock_info/basic_stat_card/stat_cell.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;

class BasicStockStatCard extends StatefulWidget {
  const BasicStockStatCard({super.key});

  @override
  State<BasicStockStatCard> createState() => _BasicStockStatCardState();
}

class _BasicStockStatCardState extends State<BasicStockStatCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top:  MediaQuery.of(context).size.height * 0.05),
        child: SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width * 0.90,
            child: Card(
              shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                color: const Color(global_style.whiteAccentColor),
                child: Center(
                  child: GridView(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisExtent: 75,
                    ),
                    children: const [
                      StatCell(statTitle: 'Open'),
                      StatCell(statTitle: 'High'),
                      StatCell(statTitle: 'Low'),
                      StatCell(statTitle: 'Volume'),
                      StatCell(statTitle: 'Market Cap'),
                      StatCell(statTitle: 'Dividend'),
                    ],
                  ),
                )
              )
            ));
  }
}

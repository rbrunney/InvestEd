import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:invested/util/page_title.dart';
import 'package:invested/util/to_previous_page.dart';
import 'package:invested/util/global_styling.dart' as global_styling;

import '../../util/line_graph.dart';

class BasicStockInfo extends StatefulWidget {
  final String ticker;
  const BasicStockInfo({
    Key? key,
    this.ticker = ''
  }) : super(key: key);

  @override
  State<BasicStockInfo> createState() => _BasicStockInfoState();
}

class _BasicStockInfoState extends State<BasicStockInfo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const ToPrevPage(),
            Container(
              margin: const EdgeInsets.only(left: 15),
              child: PageTitle(title: widget.ticker),
            ),
          ],
        )
      )
    );
  }
}

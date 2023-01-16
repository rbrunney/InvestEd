import 'package:flutter/material.dart';
import 'package:invested/util/global_styling.dart' as global_style;

class StockInfoCard extends StatefulWidget {
  final double height;
  final double width;
  const StockInfoCard({
    Key? key,
    this.height = 0,
    this.width = 0
  }) : super(key: key);

  @override
  State<StockInfoCard> createState() => _StockInfoCardState();
}

class _StockInfoCardState extends State<StockInfoCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  'https://api.polygon.io/v1/reference/company-branding/d3d3LmFtYXpvbi5jb20/images/2023-01-01_icon.jpeg?apiKey=pWnmnyskgOhWmfE226LWf4BH4vDY1i73',
                  height: 65,
                  width: 65,
                ),
              )
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, top: 25, bottom: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "AMZN",
                    style: TextStyle(
                        fontFamily: global_style.titleFont,
                        fontSize: 25,
                        color: const Color(global_style.blackAccentColor)
                    ),
                  ),
                  const Spacer(),
                  Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: Color(global_style.greenAccentColor),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_upward,
                            color: Colors.black,
                            size: 17,
                          ),
                          Text(
                            "\$875.65",
                            style: TextStyle(
                                fontFamily: global_style.titleFont,
                                fontSize: 17,
                                color: const Color(global_style.greenAccentTextColor)
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              )
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 30, top: 30, bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "1283.75",
                    style: TextStyle(
                        fontFamily: global_style.titleFont,
                        fontSize: 20,
                        color: const Color(global_style.greenAccentTextColor)
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Shares",
                    style: TextStyle(
                        fontFamily: global_style.titleFont,
                        fontSize: 20,
                        color: const Color(global_style.greenAccentTextColor)
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}

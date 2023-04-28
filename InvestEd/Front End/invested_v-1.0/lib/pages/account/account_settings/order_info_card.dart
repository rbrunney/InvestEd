import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/pages/stock/buy_sell/order_complete/order_complete_page.dart';
import 'package:invested/util/custom_text.dart';
import 'package:page_transition/page_transition.dart';

class OrderCardInfo extends StatelessWidget {
  final String orderId;
  final String ticker;
  final String tradeType;
  final String orderType;
  const OrderCardInfo({
    Key? key,
    this.orderId = '',
    this.ticker = '',
    this.tradeType = '',
    this.orderType = ''
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  child: OrderCompletePage(
                    ticker: ticker,
                    tradeType: tradeType,
                    orderType: orderType,
                    orderId: "123b-345b-567b",
                    totalShares: 33.45,
                    currentPrice: 235.75,
                    finalPrice: 74,
                  ),
                  type: PageTransitionType.fade));
        },
        child: Card(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        color: Colors.grey,
                        text: "Order Id: $orderId",
                        fontSize: 13,
                      ),
                      Row(
                        children: [
                          CustomText(
                            fontSize: 20,
                            alignment: Alignment.centerLeft,
                            text: ticker,
                          ),
                          CustomText(
                            fontSize: 20,
                            text: " - $tradeType",
                          )
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        print('Cancel');
                      },
                      icon: const Icon(MaterialCommunityIcons.close_box_outline, color: Colors.red)
                  )
                ],
              ),
            )
        ),
      )
    );
  }
}

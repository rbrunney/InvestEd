import 'package:flutter/material.dart';
import 'package:invested/pages/account/account_settings/order_info_card.dart';
import 'package:invested/util/to_previous_page.dart';

import '../../../util/page_title.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const ToPrevPage(),
              const PageTitle(
                  alignment: Alignment.center,
                  title: "Order History"
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: const PageTitle(
                  alignment: Alignment.center,
                  fontSize: 20,
                  title: "Current Orders",
                ),
              ),
              Column(
                children: const [
                  OrderCardInfo(
                    orderId: "123b-345b-567m",
                    ticker: "MSFT",
                    tradeType: "BUY",
                    orderType: "Market Order",
                  )
                ],
              ),
              Column(
                children: const [

                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: const PageTitle(
                  alignment: Alignment.center,
                  fontSize: 20,
                  title: "Past Orders",
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}

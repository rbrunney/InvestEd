import 'package:flutter/material.dart';

import '../../util/global_styling.dart' as global_styling;
import '../../util/custom_divider.dart';
import '../../util/custom_text.dart';

class BottomTradeBar extends StatelessWidget {
  const BottomTradeBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: MediaQuery.of(context).size.width,
      child: Container(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              const CustomDivider(thickness: 0.5),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 50),
                        decoration: BoxDecoration(
                            color: Color(global_styling.LOGO_COLOR),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: InkWell(
                            onTap: () {},
                            child: CustomText(
                              text: "Sell",
                              color: Color(global_styling.GREY_LOGO_COLOR),
                            )
                        )
                    ),
                    const Spacer(),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 50),
                        decoration: BoxDecoration(
                            color: Color(global_styling.LOGO_COLOR),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: InkWell(
                            onTap: () {},
                            child: CustomText(
                              text: "Buy",
                              color: Color(global_styling.GREY_LOGO_COLOR),
                            )
                        )
                    ),
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
}

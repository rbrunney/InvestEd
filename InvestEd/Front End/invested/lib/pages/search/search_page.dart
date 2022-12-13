import 'package:flutter/material.dart';
import 'package:invested/pages/search/news_article_card.dart';
import 'package:invested/pages/stock/basic_stock_info.dart';
import 'package:invested/util/page_title.dart';
import 'package:invested/util/requests.dart';
import 'package:invested/util/global_info.dart' as global_info;
import 'package:page_transition/page_transition.dart';

import '../../util/alert.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                          onPressed: () async {
                            Requests.makeGetRequest('${global_info.localhost_url}/invested_stock/${searchController.text.toUpperCase()}/price')
                            .then((value) async {
                              if(value.toString().contains("current_price")) {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: BasicStockInfo(ticker: searchController.text.toUpperCase(), isPortfolioStock: false,),
                                        type: PageTransitionType.rightToLeftWithFade));
                              } else {
                                await showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Alert(
                                        title: "Invalid Ticker!",
                                        message: "Please try another!",
                                        buttonMessage: "Ok",
                                        width: 50,
                                      );
                                    }
                                );
                              }
                            });
                          },
                          icon: const Icon(Icons.search, color: Colors.grey)
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)
                      ),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)
                      ),
                      hintText: "Search...",
                      labelText: "Search",
                        labelStyle: const TextStyle(color: Colors.grey)
                    )
                  ),
                ),
                const PageTitle(
                  alignment: Alignment.center,
                    title: "Current News",
                  fontSize: 30,
                ),
                const NewsArticleCard(
                  thumbnailURL: "https://i-invdn-com.investing.com/redesign/images/seo/investingcom_analysis_og.jpg",
                )
              ],
            ),
          ),
        )
    );
  }
}

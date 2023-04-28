import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:invested/controllers/url_controller/url_controller.dart';
import 'package:invested/pages/stock_info/basic_stock_info_page.dart';
import 'package:invested/util/requests/basic_request.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:invested/util/widget/data/news/news_article.dart';
import 'package:invested/util/widget/data/stock_card.dart';
import 'package:invested/util/widget/page/alert.dart';
import 'package:invested/util/widget/page/to_previous_page.dart';
import 'package:invested/util/widget/text/custom_text_field.dart';
import 'package:invested/util/widget/text/page_title.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final urlController = Get.put(URLController());
  Future<List<Widget>>? currentNews;
  List<Widget> newsCards = [];

  Future<List<Widget>> getCurrentNews() async {

    List<String> stocksToPullFrom = ['MSFT', 'AMZN', 'XOM', 'AAPL'];
    stocksToPullFrom.shuffle();

    await BasicRequest.makeGetRequest("${urlController.localBaseURL}/invested_stock/${stocksToPullFrom.elementAt(0)}/news")
    .then((value) {
      var response = json.decode(value);
      var newsArticles = response['results']['recent_news'];

      for(var newsArticle in newsArticles) {
        setState(() {
          newsCards.add(
            NewsArticleCard(
              title: newsArticle['title'],
              thumbnailURL: newsArticle['thumbnail_link'],
              authors: [newsArticle['authors']],
              publishDate: newsArticle['publish_date'],
              summary: newsArticle['summary'],
              websiteUrl: newsArticle['story_link']
            )
          );
        });
      }
    });

    return newsCards;
  }

  Future<List<Widget>>? trendingStocks;
  List<Widget> trendingStockCards = [];

  Future<List<Widget>> getTrendingStocks() async {
    await BasicRequest.makeGetRequest("${urlController.localBaseURL}/invested_stock/trending")
    .then((value) {
      var response = json.decode(value);

      for(int i=0; i<response['results'].length; i++) {
        setState(() {
          trendingStockCards.add(
              i != response['results'].length - 1 ? Container(
                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                child: StockCard(ticker: response['results'].elementAt(i), totalGain: 0)
              ) : Container(
                  margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: StockCard(ticker: response['results'].elementAt(i), totalGain: 0)
              )
          );
        });
      }
    });

    return trendingStockCards;
  }

  @override
  void initState() {
    super.initState();
    currentNews = getCurrentNews();
    trendingStocks = getTrendingStocks();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              buildTopGreenPatch(),
              buildHeader(),
          ]
        )
      )
    );
  }

  Column buildTopGreenPatch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.46,
            color: const Color(global_style.greenPrimaryColor))
      ],
    );
  }

  Container buildHeader() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: Column(
        children: [
          const ToPrevPage(),
          buildSearchBar(),
          buildTrending(),
          FutureBuilder<List<Widget>>(
              future: trendingStocks,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return buildTrendingStocks(trendingStockCards);
                }

                return Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        color: Color(global_style.greenPrimaryColor),
                      ),
                    ));
              }
          ),
          buildCurrentNews(),
          FutureBuilder<List<Widget>>(
            future: currentNews,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return buildNewsArticles(newsCards);
              }

              return Center(
                  child: Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: Color(global_style.greenPrimaryColor),
                    ),
                  ));
            }
          )
        ],
      )
    );
  }

  Container buildSearchBar() {
    TextEditingController searchController = TextEditingController();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.055,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Card(
          color: const Color(global_style.whiteBackgroundColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                onPressed: () async {
                  await BasicRequest.makeGetRequest("${urlController.localBaseURL}/invested_stock/${searchController.text}/price")
                      .then((value) async {
                        try {
                          Navigator.push(
                              context,
                              MaterialPageRoute (
                                builder: (BuildContext context) => BasicStockInfoPage(ticker: searchController.text),
                              ));
                        } catch(exception) {
                          await showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return const Alert(
                                  title: "Invalid Ticker",
                                  message: "Please try again!",
                                  buttonMessage: "Ok",
                                  width: 50,
                                );
                              }
                          );
                        }
                  });
                },
                icon: const Icon(Icons.search),
              ),
              hintText: 'Search',
            ),
          )
        )
      )
    );
  }

  Container buildTrending() {
    return Container(
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.height * 0.005),
      child: const PageTitle(
          title: "Trending",
          fontSize: 35,
          color: Color(global_style.whiteAccentColor)
      )
    );
  }

  SizedBox buildTrendingStocks(List<Widget> trendingStocks) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.23,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: trendingStocks,
        )
    );
  }

  Container buildCurrentNews() {
    return Container(
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.height * 0.04),
      child: const PageTitle(
        title: 'Current News',
        fontSize: 35
      )
    );
  }

  SizedBox buildNewsArticles(List<Widget> newsArticles) {

    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.415,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: newsArticles,
          ),
        )
    );
  }
}

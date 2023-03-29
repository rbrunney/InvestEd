import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:invested/controllers/url_controller/url_controller.dart';
import 'package:invested/util/requests/basic_request.dart';
import 'package:invested/util/style/global_styling.dart' as global_style;
import 'package:invested/util/widget/data/news/news_article.dart';
import 'package:invested/util/widget/data/stock_card.dart';
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

  @override
  void initState() {
    super.initState();
    currentNews = getCurrentNews();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              buildTopGreenPatch(),
              buildHeader(),
              const SingleChildScrollView(
              )
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
          buildTrendingStocks(),
          buildCurrentNews(),
          FutureBuilder<List<Widget>>(
            future: currentNews,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return buildNewsArticles(newsCards);
              }

              return Center(
                  heightFactor: 20,
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
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.95,
        child: Card(
          color: const Color(global_style.whiteBackgroundColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: CustomTextField(
            verticalMargin: 0,
            prefixIcon: Icons.search,
            labelText: 'Search',
            textCallBack: (String value) {  },
            textController: searchController,
          )
        )
      )
    );
  }

  Container buildTrending() {
    return Container(
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.height * 0.01),
      child: const PageTitle(
          title: "Trending",
          fontSize: 35,
          color: Color(global_style.whiteAccentColor)
      )
    );
  }

  SizedBox buildTrendingStocks() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.23,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Container(
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
              child: const StockCard(
                  // tickerLogo: 'https://api.polygon.io/v1/reference/company-branding/d3d3LmFtYXpvbi5jb20/images/2023-01-01_icon.jpeg?apiKey=pWnmnyskgOhWmfE226LWf4BH4vDY1i73',
                  ticker: 'AMZN',
                  totalGain: 35
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
              child: const StockCard(
                  // tickerLogo: 'https://api.polygon.io/v1/reference/company-branding/d3d3LmFtYXpvbi5jb20/images/2023-01-01_icon.jpeg?apiKey=pWnmnyskgOhWmfE226LWf4BH4vDY1i73',
                  ticker: 'AMZN',
                  totalGain: 35
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
              child: const StockCard(
                  // tickerLogo: 'https://api.polygon.io/v1/reference/company-branding/d3d3LmFtYXpvbi5jb20/images/2023-01-01_icon.jpeg?apiKey=pWnmnyskgOhWmfE226LWf4BH4vDY1i73',
                  ticker: 'AMZN',
                  totalGain: 35
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: const StockCard(
                  // tickerLogo: 'https://api.polygon.io/v1/reference/company-branding/d3d3LmFtYXpvbi5jb20/images/2023-01-01_icon.jpeg?apiKey=pWnmnyskgOhWmfE226LWf4BH4vDY1i73',
                  ticker: 'AMZN',
                  totalGain: 35
              ),
            )
          ],
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

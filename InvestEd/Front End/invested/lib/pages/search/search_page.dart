import 'package:flutter/material.dart';
import 'package:invested/pages/search/news_article_card.dart';
import 'package:invested/util/custom_text_field.dart';
import 'package:invested/util/page_title.dart';

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
                CustomTextField(
                  prefixIcon: Icons.search,
                  hintText: "Find Ticker...",
                  labelText: "Find Ticker",
                  textCallBack: (value) {},
                  textController: searchController
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

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../util/custom_text.dart';

class NewsArticleCard extends StatelessWidget {
  final String title;
  final String publishDate;
  final String thumbnailURL;
  final List<String> authors;
  const NewsArticleCard({
    Key? key,
    this.title = '',
    this.publishDate = '',
    this.thumbnailURL = '',
    this.authors = const []
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 350
        ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  child: const WebView(
                    initialUrl: "https://www.investing.com/analysis/zoom-stock-looks-attractive-amid-extreme-bearish-sentiment-200632671",
                  ),
                  type: PageTransitionType.rightToLeftWithFade));
        },
        child: Card(
          margin: const EdgeInsets.all(10),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Image.network(
                  thumbnailURL,
                  width: 350,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              CustomText(
                text: "Temp Title Here",
              ),
            ],
          ),
        ),
      )
    );
  }
}

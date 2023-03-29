import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invested/pages/news/news_page.dart';
import 'package:invested/util/widget/text/custom_text.dart';

class NewsArticleCard extends StatelessWidget {
  final String title;
  final String publishDate;
  final String thumbnailURL;
  final String summary;
  final String websiteUrl;
  final List<String> authors;
  const NewsArticleCard({
    Key? key,
    this.title = '',
    this.publishDate = '',
    this.thumbnailURL = '',
    this.summary = '',
    this.websiteUrl = '',
    this.authors = const []
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.95
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute (
                builder: (BuildContext context) => NewsPage(
                  thumbnail: thumbnailURL,
                  title: title,
                  publishDate: publishDate,
                  summary: summary,
                  websiteUrl: websiteUrl,
                  authors: authors,
                ),
              ),
            );
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
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                    thumbnailURL,
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.2,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.05,
                            vertical: MediaQuery.of(context).size.width * 0.01
                        ),
                        child: CustomText(
                          text: title,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.05,
                            vertical: MediaQuery.of(context).size.height * 0.01
                        ),
                        child: CustomText(
                          alignment: Alignment.centerLeft,
                          text: "By: ${authors.elementAt(0)}",
                          fontSize: 18,
                        )
                    )
                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}


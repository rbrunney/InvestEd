import 'package:flutter/material.dart';
import 'package:invested/pages/landing/landing_button.dart';
import 'package:invested/util/widget/page/to_previous_page.dart';
import 'package:invested/util/widget/page/to_previous_page_circle.dart';
import 'package:invested/util/widget/text/custom_text.dart';
import 'package:invested/util/widget/text/page_title.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {
  final String thumbnail;
  final String title;
  final String publishDate;
  final String summary;
  final String websiteUrl;
  final List<String> authors;
  const NewsPage({
    Key? key,
    this.thumbnail = '',
    this.title = '',
    this.publishDate = '',
    this.summary = '',
    this.websiteUrl = '',
    this.authors = const []
  }) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(
              children: [
                SingleChildScrollView(
                    child: Column(
                        children: [
                          buildHeader(),
                          buildContent()
                        ]
                    )
                ),
                const ToPrevPageCircle()
              ],
            )
        )
    );
  }

  Column buildHeader() {

    List<String> date = widget.publishDate.substring(0, 10).split('-');

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
          child: Image.network(widget.thumbnail)
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.02),
          child: PageTitle(
            alignment: Alignment.center,
            title: widget.title,
            fontSize: 25,
            bottomMargin: 0,
          )
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Row(
            children: [
              Expanded(
                child: CustomText(
                  text: 'By: ${widget.authors.elementAt(0)}',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )
              ),
              Expanded(
                child: CustomText(
                  text: "${date.elementAt(1)}-${date.elementAt(2)}-${date.elementAt(0)}",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )
              )
            ],
          )
        ),
      ],
    );
  }

  _launchUrl() async {
    final uri = Uri.parse(widget.websiteUrl);

    if(await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Container buildContent() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.03),
      child: Column(
        children: [
          CustomText(
            text: '    ${widget.summary}',
            fontSize: 17,
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: LandingButton(
                onTap: () {_launchUrl();},
                text: 'Read Full Article',
                hasFillColor: true
            )
          )
        ],
      ),
    );
  }

}

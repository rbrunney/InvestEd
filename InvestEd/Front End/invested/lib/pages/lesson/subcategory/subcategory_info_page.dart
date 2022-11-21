import 'package:flutter/material.dart';
import 'package:invested/pages/lesson/subcategory/subcategory_snippet.dart';
import 'package:invested/util/close_page_icon.dart';
import 'package:invested/util/global_styling.dart' as global_styling;

import '../../../util/custom_text.dart';
import '../../../util/page_title.dart';

class SubCategoryInfo extends StatelessWidget {
  final String title;
  final List<String> snippets;
  const SubCategoryInfo({
    Key? key,
    this.title = "",
    this.snippets = const []
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const ClosePageIcon(),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: PageTitle(
                    alignment: Alignment.center,
                    title: title,
                    fontSize: 25,
                  ),
                ),
                Column(
                  children: const [
                    SubCategorySnippet(snippet: "Investment goals spread into three branches, depending on age, income and outlook. Age can be further sub-divided into three distinct segments: young and starting out, middle aged and family building and old and self-directed. These classifications often miss their marks at the appropriate age, with middle-agers looking at investments for the first time or old folks forced to rigorously budget, exercising the discipline they lacked as young adults."),
                    SubCategorySnippet(snippet: "Income provides the natural starting point for investment goals because you can’t invest what you don’t have. The first career job issues a wake-up call for many young people, forcing decisions about 401(k) contributions, savings or money market accounts and lifestyle changes needed to balance growing affluence with delayed gratification. It’s common to experience setbacks during this period, getting stuck in overpriced home rental and car payments or forgetting that your guardians are no longer picking up the monthly credit card bill.",)
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 40),
                  child: InkWell(
                    onTap: () {

                    },
                    child: SizedBox(
                        height: 40,
                        width: 200,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Color(global_styling.LOGO_COLOR),
                              borderRadius: const BorderRadius.all(Radius.circular(5))
                          ),
                          child: CustomText(
                            color: Color(global_styling.GREY_LOGO_COLOR),
                            text: "Complete!",
                          ),
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

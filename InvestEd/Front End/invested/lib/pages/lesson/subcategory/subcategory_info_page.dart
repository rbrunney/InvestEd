import 'dart:io';

import 'package:flutter/material.dart';
import 'package:invested/pages/lesson/subcategory/subcategory_snippet.dart';
import 'package:invested/util/close_page_icon.dart';
import 'package:invested/util/global_styling.dart' as global_styling;
import 'package:invested/util/global_info.dart' as global_info;
import 'package:path_provider/path_provider.dart';

import '../../../util/custom_text.dart';
import '../../../util/page_title.dart';

class SubCategoryInfo extends StatefulWidget {
  final String title;
  final List<dynamic> snippets;

  const SubCategoryInfo({
    Key? key,
    this.title = "",
    this.snippets = const []
  }) : super(key: key);

  @override
  State<SubCategoryInfo> createState() => _SubCategoryInfoState();
}

class _SubCategoryInfoState extends State<SubCategoryInfo> {

  List<SubCategorySnippet> lessonInfo = [];

  @override
  void initState() {
    super.initState();
    for (var snippet in widget.snippets) {
      setState(() {
        lessonInfo.add(SubCategorySnippet(
          snippet: snippet,
        ));
      });
    }
  }

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
                    title: widget.title,
                    fontSize: 25,
                  ),
                ),
                Column(
                  children: lessonInfo
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 40),
                  child: InkWell(
                    onTap: () async {
                      final Directory directory = await getApplicationDocumentsDirectory();
                      final File file = File('${directory.path}/${global_info.username}.txt');

                      try {
                        await file.writeAsString("${await file.readAsString()} ${widget.title}");
                      } catch (e) {
                        await file.writeAsString(widget.title);
                      }

                      Navigator.pop(context);
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

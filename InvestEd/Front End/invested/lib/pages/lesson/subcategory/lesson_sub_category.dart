import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/pages/lesson/subcategory/subcategory_info_page.dart';
import 'package:invested/util/custom_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:invested/util/global_styling.dart' as global_styling;

class LessonSubCategory extends StatelessWidget {
  final String subCategoryName;
  final bool hasFinished;
  const LessonSubCategory({
    Key? key,
    this.subCategoryName = "",
    this.hasFinished = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  child: SubCategoryInfo(title: subCategoryName),
                  type: PageTransitionType.fade));
        },
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Card(
                child:
                    Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            CustomText(
                              text: subCategoryName,
                            ),
                            const Spacer(),
                            hasFinished ? Icon(MaterialCommunityIcons.checkbox_marked_outline, color: Color(global_styling.LOGO_COLOR))
                                : const Icon(MaterialCommunityIcons.checkbox_blank_outline)
                          ],
                        )
                    )
            )
        )
    );
  }
}

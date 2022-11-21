import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/util/custom_text.dart';

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
        onTap: () {},
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
                            hasFinished ? const Icon(MaterialCommunityIcons.checkbox_marked_outline)
                                : const Icon(MaterialCommunityIcons.checkbox_blank_outline)
                          ],
                        )
                    )
            )
        )
    );
  }
}

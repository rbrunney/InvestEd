import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/util/custom_text.dart';
import 'package:invested/util/page_title.dart';
import 'package:invested/util/to_previous_page.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
            children: const [
              ToPrevPage(),
              PageTitle(
                title: "Instagram",
                fontSize: 25,
              ),
              Icon(MaterialCommunityIcons.instagram)
            ],
          )
      ),
    );
  }
}

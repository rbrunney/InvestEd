import 'package:flutter/material.dart';
import 'package:invested/util/to_previous_page.dart';

class AccountDetailsPage extends StatefulWidget {
  const AccountDetailsPage({Key? key}) : super(key: key);

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold (
          body: Column(
            children: const [
              ToPrevPage()
            ],
          ),
        )
    );
  }
}

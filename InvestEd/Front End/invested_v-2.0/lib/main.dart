import 'package:flutter/material.dart';
import 'package:invested/navigation/bottom_tab_navigation.dart';
import 'package:invested/pages/landing/landing_page.dart';
import 'util/style/global_styling.dart' as global_style;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, this.isLoggedIn = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor:
              const Color(global_style.whiteBackgroundColor)),
      home: isLoggedIn ? const HomePage() : const LandingPage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Scaffold(body: BottomTabNavigation()));
  }
}
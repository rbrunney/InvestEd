import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../util/global_styling.dart' as global_style;

class BottomTabNavigation extends StatefulWidget {
  const BottomTabNavigation({Key? key}) : super(key: key);

  @override
  State<BottomTabNavigation> createState() => _BottomTabNavigationState();
}

class _BottomTabNavigationState extends State<BottomTabNavigation> {

  int _selectedIndex = 0;
  PageController pageController = PageController();

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: (newPage) {
            setState(() {
              _selectedIndex = newPage;
            });
          },
          children: const [
            SafeArea(child: Scaffold(body: Text("Portfolio"))),
            SafeArea(child: Scaffold(body: Text("Lesson"))),
            SafeArea(child: Scaffold(body: Text("Challenge"))),
            SafeArea(child: Scaffold(body: Text("Account"))),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(MaterialCommunityIcons.chart_line),
              label: 'Portfolio',
            ),
            BottomNavigationBarItem(
              icon: Icon(MaterialCommunityIcons.book_education_outline),
              label: 'Lesson',
            ),
            BottomNavigationBarItem(
              icon: Icon(Ionicons.podium_outline),
              label: 'Challenge',
            ),
            BottomNavigationBarItem(
                icon: Icon(MaterialCommunityIcons.account_circle_outline),
                label: 'Account'
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(global_style.greenPrimaryColor),
          unselectedItemColor: const Color(global_style.greenAccentColor),
          onTap: onTapped,
        ),
      ),
    );
  }
}

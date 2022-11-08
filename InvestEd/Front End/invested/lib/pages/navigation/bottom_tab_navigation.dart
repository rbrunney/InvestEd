import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:invested/pages/account/account_page.dart';
import 'package:invested/pages/home/home_page.dart';
import 'package:invested/pages/lesson/lesson_page.dart';
import 'package:invested/pages/search/search_page.dart';

class PageNavigation extends StatefulWidget {
  const PageNavigation({Key? key}) : super(key: key);

  @override
  State<PageNavigation> createState() => _PageNavigationState();
}

class _PageNavigationState extends State<PageNavigation>  {
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
            HomePage(),
            LessonPage(),
            SearchPage(),
            AccountPage()
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
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
                icon: Icon(MaterialCommunityIcons.account_circle_outline),
                label: 'Account'
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.blueGrey,
          onTap: onTapped,
        ),
      ),
    );
  }
}

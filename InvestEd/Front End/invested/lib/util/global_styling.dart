import 'package:flutter/material.dart';

int LOGO_COLOR = 0xFF33cc66;
int GREY_LOGO_COLOR = 0xFF1f1f1f;
String TITLE_FONT = "WorkSansBold";
String TEXT_FONT = "WorkSans";

ThemeChanger currentTheme = ThemeChanger();

class ThemeChanger with ChangeNotifier {
  static bool isDark = true;

  ThemeMode currentTheme() {
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}
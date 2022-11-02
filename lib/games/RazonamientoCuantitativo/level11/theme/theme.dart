import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData currentheme;

  //ThemeData currentheme2;

  ThemeProvider({required bool isDarkmode})
      : currentheme = isDarkmode ? ThemeData.dark() : ThemeData.light();

  setLightMode() {
    currentheme = ThemeData.light();
    notifyListeners();
  }

  setDarkMode() {
    currentheme = ThemeData.dark();
    notifyListeners();
  }
}

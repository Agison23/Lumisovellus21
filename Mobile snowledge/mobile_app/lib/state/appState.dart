import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int _pageIndex = 0;
  int get pageIndex {
    return _pageIndex;
  }

  set setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }
}
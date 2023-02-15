import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int _pageIndex = 0;
  bool _isEnglish = false;

  bool get isEnglish => _isEnglish;

  set toggleLanguage(bool value) {
    _isEnglish = !_isEnglish;
    notifyListeners();
  }

  int get pageIndex {
    return _pageIndex;
  }

  set setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  static bool _userInAppSettings = false;
  bool get userInAppSettings {
    return _userInAppSettings;
  }

  set setUserInAppSettings(bool value) {
    _userInAppSettings = value;
    notifyListeners();
  }
}

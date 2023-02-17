import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int _pageIndex = 0;

  String _language = 'fi'; //Default language is Finnish
  String _languageName = 'SUOMI';

  final Map _allLanguages = {'SUOMI': 'fi', 'ENGLISH': 'en'};
  //final Map _allLanguages = {'SUOMI': 'fi', 'ENGLISH': 'en', 'SVENSKA': 'se'};

  Map get allLanguages => _allLanguages;

  String get language => _language;

  String get languageName => _languageName;

  set setLanguage(String language) {
    _language = _allLanguages[language];
    _languageName = language;
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

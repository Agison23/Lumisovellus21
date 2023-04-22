import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int _pageIndex = 0;

  String _language = 'fi'; //Default language is Finnish
  String _languageName = 'SUOMI';
  String _chatRoomId = '';

  final Map _allLanguages = {'SUOMI': 'fi', 'ENGLISH': 'en'};

  Map get allLanguages => _allLanguages;

  String get language => _language;

  String get languageName => _languageName;

  String get chatRoomId => _chatRoomId;

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

  set setChatRoomId(String value) {
    _chatRoomId = value;
    notifyListeners();
  }

  int _numOfHelpRequests = 0;
  int get numOfHelpRequests => _numOfHelpRequests;

  set setNumOfHelpRequest(int value) {
    print(value > 0
        ? "Hey, another help request was sent!"
        : "One less help request, good job!");
    _numOfHelpRequests += value;
    if (_numOfHelpRequests < 0) {
      _numOfHelpRequests = 0;
    }
    notifyListeners();
  }
}

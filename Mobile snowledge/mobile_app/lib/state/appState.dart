import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int _pageIndex = 0;

  String _language = 'fi'; //Default language is Finnish
  String _languageName = 'SUOMI';
  String _chatRoomId = '';
  bool _hasUnreadMessages = false; // For unread message notifications
  bool _isMenuItemDisabled = false; // Hide menu item
  bool _isPremiumSidebar = false;

  final List _premiumFeatureMenuItems = [0, 3];

  final Map _allLanguages = {'SUOMI': 'fi', 'ENGLISH': 'en'};

  Map get allLanguages => _allLanguages;

  String get language => _language;

  String get languageName => _languageName;

  String get chatRoomId => _chatRoomId;

  bool get hasUnreadMessages => _hasUnreadMessages;

  final Map _chatRoomUsersBattery = {};

  Map get chatRoomUsersBattery => _chatRoomUsersBattery;

  bool get isMenuItemDisabled => _isMenuItemDisabled;

  bool get isPremiumSidebar => _isPremiumSidebar;

  List get premiumFeatureMenuItems => _premiumFeatureMenuItems;

  void setChatRoomUsersBattery(String phoneNum, String batteryStatus) {
    _chatRoomUsersBattery[phoneNum] = batteryStatus;
    debugPrint(
        '======== SET $phoneNum TO BATTERY STATUS $batteryStatus ========');
    notifyListeners(); // Notify any listeners that the state has changed
  }

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

  set setHasUnreadMessages(bool value) {
    _hasUnreadMessages = value;
    notifyListeners();
  }

  set setIsMenuItemDisabled(bool value) {
    _isMenuItemDisabled = value;
    notifyListeners();
  }

  set setIsPremiumSidebar(bool value) {
    _isPremiumSidebar = value;
    notifyListeners();
  }
}

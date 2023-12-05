import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  String _appEnv = 'development';
  int _pageIndex = 1;

  String _language = 'fi'; //Default language is Finnish
  String _languageName = 'SUOMI';
  String _chatRoomId = '';
  bool _hasUnreadMessages = false; // For unread message notifications
  bool _isPremiumSidebar = false;

  String _userRole = 'premium';

  final List _premiumFeatureMenuItems = [0, 3];

  bool _showTutorial = true;
  int _currentTutorialStep = 1;

  final Map _tutorialSteps = {
    'MENU_TAP': 1,
    'MENU_NAVIGATION': 2,
    'LOCATION_SHARING': 3,
    'SHARE_LOCATION_DIALOG': 4,
    'ASK_FOR_HELP': 5,
    'HELP_DIALOG': 6,
    'MINOR_HELP_DIALOG': 7
  };

  Map get tutorialSteps => _tutorialSteps;

  final Map _allLanguages = {'SUOMI': 'fi', 'ENGLISH': 'en'};

  String get appEnv => _appEnv;

  Map get allLanguages => _allLanguages;

  String get language => _language;

  String get languageName => _languageName;

  String get chatRoomId => _chatRoomId;

  bool get hasUnreadMessages => _hasUnreadMessages;

  int get currentTutorialStep => _currentTutorialStep;

  final Map _chatRoomUsersBattery = {};

  Map get chatRoomUsersBattery => _chatRoomUsersBattery;

  bool get showTutorial => _showTutorial;

  bool get isPremiumSidebar => _isPremiumSidebar;

  List get premiumFeatureMenuItems => _premiumFeatureMenuItems;

  String get userRole => _userRole;

  void setChatRoomUsersBattery(String phoneNum, String batteryStatus) {
    _chatRoomUsersBattery[phoneNum] = batteryStatus;
    debugPrint(
        '======== SET $phoneNum TO BATTERY STATUS $batteryStatus ========');
    notifyListeners(); // Notify any listeners that the state has changed
  }

  set setAppEnv(String value) {
    _appEnv = value;
    notifyListeners();
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

  set setShowTutorial(bool value) {
    _showTutorial = value;
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((pref) {
      pref.setBool('showTutorial', value);
    });
    notifyListeners();
  }

  set setCurrentTutorialStep(int value) {
    _currentTutorialStep = value;
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((pref) {
      pref.setInt('currentTutorialStep', value);
    });
    notifyListeners();
  }

  void nextTutorialStep() {
    _currentTutorialStep += 1;
    setCurrentTutorialStep =
        _currentTutorialStep <= tutorialSteps.length ? _currentTutorialStep : 1;
    notifyListeners();
  }

  set setIsPremiumSidebar(bool value) {
    _isPremiumSidebar = value;
    notifyListeners();
  }

  set setUserRole(String value) {
    _userRole = value;
    notifyListeners();
  }
}

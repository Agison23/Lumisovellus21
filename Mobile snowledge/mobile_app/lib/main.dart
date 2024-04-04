import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/map_tracking.dart';
import 'package:mobile_app/side_bar/server_communications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_page.dart';
import 'onboarding.dart';

String? fName;
String premiumRole = 'premium';
String normalRole = 'normal';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  await Firebase.initializeApp();
  prefs.then((pref) {
    fName = pref.getString('fName');
    // This bool to see if rescue chat has unread message or not
    // prefs.setBool("_hasUnreadMsg", false);
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isInitialized = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider<AppState>(create: (_) => AppState())],
      builder: (context, child) {
        var appState = Provider.of<AppState>(context, listen: false);
        initiateTutorial(appState);

        if (!isInitialized) {
          isInitialized = true;
          ServerComms.listenServer(context);
          // pull all pending help requests
          ServerComms.messageToServer("REQUEST_INIT");
          // set the battery status when the app begins
          ServerComms.messageToServer("BATTERY");

          // Fetch user role and set page index
          fetchUserRole(appState);
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: MyApp.navigatorKey,
          title: 'Snowledge',
          home: (fName == null)
              ? const OnBoardingPage()
              : (appState.userRole != '' && appState.userRole == premiumRole
                  ? const MainPage()
                  : const MapTracking()),
        );
      },
    );
  }
}

Future<void> fetchUserRole(AppState appState) async {
  await ServerComms.messageToServer('GET_ROLE', role: appState.userRole);
  if (appState.userRole != premiumRole && appState.userRole != normalRole) {
    await ServerComms.messageToServer('UPDATE_ROLE',
        // TODO: Change the latter to normalRole when the app is ready for production with premium role
        role: appState.appEnv == 'development' ? premiumRole : premiumRole);
  }

  // navigate to Snowmap if user is normal
  if (appState.userRole == premiumRole) {
    appState.setPageIndex = 0;
  }
}

void initiateTutorial(AppState appState) {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  prefs.then((pref) {
    // Show tutorial
    appState.setShowTutorial = pref.getBool('showTutorial') ?? true;

    // Set current step
    appState.setCurrentTutorialStep = pref.getInt('currentTutorialStep') ?? 1;
  });
}

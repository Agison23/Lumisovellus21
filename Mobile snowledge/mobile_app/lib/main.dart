import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/map_tracking.dart';
import 'package:mobile_app/side_bar/server_communications.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
<<<<<<< HEAD
=======

import 'main_page.dart';
import 'onboarding.dart';
<<<<<<< HEAD
import 'name_input_screen.dart';
>>>>>>> 5ccd3dc (Onboarding and userinfo working)
import 'welcome_screen.dart';
=======

>>>>>>> 84ad3cc (Finishing tasks and cleaning up)

String? fName;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  ServerComms.startListeningServer();

  prefs.then((pref) {
    fName = pref.getString('fName');
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'Snowledge',
        home: (fName == null) ? const FirstScreen() : const MapTracking(),
      ),
=======
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'notification',
      home: (fName == null) ? OnBoardingPage() : MapTracking(),
>>>>>>> 5ccd3dc (Onboarding and userinfo working)
    );
  }
}
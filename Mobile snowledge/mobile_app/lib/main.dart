import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/map_tracking.dart';
import 'package:mobile_app/side_bar/server_communications.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_page.dart';
import 'onboarding.dart';



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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'Snowledge',
        home: (fName == null) ? const OnBoardingPage() : const MapTracking(),
      ),
    );
  }
}

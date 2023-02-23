import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_app/side_bar/navigation_drawer.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'bottom_bar/bottomBar.dart';
import 'package:provider/provider.dart';

import '../state/appState.dart';
import '../translations/translations.dart';

class AppInfo extends StatefulWidget {
  const AppInfo({Key? key}) : super(key: key);

  @override
  State<AppInfo> createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    return WillPopScope(
      onWillPop: () async {
        if (_globalKey.currentState?.isDrawerOpen == true) {
          Navigator.of(context).pop();
          return false;
        } else {
          final value = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(translations['quitApp'][appState.language]),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(translations['no'][appState.language]),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(translations['yes'][appState.language]),
                    ),
                  ],
                );
              });
          if (value != null) {
            return Future.value(value);
          } else {
            return Future.value(false);
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          key: _globalKey,
          body: Stack(
            children: [
              const WebView(
                initialUrl: 'https://lumisovellus.fi/tietoasovelluksesta',
                // initialUrl: 'http://localhost:3000/tietoasovelluksesta',
                javascriptMode: JavascriptMode.unrestricted,
              ),
              // Stacking the bottom bar on top of the webview
              const Align(
                  alignment: Alignment.bottomCenter, child: BottomBar()),
              IconButton(
                iconSize: 30,
                icon: Stack(
                  children: [
                    const Icon(Icons.menu),
                    if (appState.numOfHelpRequests > 0)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Text(
                              '!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () {
                  _globalKey.currentState?.openDrawer();
                },
                color: Colors.white,
              ),
            ],
          ),
          drawer: const MyNavigationDrawer(),
        ),
      ),
    );
  }
}

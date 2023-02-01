import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_app/side_bar/navigation_drawer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'bottom_bar/bottomBar.dart';

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
                  title: Text('Haluatko poistua sovelluksesta?'),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('En'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Kyllä'),
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
                icon: const Icon(Icons.menu),
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

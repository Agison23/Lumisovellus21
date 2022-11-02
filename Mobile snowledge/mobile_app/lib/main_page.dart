import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_app/bottom_bar/bottomBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'notification_handler.dart';
import 'side_bar/side_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();

    new NotificationHandler().init(context);
    Timer.run(() => _globalKey.currentState?.openDrawer());
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
                initialUrl: 'https://lumisovellus.fi/',
                javascriptMode: JavascriptMode.unrestricted,
              ),
              // Stacking the bottom bar on top of the webview
              // Remove comments when changes has made to lumisovellus
              // const Align(
              //     alignment: Alignment.bottomCenter,
              //     child: BottomBar()
              // ),
              IconButton(
                iconSize: 30,
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _globalKey.currentState?.openDrawer();
                },
                color: Colors.black,
              ),
            ],
          ),
          drawer: SideBar(),
        ),
      ),
    );
  }
}

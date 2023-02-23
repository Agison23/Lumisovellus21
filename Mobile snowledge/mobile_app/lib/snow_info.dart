import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_app/side_bar/navigation_drawer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'bottom_bar/bottomBar.dart';

class SnowInfo extends StatefulWidget {
  const SnowInfo({Key? key}) : super(key: key);

  @override
  State<SnowInfo> createState() => _SnowInfoState();
}

class _SnowInfoState extends State<SnowInfo> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final Completer<WebViewController> _controller =
        Completer<WebViewController>();
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
              WebView(
                initialUrl: 'https://lumisovellus.fi/selitteet',

                // ONLY USE THIS URL FOR LOCAL TESTING (this is "localhost:3000" for Flutter)
                // initialUrl: 'http://10.0.2.2:3000/selitteet',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
              // Stacking the bottom bar on top of the webview
              // Remove comments when changes has made to lumisovellus
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
          drawer: MyNavigationDrawer(
            webViewController: _controller.future,
          ),
        ),
      ),
    );
  }
}

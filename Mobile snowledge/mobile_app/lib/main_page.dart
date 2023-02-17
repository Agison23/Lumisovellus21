import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_app/side_bar/gps_handler.dart';
import 'package:mobile_app/side_bar/navigation_drawer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../widgets_binding_observer_state.dart';
import 'bottom_bar/bottomBar.dart';
import 'notification_handler.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends WidgetsBindingObserverState<MainPage> {
  @override
  void initState() {
    super.initState();

    NotificationHandler().init(context);

    // since this is the mainpage, we need to initialize gps here so that users
    // reqeusting help can see this device as a nearby potential helper
    // if the main page of the app changes, move these lines as well
    setAppResumedWithAlwaysOnPermissionsTask(() => {setState(() {})});
    GpsHandler.setGpsSetting(context, true, insistAlwaysOn: false)
        .then((gpsOn) async {
      if (gpsOn) {
        await GpsHandler.updateGpsVariable(ignoreSwitch: true);
      }
    });

    // this is force opening the drawer
    /*Timer.run(() => _globalKey.currentState?.openDrawer()); */
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
          // floatingActionButton: FloatingActionButton(onPressed: () {
          //   print("Hi!");
          // }),
          body: Stack(
            children: [
              WebView(
                initialUrl: 'https://lumisovellus.fi/mobiili',
                // initialUrl: 'http://localhost:3000/mobiili',
                // initialUrl: 'https://youtube.com',
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
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
                color: Colors.black,
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

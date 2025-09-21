import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_app/side_bar/navigation_drawer.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'bottom_bar/bottomBar.dart';
import '../translations/translations.dart';
import 'helper/utility.dart';

class SnowInfo extends StatefulWidget {
  const SnowInfo({Key? key}) : super(key: key);

  @override
  State<SnowInfo> createState() => _SnowInfoState();
}

class _SnowInfoState extends State<SnowInfo> {
  Map<String, String>? env;
  String appEnv = 'production';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEnv();
  }

  Future<void> loadEnv() async {
    final _env = await Utility.parseStringToMap(assetsFileName: '.env');
    setState(() {
      env = _env;
      // Set default value of app environment to production
      appEnv = env?['APP_ENVIRONMENT'] ?? 'production';
      isLoading = false;
      print('App Env is: $appEnv');
    });
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final Completer<WebViewController> _controller =
        Completer<WebViewController>();
    var appState = Provider.of<AppState>(context, listen: false);
    String languageToChangeTo = appState.language;
    String? appURL;

    if (!isLoading) {
      appURL = appEnv == 'production'
          ? 'https://lumisovellus.fi/selitteet'
          : 'http://10.0.2.2:3000/selitteet';
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
                WebView(
                  initialUrl: appURL,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  onPageFinished: (String url) {
                    _controller.future.then((controller) {
                      controller.runJavascript("""
                      window.changeLanguageTo("$languageToChangeTo");
                    """);
                    });
                  },
                ),
                // Stacking the bottom bar on top of the webview
                // Remove comments when changes has made to lumisovellus
                const Align(
                    alignment: Alignment.bottomCenter, child: BottomBar()),
                IconButton(
                  iconSize: 30,
                  icon: Stack(
                    children: [
                      const Icon(Icons.menu),
                    ],
                  ),
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
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

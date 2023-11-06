import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_app/helper/utility.dart';
import 'package:mobile_app/side_bar/gps_handler.dart';
import 'package:mobile_app/side_bar/navigation_drawer.dart';
import 'package:mobile_app/side_bar/server_communications.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:mobile_app/widgets/buttons.dart';
import 'package:mobile_app/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../widgets_binding_observer_state.dart';
import 'bottom_bar/bottomBar.dart';
import 'bottom_bar/state/setSharingLocation.dart';
import 'helper/utility.dart';
import 'notification_handler.dart';
import '../translations/translations.dart';
import 'package:logging/logging.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends WidgetsBindingObserverState<MainPage> {
  Map<String, String>? env;
  String appEnv = 'production';
  bool isLoading = true;

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
        SetSharingLocationState.setGpsSwitchState(true);
      }
    });

    // this is force opening the drawer
    /*Timer.run(() => _globalKey.currentState?.openDrawer()); */
    loadEnv();
  }

  Future<void> loadEnv() async {
    final _env = await Utility.parseStringToMap(assetsFileName: '.env');
    var appState = Provider.of<AppState>(context, listen: false);

    setState(() {
      env = _env;
      // Set default value of app environment to production
      appEnv = env?['APP_ENVIRONMENT'] ?? 'production';
      isLoading = false;
      print('App Env is: $appEnv');

      appState.setAppEnv = appEnv;
    });
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final Completer<WebViewController> _controller =
        Completer<WebViewController>();
    var appState = Provider.of<AppState>(context, listen: false);
    var languageToChangeTo = appState.language;
    String? appURL;

    if (!isLoading) {
      appURL = appEnv == 'production'
          ? 'https://lumisovellus.fi/mobiili'
          : 'http://10.0.2.2:3000/mobiili';
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
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  // Change the global React state after the page has been loaded
                  onPageFinished: (String url) {
                    _controller.future.then((controller) {
                      controller.runJavascript("""
                      window.changeLanguageTo("$languageToChangeTo");
                    """);
                    });
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  key: const Key('snowConditionWebView'),
                ),
                // Stacking the bottom bar on top of the webview
                const Align(
                    alignment: Alignment.bottomCenter, child: BottomBar()),
                IconButton(
                  iconSize: 30,
                  icon: Stack(
                    children: const [
                      Icon(Icons.menu),
                    ],
                  ),
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
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

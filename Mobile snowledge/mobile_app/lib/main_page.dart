import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_app/helper/utility.dart';
import 'package:mobile_app/side_bar/gps_handler.dart';
import 'package:mobile_app/side_bar/navigation_drawer.dart';
import 'package:mobile_app/side_bar/server_communications.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:mobile_app/widgets/bubble_slides.dart';
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
import 'package:bubble_showcase/bubble_showcase.dart';
import 'package:speech_bubble/speech_bubble.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends WidgetsBindingObserverState<MainPage> {
  Map<String, String>? env;
  String appEnv = 'production';
  bool isLoading = true;

  final GlobalKey _menuIconKey = GlobalKey();
  final GlobalKey _mainViewKey = GlobalKey();

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
    AppState appState = Provider.of<AppState>(context, listen: true);
    String languageToChangeTo = appState.language;
    String? appURL;

    // Let's try to only trigger the bubble showcase when step is 1
    bool showTutorial = appState.showTutorial;
    int currentTutorialStep = appState.currentTutorialStep;

    JavascriptChannel _channel = JavascriptChannel(
      name: 'myChannel', // Name your channel.
      onMessageReceived: (message) {
        // Handle messages received from JavaScript here.
        print("Received message from JavaScript: $message");
        // You can trigger Flutter functions based on the message received.
      },
    );

    if (!isLoading) {
      appURL = appEnv == 'production'
          ? 'https://lumisovellus.fi/mobiili'
          : 'http://10.0.2.2:3000/mobiili';
      Widget mainApp =
          buildMainApp(appState, _controller, appURL, languageToChangeTo);
      if (currentTutorialStep == appState.tutorialSteps['MENU_TAP'] &&
          showTutorial) {
        return BubbleShowcase(
          bubbleShowcaseId: 'my_bubble_showcase_2',
          bubbleShowcaseVersion: 1,
          doNotReopenOnClose: true,
          bubbleSlides: [
            BubbleSlides().getRelativeBubbleSlide(
                appState,
                translations['menuNavigationTutorial']['openMenu']
                    [appState.language],
                _menuIconKey,
                axisDirection: AxisDirection.left,
                nipLocation: NipLocation.LEFT,
                padding: const EdgeInsets.only(left: 15.0),
                shape: const Oval(
                  spreadRadius: 1,
                ))
          ],
          child: mainApp,
        );
      }

      return mainApp;

      // return mainApp;
    } else {
      return buildLoading();
    }
  }

  Widget buildMainApp(
      AppState appState,
      Completer<WebViewController> _controller,
      String appURL,
      String languageToChangeTo) {
    return WillPopScope(
      onWillPop: () async {
        return onBackButtonPress(appState);
      },
      child: SafeArea(
        key: _mainViewKey,
        child: Scaffold(
            key: _globalKey,
            body: Stack(
              children: [
                // Stacking the bottom bar on top of the webview
                createWebView(
                    _controller, appURL, languageToChangeTo, appState),
                const Align(
                    alignment: Alignment.bottomCenter, child: BottomBar()),
                IconButton(
                  key: _menuIconKey,
                  iconSize: 30,
                  icon: Stack(
                    children: const [
                      Icon(Icons.menu),
                    ],
                  ),
                  onPressed: () {
                    _globalKey.currentState?.openDrawer();
                    print("Menu button pressed");
                    if (appState.showTutorial &&
                        appState.currentTutorialStep ==
                            appState.tutorialSteps['MENU_TAP']) {
                      appState.nextTutorialStep();
                    }
                  },
                  color: Colors.black,
                )
              ],
            ),
            drawer: MyNavigationDrawer(
              webViewController: _controller.future,
            ),
            onDrawerChanged: (isOpen) {
              if (!isOpen) {
                if (appState.showTutorial &&
                    appState.currentTutorialStep ==
                        appState.tutorialSteps['MENU_NAVIGATION']) {
                  appState.nextTutorialStep();
                }
              }
            }),
      ),
    );
  }

  Widget buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  WebView createWebView(Completer<WebViewController> _controller, String appURL,
      String languageToChangeTo, AppState appState) {
    return WebView(
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
    );
  }

  Future<bool> onBackButtonPress(AppState appState) async {
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
        return value;
      }
      return false;
    }
  }
}

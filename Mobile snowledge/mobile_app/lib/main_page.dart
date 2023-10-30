import 'dart:async';
import 'dart:convert';

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

  final GlobalKey menuIconKey = GlobalKey();

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
    var appState = Provider.of<AppState>(context, listen: false);
    var languageToChangeTo = appState.language;
    String? appURL;

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
                  // initialUrl: appURL,
                  initialUrl: "",
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                    _controller.future.then((controller) {
                      const String content = '''
                        <!DOCTYPE html>
                        <html lang="en">
                          <head>
                            <meta charset="UTF-8" />
                            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                            <title>Two-Way Communication</title>
                          </head>
                          <body>
                            <h1>Two-Way Communication</h1>

                            <p>Message from Flutter: <span id="messageFromFlutter"></span></p>
                            <button onclick="sendMessageToFlutter()">Send Message to Flutter</button>

                            <script>
                              function sendMessageToFlutter() {
                                var message = "Hello from the web!";
                                messageHandler.postMessage(message);
                              }
                            </script>
                          </body>
                        </html>
                      ''';

                      // Use Uri.dataFromString to load the HTML content
                      controller.loadUrl(Uri.dataFromString(
                        content,
                        mimeType: 'text/html',
                        encoding: Encoding.getByName('utf-8'),
                      ).toString());
                    });
                  },
                  // Change the global React state after the page has been loaded
                  // onPageFinished: (String url) {
                  //   _controller.future.then((controller) {
                  //     controller.runJavascript("""
                  //     window.changeLanguageTo("$languageToChangeTo");
                  //   """);
                  //   });
                  // },
                  javascriptMode: JavascriptMode.unrestricted,
                  javascriptChannels: {
                    JavascriptChannel(
                        name: 'messageHandler',
                        onMessageReceived: (JavascriptMessage message) {
                          //This is where you receive message from
                          //javascript code and handle in Flutter/Dart
                          //like here, the message is just being printed
                          //in Run/LogCat window of android studio
                          print(message.message);
                        })
                  },
                ),
                // Stacking the bottom bar on top of the webview
                const Align(
                    alignment: Alignment.bottomCenter, child: BottomBar()),
                BubbleShowcase(
                  bubbleShowcaseId: 'my_bubble_showcase',
                  bubbleShowcaseVersion: 1,
                  bubbleSlides: [
                    RelativeBubbleSlide(
                      widgetKey: menuIconKey,
                      child: RelativeBubbleSlideChild(
                        direction: AxisDirection.down,
                        widget: SpeechBubble(
                          nipLocation: NipLocation.TOP,
                          color: const Color(0xff5A97EE),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Tap to open the menu',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    RelativeBubbleSlide(
                      widgetKey: menuIconKey,
                      child: RelativeBubbleSlideChild(
                        direction: AxisDirection.right,
                        widget: SpeechBubble(
                          nipLocation: NipLocation.LEFT,
                          color: Colors.blue,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'This is a new cool feature !',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  child: IconButton(
                    key: menuIconKey,
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

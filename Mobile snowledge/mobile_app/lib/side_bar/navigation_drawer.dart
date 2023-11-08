import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app_info.dart';
import 'package:mobile_app/helper/utility.dart';
import 'package:mobile_app/main_page.dart';
import 'package:mobile_app/map_tracking.dart';
import 'package:mobile_app/snow_info.dart';
import 'package:mobile_app/translations/translations.dart';
import 'package:mobile_app/weather.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:mobile_app/user_info.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bubble_showcase/bubble_showcase.dart';
import 'package:speech_bubble/speech_bubble.dart';

import '../state/appState.dart';
//import '../user_information_view.dart';

class MyNavigationDrawer extends StatefulWidget {
  const MyNavigationDrawer({
    Key? key,
    this.webViewController,
  }) : super(key: key);

  final Future<WebViewController>? webViewController;

  @override
  State<MyNavigationDrawer> createState() => _MyNavigationDrawerState();
}

class _MyNavigationDrawerState extends State<MyNavigationDrawer> {
  bool winter = Utility.getSummerOrWinter();

  final GlobalKey _snowConditionKey = GlobalKey();
  final GlobalKey _mapViewKey = GlobalKey();
  final GlobalKey _weatherKey = GlobalKey();
  final GlobalKey _snowTypeKey = GlobalKey();
  final GlobalKey _userInfoKey = GlobalKey();
  final GlobalKey _serviceInfo = GlobalKey();
  final GlobalKey _appNameKey = GlobalKey();
  final GlobalKey _privacyKey = GlobalKey();
  final ValueKey _languageKey = ValueKey('languageSideDropdown');

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context, listen: true);
    Widget navigationDrawer = buildNavigationDrawer(context);

    return (appState.showTutorial && appState.currentTutorialStep == 2)
        ? BubbleShowcase(
            bubbleShowcaseId: 'my_bubble_showcase',
            bubbleShowcaseVersion: 1,
            bubbleSlides: [
              _buttonSlide("Show snow condition", _snowConditionKey),
              _buttonSlide("Show area's map", _mapViewKey),
              _buttonSlide("Show weather", _weatherKey),
            ],
            child: navigationDrawer,
          )
        : navigationDrawer;
  }

  Widget buildNavigationDrawer(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
              ),
            ),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  // creating hamburger bar contents
  Widget buildMenuItems(BuildContext context) {
    var appState = Provider.of<AppState>(context);

    void setLanguage(String language) async {
      final controller = await widget.webViewController;
      String languageToChange = appState.allLanguages[language];
      if (controller != null) {
        controller.runJavascript("""
                window.changeLanguageTo("$languageToChange");
              """);
      }
      appState.setLanguage = language;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 8,
        children: [
          _item(0, Icons.area_chart_outlined,
              translations['conditions'][appState.language], _snowConditionKey),
          Visibility(
            child: _item(1, Icons.map_outlined,
                translations['mapView'][appState.language], _mapViewKey),
            visible:
                true, // replace with winter (line 22) if you want to hide during summertime
          ),
          _item(2, Icons.sunny_snowing,
              translations['weather'][appState.language], _weatherKey),
          Visibility(
            child: _item(
                3,
                Icons.ac_unit,
                translations['snowDescription'][appState.language],
                _snowTypeKey),
            visible:
                true, // replace with winter (line 22) if you want to hide during summertime
          ),
          _item(4, Icons.person_outline,
              translations['userInfo'][appState.language], _userInfoKey),
          _item(5, Icons.menu_book_outlined,
              translations['serviceInfo'][appState.language], _serviceInfo),
          const Divider(color: Colors.black),
          _item(6, Icons.downhill_skiing_outlined,
              translations['appName'][appState.language], _appNameKey),
          _item(7, Icons.privacy_tip_outlined,
              translations['privacy'][appState.language], _privacyKey),
          const Divider(color: Colors.black),
          Center(
            child: DropdownButton<String>(
              key: _languageKey,
              value: appState.languageName,
              onChanged: (String? value) {
                setLanguage(value!);
              },
              items: appState.allLanguages.keys
                  .toList()
                  .map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  key: ValueKey(item.toString()),
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(int index, IconData iconData, String title, GlobalKey key) {
    var appState = Provider.of<AppState>(context);
    return Stack(
      key: key,
      children: [
        ListTile(
          leading: Icon(iconData),
          iconColor: index == appState.pageIndex
              ? const Color(0xff5A97EE)
              : Colors.black,
          textColor: index == appState.pageIndex
              ? const Color(0xff5A97EE)
              : Colors.black,
          title: Text(title),
          trailing: index == 6 || index == 7 ? const Icon(Icons.launch) : null,
          onTap: () async {
            if (index == appState.pageIndex) {
            } else {
              setState(() {
                appState.setPageIndex = index;
              });
              if (index == 0) {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                    (route) => false);
              } else if (index == 1) {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MapTracking()),
                    (route) => false);
              } else if (index == 2) {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Weather()),
                    (route) => false);
              } else if (index == 3) {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SnowInfo()),
                    (route) => false);
              } else if (index == 4) {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => UserInfoPage()),
                    (route) => false);
              } else if (index == 5) {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const AppInfo()),
                    (route) => false);
              } else if (index == 6) {
                String url = "https://www.pallaksenpollot.com/";
                var urllaunchable = canLaunchUrlString(
                    url); //canLaunch is from url_launcher package
                if (await urllaunchable) {
                  await launchUrlString(
                      url); //launch is from url_launcher package to launch URL
                } else {}
              } else if (index == 7) {
                String url = "https://www.pallaksenpollot.com/privacypolicy";
                var urllaunchable = canLaunchUrlString(
                    url); //canLaunch is from url_launcher package
                if (await urllaunchable) {
                  await launchUrlString(
                      url); //launch is from url_launcher package to launch URL
                } else {}
              } else {}
            }
          },
        ),
      ],
    );
  }

  RelativeBubbleSlide _buttonSlide(String message, GlobalKey key) {
    print("=============== Showing bubble slide for" + message);
    return RelativeBubbleSlide(
      widgetKey: key,
      shape: const Oval(
        spreadRadius: 0,
      ),
      child: RelativeBubbleSlideChild(
        direction: AxisDirection.down,
        widget: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: SpeechBubble(
            nipLocation: NipLocation.TOP,
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

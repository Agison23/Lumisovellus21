import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app_info.dart';
import 'package:mobile_app/helper/utility.dart';
import 'package:mobile_app/main_page.dart';
import 'package:mobile_app/map_tracking.dart';
import 'package:mobile_app/snow_info.dart';
import 'package:mobile_app/weather.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:mobile_app/user_info.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
      );

  // creating hamburger bar contents
  Widget buildMenuItems(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    var languageToChangeTo = appState.isEnglish ? "fi" : "en";

    void _toggleLanguage() async {
      final controller = await widget.webViewController;
      if (controller != null) {
        controller.runJavascript("""
                window.changeLanguageTo("$languageToChangeTo");
              """);
      }
      appState.toggleLanguage = true;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 8,
        children: [
          _item(
              0,
              Icons.area_chart_outlined,
              !appState.isEnglish
                  ? "Lumiolosuhteet Pallaksella"
                  : "Snow conditions in Pallas"),
          Visibility(
            child: _item(1, Icons.map_outlined,
                !appState.isEnglish ? "Karttanäkymä" : "View Map"),
            visible:
                true, // replace with winter (line 22) if you want to hide during summertime
          ),
          _item(2, Icons.sunny_snowing,
              !appState.isEnglish ? "Sää Pallaksella" : "Weather in Pallas"),
          Visibility(
            child: _item(
                3,
                Icons.ac_unit,
                !appState.isEnglish
                    ? "Lumityyppien selitteet"
                    : "Snow types Information"),
            visible:
                true, // replace with winter (line 22) if you want to hide during summertime
          ),
          _item(4, Icons.person_outline,
              !appState.isEnglish ? "Käyttäjätiedot" : "User Information"),
          _item(
              5,
              Icons.menu_book_outlined,
              !appState.isEnglish
                  ? "Tietoa palvelusta"
                  : "Application Information"),
          const Divider(color: Colors.black),
          _item(
            6,
            Icons.downhill_skiing_outlined,
            !appState.isEnglish ? "Pallaksen Pöllöt" : "Pallas (something?)",
          ),
          _item(
            7,
            Icons.privacy_tip_outlined,
            !appState.isEnglish ? "Tietosuojaseloste" : "Privacy Statement",
          ),
          const Divider(color: Colors.black),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: CupertinoSwitch(
                      value: appState.isEnglish,
                      onChanged: (bool value) {
                        // I want to use the webViewController here
                        _toggleLanguage();
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: DrawerHeader(
                    child: Text(
                      appState.isEnglish ? 'ENGLISH' : 'SUOMEA',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _item(int index, IconData iconData, String title) {
    var appState = Provider.of<AppState>(context);
    return Stack(
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
        if (appState.numOfHelpRequests > 0 && title == "Karttanäkymä")
          Positioned(
            top: 15,
            right: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(10)),
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
    );
  }
}

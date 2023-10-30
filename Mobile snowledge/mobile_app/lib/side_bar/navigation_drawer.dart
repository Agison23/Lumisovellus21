import 'package:flutter/material.dart';
import 'package:mobile_app/app_info.dart';
import 'package:mobile_app/helper/utility.dart';
import 'package:mobile_app/main_page.dart';
import 'package:mobile_app/map_tracking.dart';
import 'package:mobile_app/side_bar/server_communications.dart';
import 'package:mobile_app/snow_info.dart';
import 'package:mobile_app/translations/translations.dart';
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
  Widget build(BuildContext context) {
    return Drawer(
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
  }

  Widget buildHeader(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(Icons.verified_outlined, size: 30.0),
        Switch(
            value: appState.isPremiumSidebar,
            onChanged: (value) {
              ServerComms.messageToServer('GET_ROLE');
              appState.setIsPremiumSidebar = value;
            })
      ],
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

    debugPrint('ROLE:' + appState.userRole);
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 8,
        children: [
          Visibility(
            child: _item(0, Icons.area_chart_outlined,
                translations['conditions'][appState.language]),
            visible: appState.isPremiumSidebar,
          ),
          Visibility(
            child: _item(1, Icons.map_outlined,
                translations['mapView'][appState.language]),
            visible:
                true, // replace with winter (line 22) if you want to hide during summertime
          ),
          _item(2, Icons.sunny_snowing,
              translations['weather'][appState.language]),
          Visibility(
            child: _item(3, Icons.ac_unit,
                translations['snowDescription'][appState.language]),
            visible: appState.isPremiumSidebar, // show if user is premium
            // replace with winter (line 22) if you want to hide during summertime
          ),
          _item(4, Icons.person_outline,
              translations['userInfo'][appState.language]),
          _item(5, Icons.menu_book_outlined,
              translations['serviceInfo'][appState.language]),
          const Divider(color: Colors.black),
          _item(
            6,
            Icons.downhill_skiing_outlined,
            translations['appName'][appState.language],
          ),
          _item(
            7,
            Icons.privacy_tip_outlined,
            translations['privacy'][appState.language],
          ),
          const Divider(color: Colors.black),
          Center(
            child: DropdownButton<String>(
              key: const ValueKey('languageSideDropdown'),
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

  Widget _item(int index, IconData iconData, String title) {
    var appState = Provider.of<AppState>(context);
    return Stack(
      children: [
        ListTile(
          leading: Icon(iconData),
          iconColor: _getMenuIconColor(index, appState),
          textColor: _getMenuIconColor(index, appState),
          title: Text(title),
          trailing: _showMenuItemIcon(index, appState),
          onTap: () async {
            if (index == appState.pageIndex) {
            } else {
              if (appState.premiumFeatureMenuItems.contains(index) &&
                  appState.isPremiumSidebar &&
                  appState.userRole != 'premium') {
                _showPremiumDialog(context);
                return;
              }
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

  Color _getMenuIconColor(int index, AppState appState) {
    if (appState.premiumFeatureMenuItems.contains(index) &&
        appState.userRole != 'premium') {
      return Colors.grey;
    } else {
      if (index == appState.pageIndex) {
        return const Color(0xff5A97EE);
      } else {
        return Colors.black;
      }
    }
  }

  Widget? _showMenuItemIcon(int index, AppState appState) {
    if (appState.premiumFeatureMenuItems.contains(index) &&
        appState.userRole != 'premium') {
      return const Icon(Icons.lock_outline);
    }
    if (index == 6 || index == 7) {
      return const Icon(Icons.launch);
    }
    return null;
  }

  Future<void> _showPremiumDialog(BuildContext context) {
    var appState = Provider.of<AppState>(context, listen: false);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          icon: const Icon(Icons.verified_outlined, size: 40.0),
          title: Text(translations['premiumDialogTitle'][appState.language]),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          content: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.lock_open, color: Colors.black),
                title: Text(translations['conditions'][appState.language]),
              ),
              ListTile(
                leading: const Icon(Icons.lock_open, color: Colors.black),
                title: Text(translations['snowDescription'][appState.language]),
              ),
            ],
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 40.0),
                    backgroundColor: const Color(0xff5A97EE),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    foregroundColor: Colors.white),
                child: Text(
                    translations['premiumDialogButtonText'][appState.language]),
                onPressed: () {
                  setState(() {
                    appState.setPageIndex = 4;
                  });
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => UserInfoPage()),
                      (route) => false);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

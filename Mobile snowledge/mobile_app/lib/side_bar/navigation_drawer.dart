import 'package:flutter/material.dart';
import 'package:mobile_app/app_info.dart';
import 'package:mobile_app/helper/utility.dart';
import 'package:mobile_app/main_page.dart';
import 'package:mobile_app/map_tracking.dart';
import 'package:mobile_app/side_bar/server_communications.dart';
import 'package:mobile_app/snow_info.dart';
import 'package:mobile_app/translations/translations.dart';
import 'package:mobile_app/weather.dart';
import 'package:mobile_app/widgets/bubble_slides.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:mobile_app/user_info.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bubble_showcase/bubble_showcase.dart';
import 'package:speech_bubble/speech_bubble.dart';

import '../state/appState.dart';

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
  String premiumRole = 'premium';
  String normalRole = 'normal';

  final GlobalKey _snowConditionKey = GlobalKey();
  final GlobalKey _mapViewKey = GlobalKey();
  final GlobalKey _weatherKey = GlobalKey();
  final GlobalKey _snowTypeKey = GlobalKey();
  final GlobalKey _userInfoKey = GlobalKey();
  final GlobalKey _serviceInfo = GlobalKey();
  final GlobalKey _appNameKey = GlobalKey();
  final GlobalKey _privacyKey = GlobalKey();
  final GlobalKey _languageDropdownKey = GlobalKey();
  final ValueKey _languageKey = const ValueKey('languageSideDropdown');

  @override
  void initState() {
    super.initState();

    // Fetch user role
    fetchUserRole();
  }

  Future<void> fetchUserRole() async {
    var appState = Provider.of<AppState>(context, listen: false);

    await ServerComms.messageToServer('GET_ROLE', role: appState.userRole);
    if (appState.userRole != premiumRole && appState.userRole != normalRole) {
      await ServerComms.messageToServer('UPDATE_ROLE',
          role: appState.appEnv == 'development' ? premiumRole : normalRole);
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context, listen: true);
    Widget navigationDrawer = buildNavigationDrawer(context);

    if (appState.showTutorial &&
        appState.currentTutorialStep ==
            appState.tutorialSteps['MENU_NAVIGATION']) {
      List<BubbleSlide> slides = buildBubbleSlides(appState);

      return BubbleShowcase(
        bubbleShowcaseId: 'my_bubble_showcase_3',
        bubbleShowcaseVersion: 1,
        doNotReopenOnClose: true,
        bubbleSlides: slides,
        child: navigationDrawer,
      );
    }
    return navigationDrawer;
  }

  List<BubbleSlide> buildBubbleSlides(AppState appState) {
    List<BubbleSlide> normalSlides = [
      BubbleSlides().getRelativeBubbleSlide(
          appState,
          translations['menuNavigationTutorial']['showLocationArea']
              [appState.language],
          _mapViewKey),
      BubbleSlides().getRelativeBubbleSlide(
          appState,
          translations['menuNavigationTutorial']['showWeather']
              [appState.language],
          _weatherKey),
      BubbleSlides().getRelativeBubbleSlide(
          appState,
          translations['menuNavigationTutorial']['showUserInfo']
              [appState.language],
          _userInfoKey),
      BubbleSlides().getRelativeBubbleSlide(
          appState,
          translations['menuNavigationTutorial']['showServiceInfo']
              [appState.language],
          _serviceInfo),
      BubbleSlides().getRelativeBubbleSlide(
          appState,
          translations['menuNavigationTutorial']['openWebPage']
              [appState.language],
          _appNameKey),
      BubbleSlides().getRelativeBubbleSlide(
          appState,
          translations['menuNavigationTutorial']['openPrivacy']
              [appState.language],
          _privacyKey),
      BubbleSlides().getRelativeBubbleSlide(
          appState,
          translations['menuNavigationTutorial']['changeLanguage']
              [appState.language],
          _languageDropdownKey)
    ];
    List<BubbleSlide> premiumSlides = [
      BubbleSlides().getRelativeBubbleSlide(
          appState,
          translations['menuNavigationTutorial']['showSnowCondition']
              [appState.language],
          _snowConditionKey),
      BubbleSlides().getRelativeBubbleSlide(
          appState,
          translations['menuNavigationTutorial']['showLocationArea']
              [appState.language],
          _mapViewKey),
      BubbleSlides().getRelativeBubbleSlide(
          appState,
          translations['menuNavigationTutorial']['showWeather']
              [appState.language],
          _weatherKey),
      BubbleSlides().getRelativeBubbleSlide(
          appState,
          translations['menuNavigationTutorial']['showSnowType']
              [appState.language],
          _snowTypeKey),
      BubbleSlides().getRelativeBubbleSlide(
          appState,
          translations['menuNavigationTutorial']['showUserInfo']
              [appState.language],
          _userInfoKey),
      BubbleSlides().getRelativeBubbleSlide(
          appState,
          translations['menuNavigationTutorial']['showServiceInfo']
              [appState.language],
          _serviceInfo),
      BubbleSlides().getRelativeBubbleSlide(
          appState,
          translations['menuNavigationTutorial']['openWebPage']
              [appState.language],
          _appNameKey),
      BubbleSlides().getRelativeBubbleSlide(
          appState,
          translations['menuNavigationTutorial']['openPrivacy']
              [appState.language],
          _privacyKey),
      BubbleSlides().getRelativeBubbleSlide(
          appState,
          translations['menuNavigationTutorial']['changeLanguage']
              [appState.language],
          _languageDropdownKey)
    ];
    return appState.isPremiumSidebar || appState.userRole == premiumRole
        ? premiumSlides
        : normalSlides;
  }

  Widget buildNavigationDrawer(BuildContext context) {
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

  buildHeader(BuildContext context) {
    var appState = Provider.of<AppState>(context, listen: false);
    return appState.userRole == premiumRole
        ? Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.verified_outlined, size: 30.0),
              Switch(
                  value: appState.isPremiumSidebar,
                  onChanged: (value) async {
                    appState.setIsPremiumSidebar = value;
                  })
            ],
          );
  }

  // creating hamburger bar contents
  Widget buildMenuItems(BuildContext context) {
    var appState = Provider.of<AppState>(context, listen: false);

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
          Visibility(
            child: _item(
                0,
                Icons.area_chart_outlined,
                translations['conditions'][appState.language],
                _snowConditionKey),
            visible:
                appState.isPremiumSidebar || appState.userRole == premiumRole,
          ),
          Visibility(
            child: _item(1, Icons.map_outlined,
                translations['mapView'][appState.language], _mapViewKey),
            visible:
                true, // replace with winter (line 22) if you want to hide during summertime
            key: const ValueKey('snowCondition'),
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
                appState.isPremiumSidebar || appState.userRole == premiumRole,
            // replace with winter (line 22) if you want to hide during summertime
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
            key: _languageDropdownKey,
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
    var appState = Provider.of<AppState>(context, listen: false);
    return Stack(
      key: key,
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
                  appState.userRole != premiumRole) {
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
        appState.userRole != premiumRole) {
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
        appState.userRole != premiumRole) {
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

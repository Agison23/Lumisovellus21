import 'package:flutter/material.dart';
import 'package:mobile_app/app_info.dart';
import 'package:mobile_app/main_page.dart';
import 'package:mobile_app/map_tracking.dart';
import 'package:mobile_app/snow_info.dart';
import 'package:mobile_app/weather.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../state/appState.dart';
import '../user_information_view.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
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
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          _item(
              0,
              Icons.map_outlined,
              "Karttanäkymä"
          ),
          _item(
              1,
              Icons.area_chart_outlined,
              "Lumiolosuhteet Pallaksella"
          ),
          _item(
              2,
              Icons.sunny_snowing,
              "Sää Pallaksella"
          ),
          _item(
              3,
              Icons.ac_unit,
              "Lumityyppien selitteet"
          ),
          _item(
              4,
              Icons.person_outline,
              "Käyttäjätiedot"
          ),
          _item(
              5,
              Icons.menu_book_outlined,
              "Tietoa palvelusta"
          ),
          const Divider(color: Colors.black),
          _item(
              6,
              Icons.downhill_skiing_outlined,
              "Pallaksen Pöllöt",
          ),
          _item(
              7,
              Icons.privacy_tip_outlined,
              "Tietosuojaseloste",
          ),
        ],
      ),
    );
  }

  Widget _item(int index, IconData iconData, String title) {
    var appState = Provider.of<AppState>(context);
    return ListTile(
      leading: Icon(iconData),
      iconColor: index == appState.pageIndex ? const Color(0xff5A97EE) : Colors.black,
      textColor: index == appState.pageIndex ? const Color(0xff5A97EE) : Colors.black,
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
                MaterialPageRoute(
                    builder: (context) => const MapTracking()),
                    (route) => false);
          } else if (index == 1) {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainPage()),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserInfoPage()),
            );
          } else if (index == 5) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AppInfo()),
            );
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
          } else {

          }
        }
      },
    );
  }
}

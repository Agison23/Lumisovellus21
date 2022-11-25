import 'package:flutter/material.dart';
import 'package:mobile_app/app_info.dart';
import 'package:mobile_app/main_page.dart';
import 'package:mobile_app/map_tracking.dart';
import 'package:mobile_app/snow_info.dart';
import 'package:mobile_app/weather.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../user_information_view.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

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
  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        //width: MediaQuery.of(context).size.width * 0.1,
        child: Wrap(
          runSpacing: 16,
          children: [
            ListTile(
              leading: const Icon(Icons.map_outlined),
              title: const Text("Karttanäkymä"),
              onTap: () {
                Navigator.pop(context);

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MapTracking()),
                    (route) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.area_chart_outlined),
              title: const Text('Lumiolosuhteet Pallaksella'),
              onTap: () {
                Navigator.pop(context);

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                    (route) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sunny_snowing),
              title: const Text('Sää Pallaksella'),
              onTap: () {
                Navigator.pop(context);

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Weather()),
                    (route) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.ac_unit),
              title: const Text('Lumityyppien selitteet'),
              onTap: () {
                Navigator.pop(context);

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SnowInfo()),
                    (route) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Käyttäjätiedot'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserInfoPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: const Text('Tietoa palvelusta'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AppInfo()),
                );
              },
            ),
            const Divider(color: Colors.black),
            ListTile(
              leading: const Icon(Icons.downhill_skiing_outlined),
              title: const Text('Pallaksen Pöllöt'),
              trailing: const Icon(Icons.launch),
              onTap: () async {
                String url = "https://www.pallaksenpollot.com/";
                var urllaunchable = canLaunchUrlString(
                    url); //canLaunch is from url_launcher package
                if (await urllaunchable) {
                  await launchUrlString(
                      url); //launch is from url_launcher package to launch URL
                } else {}
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Tietosuojaseloste'),
              trailing: const Icon(Icons.launch),
              onTap: () async {
                String url = "https://www.pallaksenpollot.com/privacypolicy";
                var urllaunchable = canLaunchUrlString(
                    url); //canLaunch is from url_launcher package
                if (await urllaunchable) {
                  await launchUrlString(
                      url); //launch is from url_launcher package to launch URL
                } else {}
              },
            ),
          ],
        ),
      );
}

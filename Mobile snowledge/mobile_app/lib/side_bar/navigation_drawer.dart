import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/main_page.dart';
import 'package:mobile_app/map_tracking.dart';

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
              leading: const Icon(Icons.home_outlined),
              title: const Text('Koti'),
              onTap: () {
                // close navigation drawer before opening the linked page
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.map_outlined),
              title: const Text('Karttanäkymä'),
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
              title: const Text('Tunturialueet'),
              onTap: () {
                Navigator.pop(context);

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                    (route) => false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.downhill_skiing_outlined),
              title: const Text('Pallaksen Pöllöt'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: const Text('Tietoa palvelusta'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(color: Colors.black),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Tietosuojaseloste'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Käyttäjätiedot'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  UserInfoPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.login_outlined),
              title: const Text('Admin kirjautuminen'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
}

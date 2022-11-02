import 'dart:async';

import 'package:flutter/material.dart';
import 'notification_handler.dart';

class NewMainPage extends StatefulWidget {
  const NewMainPage({Key? key}) : super(key: key);
  @override
  State<NewMainPage> createState() => _MainPageState();
}

class _MainPageState extends State<NewMainPage> {
  @override
  void initState() {
    super.initState();
    new NotificationHandler().init(context);
    //this code opened the side menu automatically
    //Timer.run(() => _globalKey.currentState?.openDrawer());
  }

  //creating the title bar and hamburger menu icon
  @override
  Widget build(BuildContext) => Scaffold(
    appBar: AppBar(
      title: const Text('Snowledge'),
      backgroundColor: Colors.black,
    ),
    drawer: const NavigationDrawer(),
    backgroundColor: Colors.grey,
  );
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super (key: key);

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
  Widget buildHeader(BuildContext context) => Container (
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top,
    ),
  );

  // creating hamburger bar contents
  Widget buildMenuItems(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    //width: MediaQuery.of(context).size.width * 0.1,
    child: Wrap (
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

            //Navigator.of(context).push(MaterialPageRoute(
            //builder: (context) => const MapView()
            // ));
          },
        ),
        ListTile(
          leading: const Icon(Icons.area_chart_outlined),
          title: const Text('Tunturialueet'),
          onTap: () {
            Navigator.pop(context);
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
            Navigator.pop(context);
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

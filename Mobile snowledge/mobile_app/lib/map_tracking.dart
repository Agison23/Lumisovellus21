import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:mobile_app/side_bar/gps_handler.dart';
import 'package:mobile_app/side_bar/server_communications.dart';

import 'package:url_launcher/url_launcher_string.dart';
import 'notification_handler.dart';
import 'package:mobile_app/bottom_bar/bottomBar.dart';
import 'package:mobile_app/side_bar/navigation_drawer.dart';
import 'package:flutter/material.dart';

class MapTracking extends StatefulWidget {
  const MapTracking({Key? key}) : super(key: key);

  @override
  State<MapTracking> createState() => MapTrackingState();
}

class MapTrackingState extends State<MapTracking> {
  static Stream locationStream = GpsHandler.getCoordinates();

  @override
  initState() {
    super.initState();
    GpsHandler.setGpsSetting(context, true, insistAlwaysOn: false)
        .then((gpsOn) async {
      if (gpsOn) {
        await GpsHandler.updateGpsVariable(ignoreSwitch: true);

        /* await ServerComms.messageToServer('LOCATION');
        ServerComms.startSendingLocationMessages(); */
      }
    });

    new NotificationHandler().init(context);
    Timer.run(() => _globalKey.currentState?.openDrawer());
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: locationStream,
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          String locationData =
              snapshot.data.toString().replaceAll(RegExp('[,>]'), '');
          List<String> dataList = locationData.toString().split(' ');
          var lat = double.parse(dataList[1]);
          var lng = double.parse(dataList[3]);

          return SafeArea(
            child: Scaffold(
              key: _globalKey,
              body: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      minZoom: 6,
                      maxZoom: 18,
                      center: LatLng(lat, lng),
                      zoom: 11.0,
                    ),
                    layers: [
                      TileLayerOptions(urlTemplate: getSummerOrWinterMap()
                          // Pöllöille oma API avain!
                          ),
                      MarkerLayerOptions(
                        markers: getMarkers(LatLng(lat, lng)),
                        rotate: true,
                      ),
                    ],
                  ),
                  // Stacking the bottom bar on top of the webview
                  // Remove comments when changes has made to lumisovellus
                  const Align(
                      alignment: Alignment.bottomCenter, child: BottomBar()),
                  IconButton(
                    iconSize: 30,
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      _globalKey.currentState?.openDrawer();
                    },
                    color: Colors.black,
                  ),

                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Tooltip(
                          message:
                              "© MapTiler\n© OpenStreetMap contributors\nhttps://maptiler.com/",
                          child: IconButton(
                            onPressed: () async {
                              const url = "https://maptiler.com/";
                              if (await canLaunchUrlString(url)) {
                                await launchUrlString(url);
                              } else {
                                print('ERROR');
                              }
                            },
                            icon: Image.asset('assets/images/MapTiler.png'),
                            iconSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              drawer: const NavigationDrawer(),
            ),
          );
        }));
  }

  static String getSummerOrWinterMap() {
    int month = DateTime.now().month;
    if (month > 5 && month < 11) {
      return "https://api.maptiler.com/maps/outdoor/256/{z}/{x}/{y}.png?key=vIqtYxkJALvxfiyLqutC";
    }
    return "https://api.maptiler.com/maps/winter/256/{z}/{x}/{y}.png?key=vIqtYxkJALvxfiyLqutC";
  }

  static List<Marker> getMarkers(LatLng usersLatLng) {
    List<Marker> markers = [];
    markers.add(
      Marker(
        width: 50.0,
        height: 30.0,
        point: usersLatLng,
        builder: (ctx) => Container(
          width: 1.0,
          height: 1.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          child: const Align(
            alignment: Alignment.center,
            child: Text(
              'Olet\ntässä',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 8.0,
              ),
            ),
          ),
        ),
      ),
    );
    return markers;
  }
}

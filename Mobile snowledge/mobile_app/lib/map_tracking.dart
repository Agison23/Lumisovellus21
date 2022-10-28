import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:mobile_app/side_bar/gps_handler.dart';
import 'package:mobile_app/side_bar/server_communications.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'main_page.dart';
import 'package:mobile_app/side_bar/side_bar_state.dart';
import 'package:mobile_app/side_bar/gps_handler.dart';

class MapTracking extends StatefulWidget {
  final bool tempGps;
  const MapTracking(this.tempGps, {Key? key}) : super(key: key);

  @override
  State<MapTracking> createState() => MapTrackingState();
}

class MapTrackingState extends State<MapTracking> {
  static late Timer _stateUpdateTimer;
  static late List<Marker> _markers = [];
  static late LatLng currentLocation;

  @override
  initState() {
    super.initState();
    GpsHandler.setGpsSetting(context, true, insistAlwaysOn: false)
        .then((gpsOn) async {
      if (gpsOn) {
        await GpsHandler.updateGpsVariable(ignoreSwitch: true);
        await ServerComms.messageToServer('LOCATION');
      }
    });

    _stateUpdateTimer = Timer.periodic(
      const Duration(seconds: 2),
      (Timer t) => {
        getLatLng().then((usersLatLng) {
          setState(() {
            _markers = getMarkers(usersLatLng);
            currentLocation = usersLatLng;
          });
        })
      },
    );

    //ServerComms.messageToServer("HELP");
  }

  static Future<LatLng> getLatLng() async {
    var location = GpsHandler.gps;
    return LatLng(location.latitude!, location.longitude!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                minZoom: 6,
                maxZoom: 18,
                center: currentLocation,
                zoom: 11.0,
              ),
              layers: [
                TileLayerOptions(urlTemplate: getSummerOrWinterMap()
                    // Pöllöille oma API avain!
                    ),
                MarkerLayerOptions(
                  markers: _markers,
                  rotate: true,
                ),
              ],
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
      ),
    );
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

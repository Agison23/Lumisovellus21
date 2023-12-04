import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:mobile_app/helper/loading_indicator.dart';
import 'package:mobile_app/helper/utility.dart';
import 'package:mobile_app/side_bar/gps_handler.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'bottom_bar/state/setSharingLocation.dart';
import 'notification_handler.dart';
import 'package:mobile_app/bottom_bar/bottomBar.dart';
import 'package:mobile_app/side_bar/navigation_drawer.dart';
import '../../widgets_binding_observer_state.dart';
import '../translations/translations.dart';

class MapTracking extends StatefulWidget {
  const MapTracking({Key? key}) : super(key: key);

  @override
  MapTrackingState createState() => MapTrackingState();
}

class MapTrackingState extends WidgetsBindingObserverState<MapTracking> {
  final MapController _mapController = MapController();
  static Location _location = new Location();
  @override
  initState() {
    super.initState();
    setAppResumedWithAlwaysOnPermissionsTask(() => {setState(() {})});
    GpsHandler.setGpsSetting(context, true, insistAlwaysOn: false)
        .then((gpsOn) async {
      if (gpsOn) {
        await GpsHandler.updateGpsVariable(ignoreSwitch: true);

        //Checks the value of the location-switch in "Sijainti" -popup
        Future<bool> checkPermission = GpsHandler.loadGpsSetting();
        if (await checkPermission) {
          SetSharingLocationState.setGpsSwitchState(true);
          // print("Permission Granted!");
        } else {
          SetSharingLocationState.setGpsSwitchState(false);
          _location.enableBackgroundMode(enable: false);
          // print("Permission not Granted");
        }
      }
    });

    NotificationHandler().init(context);
    // Timer.run(() => _globalKey.currentState?.openDrawer());
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context, listen: false);
    var lat;
    var lng;
    return WillPopScope(
      onWillPop: () async {
        if (_globalKey.currentState?.isDrawerOpen == true) {
          Navigator.of(context).pop();
          return false;
        } else {
          final value = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(translations['quitApp'][appState.language]),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(translations['no'][appState.language]),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(translations['yes'][appState.language]),
                    ),
                  ],
                );
              });
          if (value != null) {
            return Future.value(value);
          } else {
            return Future.value(false);
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          key: _globalKey,
          body: Stack(
            children: [
              StreamBuilder(
                  stream: GpsHandler.getCoordinates(),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: LoadingIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    String locationData =
                        snapshot.data.toString().replaceAll(RegExp('[,>]'), '');
                    List<String> dataList = locationData.toString().split(' ');
                    lat = double.parse(dataList[1]);
                    lng = double.parse(dataList[3]);
                    return FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        minZoom: 6,
                        maxZoom: 18,
                        center: LatLng(lat, lng),
                        zoom: 11.0,
                      ),
                      children: [
                        TileLayer(urlTemplate: getSummerOrWinterMap()
                            // Pöllöille oma API avain!
                            ),
                        MarkerLayer(
                          markers: getMarker(LatLng(lat, lng)),
                          rotate: true,
                        ),
                      ],
                    );
                  })),
              const Align(
                  alignment: Alignment.bottomCenter, child: BottomBar()),
              IconButton(
                iconSize: 30,
                icon: Stack(
                  children: [
                    const Icon(Icons.menu),
                  ],
                ),
                onPressed: () {
                  _globalKey.currentState?.openDrawer();
                },
                color: Colors.black,
              ),
              // maptiler logo button
              Align(
                alignment: const Alignment(-0.95, 0.82),
                child: Tooltip(
                  message:
                      "© MapTiler\n© OpenStreetMap contributors\nhttps://maptiler.com/",
                  child: IconButton(
                    onPressed: () async {
                      const url = "https://maptiler.com/";
                      if (await canLaunchUrlString(url)) {
                        await launchUrlString(url);
                      } else {
                        // print('ERROR');
                      }
                    },
                    icon: Image.asset('assets/images/MapTiler.png'),
                    iconSize: 20,
                  ),
                ),
              ),
              // location centering button
              Align(
                  alignment: const Alignment(0.95, 0.82),
                  child: IconButton(
                    icon: const Icon(Icons.my_location),
                    onPressed: () {
                      _mapController.moveAndRotate(
                          LatLng(lat, lng), _mapController.zoom, 0);
                    },
                  )),
              const Align(
                  alignment: Alignment.topCenter,
                  child: Image(
                    image:
                        AssetImage('assets/images/logo_transparent_black.png'),
                    width: 80,
                    height: 80,
                  ))
            ],
          ),
          drawer: const MyNavigationDrawer(),
        ),
      ),
    );
  }

  static String getSummerOrWinterMap() {
    if (Utility.getSummerOrWinter()) {
      return "https://api.maptiler.com/maps/winter/256/{z}/{x}/{y}.png?key=vIqtYxkJALvxfiyLqutC";
    }
    return "https://api.maptiler.com/maps/outdoor/256/{z}/{x}/{y}.png?key=vIqtYxkJALvxfiyLqutC";
  }

  static List<Marker> getMarker(LatLng usersLatLng) {
    List<Marker> marker = [];
    marker.add(Marker(
      point: usersLatLng,
      builder: (ctx) => Container(
          width: 1.0,
          height: 1.0,
          child: const Icon(
            Icons.person_pin_circle,
            size: 40,
          )),
    ));
    return marker;
  }
}

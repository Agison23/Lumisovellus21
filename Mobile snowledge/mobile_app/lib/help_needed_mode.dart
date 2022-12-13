import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_app/helper/utility.dart';
import 'package:mobile_app/side_bar/gps_handler.dart';
import 'package:mobile_app/side_bar/server_communications.dart';
import 'package:mobile_app/widgets/dialogs.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HelpNeeded extends StatefulWidget {
  final bool tempGps;
  const HelpNeeded(this.tempGps, {Key? key}) : super(key: key);

  @override
  State<HelpNeeded> createState() => HelpNeededState();
}

class HelpNeededState extends State<HelpNeeded> {
  final MapController _mapController = MapController();
  Timer? _stateUpdateTimer;
  Timer? _timer;
  static late List<Marker> _markers = [];
  static final List<Marker> _helpers = [];
  static final List _users = ['1'];

  int _start = 1;

  @override
  void dispose() {
    if (widget.tempGps) {
      GpsHandler.setGpsSetting(context, false);
      _markers.clear();
      _helpers.clear();
    }
    Dialogs.resetRadioSelection();
    ServerComms.messageToServer('HELP_DELETE');
    _stateUpdateTimer?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    // Add this line to add a user and verify that the dialog stays close if a user is nearby
    // _helpers.add(newHelper('2', LatLng(69.4547856, 31.8517288)));

    getLatLng().then((usersLatLng) {
      _markers = getMarkers(_helpers, usersLatLng);
    });

    _stateUpdateTimer = Timer.periodic(
      const Duration(seconds: 2),
      (Timer t) => {
        getLatLng().then((usersLatLng) {
          // if users nearby
          if (_users.isNotEmpty) {
            // if users has accepted the request
            if (_helpers.isNotEmpty) {
              setState(() {
                _markers = getMarkers(_helpers, usersLatLng);
              });
            } else {
              // start a timer once
              if (_start == 0) {
              } else {
                showDialogAfter5Minutes();
                setState(() {
                  _start = 0;
                });
              }
            }
          } else {
            // if no users nearby
            _stateUpdateTimer?.cancel();
            Dialogs.showNoUserCloseDialog(context);
          }
        })
      },
    );

    ServerComms.messageToServer("HELP");
  }

  /// start a timer of 5 minutes and opens dialog if no users has accepted the request
  void showDialogAfter5Minutes() {
    const duration = Duration(minutes: 5);
    _timer = Timer.periodic(
      duration,
      (Timer timer) {
        Dialogs.showNoUserHasAcceptedRequestDialog(context);
        print('no user has accepted');
        timer.cancel();
      },
    );
  }

  // call if server send message 'NO_USERS_NEARBY'
  noUserNearby() {
    _users.clear();
  }

  static helperAmountUpdate(int diff, String id, LatLng gps) {
    switch (diff) {
      case -1:
        for (int i = 0; i < _helpers.length; i++) {
          if (_helpers[i].key.toString() == "[<'$id'>]") {
            _helpers.remove(_helpers[i]);
          }
        }
        break;
      case 0:
        for (int i = 0; i < _helpers.length; i++) {
          if (_helpers[i].key.toString() == "[<'$id'>]") {
            _helpers.remove(_helpers[i]);
            _helpers.add(newHelper(id, gps));
          }
        }
        break;
      case 1:
        _helpers.add(newHelper(id, gps));

        break;
      default:
        throw Exception("Invalid input! the int diff value must be -1, 0 or 1");
        break;
    }
    getLatLng().then((usersLatLng) {
      _markers = getMarkers(_helpers, usersLatLng);
    });
  }

  static Future<LatLng> getLatLng() async {
    var location = GpsHandler.gps;
    return LatLng(location.latitude!, location.longitude!);
  }

  @override
  Widget build(BuildContext context) {
    String usersLocation =
        GpsHandler.gps.toString().replaceAll(RegExp('[,>]'), '');
    List<String> dataList = usersLocation.toString().split(' ');
    var lat = double.parse(dataList[1]);
    var lng = double.parse(dataList[3]);

    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Haluatko lopettaa avunpyynnön?'),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('En'),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _markers.clear();
                        _helpers.clear();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Kyllä')),
                ],
              );
            });
        if (value != null) {
          return Future.value(value);
        } else {
          return Future.value(false);
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Avunpyyntö päällä\n\n Hyväksynyt: ${_helpers.length} henkilöä',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xff3c4d62),
            centerTitle: true,
            toolbarHeight: 100,
          ),
          body: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  minZoom: 6,
                  maxZoom: 18,
                  center: LatLng(lat, lng),
                  zoom: 11.0,
                ),
                children: [
                  TileLayer(urlTemplate: getSummerOrWinterMap()),
                  MarkerLayer(markers: _markers)
                ],
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.my_location),
                    onPressed: () {
                      _mapController.moveAndRotate(
                          LatLng(lat, lng), _mapController.zoom, 0);
                    },
                  )),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () async {
                    final value = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Haluatko lopettaa avunpyynnön?'),
                            actions: [
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('En'),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    _markers.clear();
                                    _helpers.clear();
                                    /* Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(builder: (context) => const MapTracking()), (route) => false);*/
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Kyllä')),
                            ],
                          );
                        });
                    if (value != null) {
                      return Future.value(value);
                    } else {
                      return Future.value(false);
                    }
                  },
                  child: const Text(
                    'Lopeta avun hälyttäminen',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3c4d62),
                      fixedSize: const Size(200, 75),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
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
      ),
    );
  }

  static String getSummerOrWinterMap() {
    if (Utility.getSummerOrWinter()) {
      return "https://api.maptiler.com/maps/winter/256/{z}/{x}/{y}.png?key=vIqtYxkJALvxfiyLqutC";
    }
    return "https://api.maptiler.com/maps/outdoor/256/{z}/{x}/{y}.png?key=vIqtYxkJALvxfiyLqutC";
  }

  static Marker newHelper(String id, LatLng gps) {
    return Marker(
      key: Key(id),
      width: 45.0,
      height: 20.0,
      point: gps,
      builder: (ctx) => Container(
        width: 1.0,
        height: 1.0,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 60, 77, 98),
        ),
        child: const Align(
          alignment: Alignment.center,
          child: Text(
            'Avunantaja',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 8.0,
            ),
          ),
        ),
      ),
    );
  }

  static List<Marker> getMarkers(List<Marker> helpers, LatLng usersLatLng) {
    List<Marker> markers = [];
    markers.addAll(helpers);
    markers.add(Marker(
      point: usersLatLng,
      builder: (ctx) => Container(
          width: 1.0,
          height: 1.0,
          child: const Icon(
            Icons.person_pin_circle,
            size: 40,
          )),
    ));
    return markers;
  }
}

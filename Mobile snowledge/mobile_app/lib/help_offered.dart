import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_app/side_bar/gps_handler.dart';
import 'package:mobile_app/side_bar/server_communications.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'helper/utility.dart';
import 'main_page.dart';
import 'package:provider/provider.dart';
import '../state/appState.dart';
import '../translations/translations.dart';

class HelpOffered extends StatefulWidget {
  const HelpOffered(this.payload, this.pushUp, {Key? key}) : super(key: key);
  final String? payload;
  final bool?
      pushUp; // true if coming from a push up notification or false if coming from the in-app notification

  @override
  State<HelpOffered> createState() => HelpOfferedState();
}

class HelpOfferedState extends State<HelpOffered> {
  final MapController _mapController = MapController();
  bool _accepted = false;
  static bool _pageOpen = false;

  static bool get pageOpen => _pageOpen;
  static late Timer _stateUpdateTimer;
  static List<Marker> _markers = [];
  static LatLng _toBeHelpedLatLng = LatLng(0, 0);

  static late String _distance;
  @override
  initState() {
    if (!widget.pushUp!) {
      ServerComms.messageToServer('HELP_RESPONSE:1');

      setState(() {
        _accepted = true;
      });
    }
    _pageOpen = true;
    List<String> payloadparts = widget.payload!.split(':');
    _distance = payloadparts[1];
    List<String> gpsParts = payloadparts[0].split(',');
    _toBeHelpedLatLng =
        LatLng(double.parse(gpsParts[0]), double.parse(gpsParts[1]));
    super.initState();
    _stateUpdateTimer = Timer.periodic(
      const Duration(seconds: 2),
      (Timer t) => {
        getLatLng().then((usersLatLng) {
          setState(() {
            _markers = getMarkers(usersLatLng, _toBeHelpedLatLng);
          });
        })
      },
    );
  }

  @override
  void dispose() {
    if (_accepted) {
      ServerComms.messageToServer('DECLINE');
    }
    _pageOpen = false;
    _stateUpdateTimer.cancel();
    super.dispose();
  }

  static void setToBeHelpedLatLng(LatLng toBeHelpedLatLng) {
    _toBeHelpedLatLng = toBeHelpedLatLng;
  }

  Future<LatLng> getLatLng() async {
    var location = await GpsHandler.gps;
    return LatLng(location.latitude!, location.longitude!);
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
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
                title: Text(translations['cancelHelp'][appState.language]),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(translations['no'][appState.language]),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        ServerComms.messageToServer('DECLINE');
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainPage()),
                            (route) => false);
                      },
                      child: Text(translations['yes'][appState.language])),
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
              _accepted
                  ? translations['helpMode'][appState.language]
                  : translations['userReqDist1'][appState.language] +
                      _distance +
                      translations['userReqDist2'][appState.language],
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.red[200],
            centerTitle: true,
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
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _accepted ? returnbutton() : decisionbuttons(),
                  ),
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

  List<Widget> decisionbuttons() {
    var appState = Provider.of<AppState>(context);
    return <Widget>[
      ElevatedButton(
        onPressed: () {
          ServerComms.messageToServer('HELP_RESPONSE:0');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
              (route) => false);
        },
        child: Text(
          translations['decline'][appState.language],
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
            backgroundColor: Colors.red[200],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
      ElevatedButton(
        onPressed: () {
          ServerComms.messageToServer('HELP_RESPONSE:1');
          setState(() {
            _accepted = true;
          });
        },
        child: Text(
          translations['accept'][appState.language],
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
            backgroundColor: Colors.green[200],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
    ];
  }

  List<Widget> returnbutton() {
    var appState = Provider.of<AppState>(context);
    return <Widget>[
      ElevatedButton(
        onPressed: () async {
          final value = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(translations['stopHelpQuery'][appState.language]),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(translations['no'][appState.language]),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainPage()),
                              (route) => false);
                        },
                        child: Text(translations['yes'][appState.language])),
                  ],
                );
              });
          if (value != null) {
            return Future.value(value);
          } else {
            return Future.value(false);
          }
        },
        child: Text(
          translations['stopHelp'][appState.language],
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[200],
            fixedSize: const Size(200, 75),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
    ];
  }

  List<Marker> getMarkers(LatLng usersLatLng, LatLng toBeHelpedLatLng) {
    return [
      getToBeHelpedMarker(usersLatLng),
      Marker(
        width: 45.0,
        height: 20.0,
        point: toBeHelpedLatLng,
        builder: (BuildContext ctx) => Container(
          width: 1.0,
          height: 1.0,
          decoration: const BoxDecoration(
            color: Color.fromARGB(250, 239, 154, 154),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              translations['helper']
                  [Provider.of<AppState>(ctx, listen: false).language],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 8.0,
              ),
            ),
          ),
        ),
      )
    ];
  }

  static Marker getToBeHelpedMarker(LatLng usersLatLng) {
    return Marker(
      width: 50.0,
      height: 30.0,
      point: usersLatLng,
      builder: (BuildContext ctx) => Container(
        width: 1.0,
        height: 1.0,
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            translations['Userlocation']
                [Provider.of<AppState>(ctx, listen: false).language],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 8.0,
            ),
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
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_app/bottom_bar/state/setSharingLocation.dart';
import 'package:mobile_app/help_need_over.dart';
import 'package:mobile_app/map_tracking.dart';
import 'package:mobile_app/side_bar/side_bar.dart';
import 'package:mobile_app/widgets/dialogs.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

import 'package:dart_ipify/dart_ipify.dart';
import '../help_needed_mode.dart';
import '../help_offered.dart';
import '../main.dart';
import '../notification_handler.dart';
import '../state/appState.dart';
import 'gps_handler.dart';

class ServerComms {
  static late Timer _timer;
// RawDatagramSocket.bind(InternetAddress.anyIPv6, 50943)
  static bool _isOfferingHelp = false;
  // static late Future<RawDatagramSocket> rDgS;
  // static late String address;

  static Future<RawDatagramSocket> initRDgS() {
    Future<RawDatagramSocket> rDgS =
        RawDatagramSocket.bind(InternetAddress.anyIPv4, 50943);
    supportsIPv6().then((supportIPv6) {
      if (supportIPv6) {
        rDgS = RawDatagramSocket.bind(InternetAddress.anyIPv6, 50943);
      }
    });
    return rDgS;
  }

  static Future<String> initAddress() async {
    var response = await InternetAddress.lookup('dev.lumisovellus.fi',
        type: InternetAddressType.IPv4);
    var address = response[0].address;
    supportsIPv6().then((supportIPv6) async {
      if (supportIPv6) {
        response = await InternetAddress.lookup('dev.lumisovellus.fi',
            type: InternetAddressType.IPv6);
        address = response[0].address;
      }
    });
    return address;
  }

  static Future<String> initAddressLocal() async {
    String address = "10.0.2.2";
    return address;
  }

  static Future<bool> supportsIPv6() {
    return NetworkInterface.list().then((interfaces) {
      for (var interface in interfaces) {
        for (var address in interface.addresses) {
          if (address.type == InternetAddressType.IPv6) {
            return true;
          }
        }
      }
      return false;
    });
  }

  ///Starts a timer. Avoid calling this again second time, before calling the stopSendingLocationMessages() method.
  static void startSendingLocationMessages() {
    if (SetSharingLocationState.gpsSwitchState) {
      messageToServer("LOCATION");
    }
    _timer = Timer.periodic(
      const Duration(seconds: 15),
      (Timer t) => {_listenServerTimerInsides(5)},
    );
  }

  static void _listenServerTimerInsides(int minutesBetweenLocationMessages) {
    // print(_timer.tick);
    if (SetSharingLocationState.gpsSwitchState) {
      if ((_timer.tick % (4 * minutesBetweenLocationMessages) == 0) ||
          _isOfferingHelp &&
              _timer.tick % (1 * minutesBetweenLocationMessages) == 0) {
        messageToServer("LOCATION");
      } else {
        messageToServer("KEEP_ALIVE");
      }
    }
  }

  static void stopSendingLocationMessages() {
    _timer.cancel();
  }

  static void startListeningServer(BuildContext context) {
    // static void startListeningServer() {
    // listenServer();
    listenServer(context);
  }

  static void receiveRequestsOnStart() {
    messageToServer('REQUEST_INIT');
  }

  // Constructing different messages to server
  static messageToServer(String messagetype) async {
    if (await Permission.location.isGranted) {
      String devId = await _getDeviceID();

      String message;
      // print('Printing from server comms: $messagetype');
      switch (messagetype) {
        case 'REQUEST_INIT':
          await GpsHandler.startUpdatingGpsVariable();
          List<String> list = await getTimeFNameLNameGps();
          message =
              '$messagetype:${list[0]}:$devId:${list[1]}:${list[2]}:${list[3]}:${list[4]}';
          await GpsHandler.stopUpdatingGpsVariable();
          break;
        case 'LOCATION':
          List<String> list = await getTimeFNameLNameGps();
          saveLastLocationTimeToSharedPreference();
          message =
              '$messagetype:${list[0]}:$devId:${list[1]}:${list[2]}:${list[3]}:${list[4]}';
          break;
        case 'HELP':
          // Get the type of help needed (equipment, health, lost)
          List<String> list = await getTimeFNameLNameGps();
          String helpNeed = Dialogs().getMinorHelpCondition();
          message = '$messagetype:${list[0]}:$devId:${list[3]}:$helpNeed';
          break;
        case 'HELP_DELETE':
          message = '$messagetype:$devId';
          break;
        case "HELP_RESPONSE:0":
          var messageParts = messagetype.split(':');
          message = '${messageParts[0]}:$devId:${messageParts[1]}';
          break;
        case "HELP_RESPONSE:1":
          _isOfferingHelp = true;
          var messageParts = messagetype.split(':');
          message = '${messageParts[0]}:$devId:${messageParts[1]}';
          break;
        case "DECLINE":
          _isOfferingHelp = false;
          message = '$messagetype:$devId';
          break;
        case "KEEP_ALIVE":
          message = '$messagetype:123';
          break;
        default:
          message = "invalid messagetype";
          break;
      }
      print(message);

      initRDgS().then(
        (RawDatagramSocket udpSocket) async {
          udpSocket.writeEventsEnabled = true;
          List<int> data = utf8.encode(message);
          // udpSocket.send(data, InternetAddress(await initAddress()), 50943);
          udpSocket.send(
              data, InternetAddress(await initAddressLocal()), 50943);
        },
      );
    } else {
      print(
          "FAILED TO SEND MESSAGE BECAUSE OF THERE IS NO GPS PERMISSIONS GRANTED");
    }
  }

  // Get the ID of device to add into the help message
  static _getDeviceID() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String? devId = "notSet";
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      devId = build.androidId;
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      devId = data.identifierForVendor;
    }
    return devId;
  }

  static listenServer(BuildContext context) async {
    var appState = Provider.of<AppState>(context);
    initRDgS().then((RawDatagramSocket udpSocket) async {
      udpSocket.readEventsEnabled = true;
      // String address = await initAddress();
      String address = await initAddressLocal();
      String result;
      udpSocket.listen((event) async {
        print("phone listening: ${event}");
        if (event == RawSocketEvent.read) {
          Datagram? dg = udpSocket.receive();
          result = utf8.decode(dg!.data);
          List<String> resultParts = result.split(':');
          switch (resultParts[0]) {
            case "HELPER_ACCEPTED":
              // New helper accepted the help request
              //HELPER_ACCEPTED:ID:GPS
              List<String> res2 = resultParts[2].split(',');
              HelpNeededState.helperAmountUpdate(1, resultParts[1],
                  LatLng(double.parse(res2[0]), double.parse(res2[1])));
              break;
            case "HELPER_UPDATED":
              // Update current helpers
              //HELP_UPDATED:ID:GPS
              List<String> res2 = resultParts[2].split(',');
              HelpNeededState.helperAmountUpdate(0, resultParts[1],
                  LatLng(double.parse(res2[0]), double.parse(res2[1])));
              break;
            case "HELPER_WITHDRAWN":
              // A helper withdrawn the help request
              //HELP_WITHDRAWN:ID
              HelpNeededState.helperAmountUpdate(
                  -1, resultParts[1], LatLng(0, 0));
              NotificationHandler.cancelPushUpNotification();
              NotificationHandler.helperCancelledAcceptanceNotification();
              break;
            case "HELP_TARGET_UPDATE":
              print(
                  "=================== PRINT FROM HELP_TARGET_UPDATE =========================");
              //HELP_TARGET_UPDATE:ID:GPS
              List<String> res2 = resultParts[2].split(',');
              String devId = await _getDeviceID();
              if (resultParts[1] == devId) {
                HelpOfferedState.setToBeHelpedLatLng(
                    LatLng(double.parse(res2[0]), double.parse(res2[1])));
              }
              break;
            case "NOTIFY":
              // Notify the device when there is a helper accepted the help request
              //NOTIFY:ID:GPS:DISTANCE:
              print("Notify!");
              appState.setNumOfHelpRequest = 1;
              String devId = await _getDeviceID();
              if (resultParts[1] == devId) {
                await NotificationHandler.pushUpNotification(
                    resultParts[2], resultParts[3]);
                String payload = resultParts[2] + ':' + resultParts[3];
                await Dialogs.showHelpRequestedDialog(
                    MyApp.navigatorKey.currentState?.context, payload);
              }
              break;

            case "NO_USERS_NEARBY":
              HelpNeededState().noUserNearby();
              break;
            case "HELP_OVER":
              print("help over!");
              // HELP_OVER:ID
              appState.setNumOfHelpRequest = -1;
              String devId = await _getDeviceID();
              if (resultParts[1] == devId) {
                NotificationHandler.cancelPushUpNotification();
                NotificationHandler.helpRequestCancelledNotification();
                try {
                  if (HelpOfferedState.pageOpen) {
                    await MyApp.navigatorKey.currentState?.push(
                        MaterialPageRoute(
                            builder: (context) => const MapTracking()));
                    await Dialogs.showHelpNeedOverDialog(
                        MyApp.navigatorKey.currentState?.context);
                  }
                } catch (e) {
                  // print(e.toString());
                }
              }
              break;
            default:
              // print("invalid message: $result");
              return;
          }
        }
      }, onError: (error) {
        // print("server listening error: $error");
      }, onDone: () {
        // print("server listening done!");
      }, cancelOnError: true);
    });
  }

  static Future<List<String>> getTimeFNameLNameGps() async {
    var prefs = await SharedPreferences.getInstance();
    String fName = prefs.getString('fName')!;
    String lName = prefs.getString('lName')!;
    String pNumber = prefs.getString('pNumber') ?? 'ei puhelinnumeroa';
    int time = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    var gps = GpsHandler.gps;
    String _gps = '${gps.latitude},${gps.longitude}';
    // time, first name, last name, gps, phone number
    return [time.toString(), fName, lName, _gps, pNumber];
  }

  // Save the last location and time to the app's shared preference
  static saveLastLocationTimeToSharedPreference() {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((pref) {
      pref.setString('lastLocationTime', DateTime.now().toString());
    });
  }
}

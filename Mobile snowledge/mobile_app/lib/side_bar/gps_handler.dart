import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/bottom_bar/state/setSharingLocation.dart';
import 'package:mobile_app/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';

import '../state/appState.dart';

class GpsHandler {
  static late Timer _timer;
  static Location _location = new Location();
  static late LocationData _gps;
  static LocationData get gps => _gps;

  static StreamSubscription<LocationData> listener =
      _location.onLocationChanged.listen((event) {});

  // for use in main view in the continually updating map
  static Stream<LocationData> getCoordinates() async* {
    yield* _location.onLocationChanged;
  }

  ///Starts a timer. Avoid calling this again second time, before calling the stopUpdatingGpsVariable() method.
  static Future<void> startUpdatingGpsVariable() async {
    _gps = await _location.getLocation();
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (Timer t) async => {updateGpsVariable()},
    );
  }

  static Future<void> stopUpdatingGpsVariable() async {
    _timer.cancel();
  }

  static Future<void> updateGpsVariable({bool ignoreSwitch = false}) async {
    if (SetSharingLocationState.gpsSwitchState || ignoreSwitch) {
      _gps = await _location.getLocation();
    }
  }

  ///tries to set gps setting and returns the value that the setting ends up being.
  ///If insistAlwaysOn = false, make sure that setGpsSetting(false) is run after using the gps, to avoid unexpected behaviour.
  static Future<bool> setGpsSetting(context, bool value,
      {bool insistAlwaysOn = false}) async {
    // _userInAppSettings = false;
    bool result = false;
    //gps services state and permissions
    if (value) {
      if (await checkGpsService()) {
        if (insistAlwaysOn) {
          _location.enableBackgroundMode(enable: true);
          if (await checkAndAskGpsAlwaysOnPermission(context)) {
            _saveGpsSetting(true);
            //gps always on background permissions granted => gps ON until turned off
            result = true;
          }
        } else {
          if (!await Permission.location.isGranted) {
            await Permission.location.request();
            if (await Permission.location.isGranted) {
              //permissions were not denied, => permissions granted and gps is ON for now.
              result = true;
            } else {
              result = await Dialogs.showGPSDialog(
                  context,
                  false,
                  'Sovellus tarvitsee paikannukseen luvan käyttää sijaintia.\n\nSallitko sijaintiedon keräämisen?',
                  "Etene antamaan GPS luvat");
            }
          } else {
            result = true;
          }
        }
      }
    } else {
      _saveGpsSetting(false);
    }
    return result;
  }

  static Future<bool> checkAndAskGpsAlwaysOnPermission(context) async {
    var appState = Provider.of<AppState>(context, listen: false);
    //check permission
    if (!await Permission.locationAlways.isGranted) {
      if (Platform.isAndroid) {
        int androidVersion = int.parse((await DeviceInfoPlugin().androidInfo)
            .version
            .release!
            .split('.')[0]);
        if (androidVersion > 10) {
          return await _askWhenInUseAndThenAlwaysLocationPermission(
              context,
              !appState.isEnglish
                  ? ('Sovellus tarvitsee luvan käyttää sijaintia myös näytön ollessa kiinni.' +
                      '\n\nSallitko sijaintiedon keräämisen sovelluksen ollessa taustalla?' +
                      '\n\n->Sijainti: Salli aina')
                  : ('The application needs permission to use the location even when the screen is closed.' +
                      '\n\nDo you allow the collection of location data when the app is running in the background?' +
                      "\n\n->Location: Always Allow"),
              !appState.isEnglish ? "Siirry asetuksiin" : "Go to Settings");
        } else if (androidVersion == 10) {
          return await _askWhenInUseAndThenAlwaysLocationPermission(
              context,
              !appState.isEnglish
                  ? ('Sovellus tarvitsee luvan käyttää sijaintia myös näytön ollessa kiinni.' +
                      '\n\nSallitko sijaintiedon keräämisen sovelluksen ollessa taustalla?' +
                      '\n\n->Sijainti: Salli aina')
                  : ('The application needs permission to use the location even when the screen is closed.' +
                      '\n\nDo you allow the collection of location data when the app is running in the background?' +
                      "\n\n->Location: Always Allow"),
              !appState.isEnglish ? "Seuraava" : "Continue");
        } else {
          await Permission.locationAlways.request();
          return await Permission.locationAlways.isGranted;
        }
      } else if (Platform.isIOS) {
        return await _askWhenInUseAndThenAlwaysLocationPermission(
            context,
            !appState.isEnglish
                ? ('Sovellus tarvitsee luvan käyttää sijaintia myös näytön ollessa kiinni.' +
                    '\n\nSallitko sijaintiedon keräämisen sovelluksen ollessa taustalla?' +
                    '\n\n->Sijainti: Salli aina')
                : ('The application needs permission to use the location even when the screen is closed.' +
                    '\n\nDo you allow the collection of location data when the app is running in the background?' +
                    "\n\n->Location: Always Allow"),
            !appState.isEnglish ? "Seuraava" : "Continue");
      } else {
        throw ErrorDescription("The platform must be either Android or IOS!");
      }
    }
    return true;
  }

  static Future<bool> _askWhenInUseAndThenAlwaysLocationPermission(
      BuildContext context, String dialogMessage, String buttonText) async {
    await Permission.locationWhenInUse.request();
    if (!(await Permission.locationWhenInUse.isGranted)) {
      return false;
    }
    return await Dialogs.showGPSDialog(
        context, true, dialogMessage, buttonText);
  }

  ///check if phones gps is on
  static Future<bool> checkGpsService() async {
    //check serviceEnabled
    var serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }
    return true;
  }

  ///just reads the sharedPreferences value "isSharingLocation"
  static Future<bool> loadGpsSetting() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var loadedSetting = sharedPreferences.getBool("isSharingLocation");
    return loadedSetting ?? false;
  }

  ///save gps setting of the app
  static void _saveGpsSetting(bool value) async {
    //saves the setting
    if (value) {
      listener = _location.onLocationChanged.listen((event) {});
    } else {
      listener.cancel();
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool("isSharingLocation", value);
  }
}

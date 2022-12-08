import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../help_needed_mode.dart';
import '../main_page.dart';
import '../open_112app.dart';
import '../side_bar/gps_handler.dart';
import '../side_bar/server_communications.dart';
import '../state/appState.dart';
import 'dialogs.dart';

class Buttons {
  String locationMessage = 'LOCATION';
  /// Help button
  ElevatedButton helpButton(bool gpsSettingIsOff, BuildContext contx, String text, Color color) {
    return ElevatedButton(
      onPressed: () async {
        if (gpsSettingIsOff) {
          GpsHandler.setGpsSetting(contx, true, insistAlwaysOn: false)
              .then((gpsOn) async {
            if (gpsOn) {
              if (text == 'Soita 112') {
                open112();
                await GpsHandler.updateGpsVariable(ignoreSwitch: true);
                await ServerComms.messageToServer(locationMessage);
                Navigator.of(contx).push(
                    MaterialPageRoute(builder: (contx) => const HelpNeeded(true)));
              }
              if (text == 'Avunpyyntö') {
                Dialogs().showDialogMinorHelpQuestions(contx);
                await GpsHandler.updateGpsVariable(ignoreSwitch: true);
                await ServerComms.messageToServer(locationMessage);
              }
            } else {
              showDialog<bool>(
                  context: contx,
                  builder: (contx) {
                    return AlertDialog(
                      title: const Text(
                          'Toiminto vaatii luvan käyttää laitteen GPS:ää'),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(contx),
                          child: const Text('Ok'),
                        ),
                      ],
                    );
                  });
            }
          });
        } else {
          await ServerComms.messageToServer(locationMessage);
          if (text == 'Soita 112') {
            open112();
            Navigator.of(contx).push(
              MaterialPageRoute(builder: (contx) => const HelpNeeded(true)));
          }

          if (text == 'Avunpyyntö') {
            Dialogs().showDialogMinorHelpQuestions(contx);
          }
        }
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.all(20.0),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
    );
  }

  /// Cancel button
  static ElevatedButton cancelButton(BuildContext context, String type) {
    return ElevatedButton(
      onPressed: () {
        if (type == 'help_request') {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (type == 'location'){
          var appState = Provider.of<AppState>(context, listen: false);
          Navigator.of(context).pop();
          appState.setPageIndex = 1;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainPage()),
                  (route) => false);
        }
      },
      child: const Text(
        'Peruuta',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(20.0),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
    );
  }

  /// Go to settings button
  static ElevatedButton goToSettingsButton(BuildContext context, bool insistAlwaysOn, bool result, String buttonText) {
    var appState = Provider.of<AppState>(context, listen: false);
    return ElevatedButton(
        onPressed: () async {
          if (insistAlwaysOn) {
            await Permission.locationAlways.request();
            if (!(await Permission
                .locationAlways.isGranted)) {
              if (await openAppSettings()) {
                appState.setUserInAppSettings = true;
              }
            }
            result =
            await Permission.locationAlways.isGranted;
            Navigator.pop(context);
          } else {
            await Permission.location.request();
            if (!(await Permission.location.isGranted)) {
              if (await openAppSettings()) {
                appState.setUserInAppSettings = true;
              }
            }
            result = await Permission.location.isGranted;
            Navigator.pop(context);
          }
        },
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4B6DD7),
          padding: const EdgeInsets.all(20.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50))),
    );
  }


   static ElevatedButton confirmButton(BuildContext context, String text, {VoidCallback? onPressed}) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(20.0),
          side: const BorderSide(
              width: 3, // the thickness
              color: Colors.white // the color of the border
          ),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
    );
  }

  static ElevatedButton onboardingButton(BuildContext context, String text, {VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 40.0),
          side: const BorderSide(
              width: 3, // the thickness
              color: Colors.white // the color of the border
          ),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
    );
  }

  static TextButton refuseLocationPermissionButton(BuildContext context, {VoidCallback? onPressed}) {
    return TextButton(
        onPressed: onPressed,
        child: const Text(
          'Älä salli sijaintia',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
    );
  }
}
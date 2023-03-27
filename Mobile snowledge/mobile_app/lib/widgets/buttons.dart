import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../help_needed_mode.dart';
import '../help_offered.dart';
import '../main.dart';
import '../main_page.dart';
import '../open_112app.dart';
import '../side_bar/gps_handler.dart';
import '../side_bar/server_communications.dart';
import '../state/appState.dart';
import 'dialogs.dart';
import '../translations/translations.dart';

class Buttons {
  String locationMessage = 'LOCATION';

  /// Help button
  ElevatedButton helpButton(
      bool gpsSettingIsOff, BuildContext contx, String text, Color color) {
    var appState = Provider.of<AppState>(contx);
    return ElevatedButton(
      onPressed: () async {
        if (gpsSettingIsOff) {
          GpsHandler.setGpsSetting(contx, true, insistAlwaysOn: false)
              .then((gpsOn) async {
            if (gpsOn) {
              if (text == translations['call112'][appState.language]) {
                open112();
                await GpsHandler.updateGpsVariable(ignoreSwitch: true);
                await ServerComms.messageToServer(locationMessage);
                Navigator.of(contx).push(MaterialPageRoute(
                    builder: (contx) => const HelpNeeded(true)));
              }
              if (text == translations['helpReq'][appState.language]) {
                Dialogs().showDialogMinorHelpQuestions(contx);
                await GpsHandler.updateGpsVariable(ignoreSwitch: true);
                await ServerComms.messageToServer(locationMessage);
              }
            } else {
              showDialog<bool>(
                  context: contx,
                  builder: (contx) {
                    return AlertDialog(
                      title:
                          Text(translations['funcNeedsGps'][appState.language]),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(contx),
                          child: Text(translations['ok'][appState.language]),
                        ),
                      ],
                    );
                  });
            }
          });
        } else {
          await ServerComms.messageToServer(locationMessage);
          if (text == translations['call112'][appState.language]) {
            open112();
            Navigator.of(contx).push(
                MaterialPageRoute(builder: (contx) => const HelpNeeded(true)));
          }

          if (text == translations['helpReq'][appState.language]) {
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
  static ElevatedButton cancelButton(
      BuildContext context, String text, String type) {
    return ElevatedButton(
      onPressed: () {
        if (type == 'help_request') {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (type == 'location') {
          var appState = Provider.of<AppState>(context, listen: false);
          Navigator.of(context).pop();
          appState.setPageIndex = 1;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
              (route) => false);
        } else if (type == 'offer_help') {
<<<<<<< HEAD
          Dialogs.helpRequestedDialogOpen = false;
=======
          ServerComms.messageToServer('HELP_RESPONSE:0');
>>>>>>> cd61f7f8a01e816a0f021cce87d42741acd15f94
          Navigator.pop(context);
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
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(20.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
    );
  }

  static ElevatedButton giveHelpButton(BuildContext context, String? payload) {
    var appState = Provider.of<AppState>(context);
    return ElevatedButton(
        onPressed: () async => {
              await MyApp.navigatorKey.currentState?.push(MaterialPageRoute(
                  builder: (context) => HelpOffered(payload, false))),
              Dialogs.helpRequestedDialogOpen = false
            },
        child: Text(
          translations['help'][appState.language],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffd99222),
            padding: const EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))));
  }

  /// Go to settings button
  static ElevatedButton goToSettingsButton(BuildContext context,
      bool insistAlwaysOn, bool result, String buttonText) {
    var appState = Provider.of<AppState>(context, listen: false);
    return ElevatedButton(
      onPressed: () async {
        if (insistAlwaysOn) {
          await Permission.locationAlways.request();
          if (!(await Permission.locationAlways.isGranted)) {
            if (await openAppSettings()) {
              appState.setUserInAppSettings = true;
            }
          }
          result = await Permission.locationAlways.isGranted;
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
    );
  }

  static ElevatedButton confirmButton(BuildContext context, String text,
      {VoidCallback? onPressed}) {
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

  static ElevatedButton onboardingButton(BuildContext context, String text,
      {VoidCallback? onPressed}) {
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

  static TextButton refuseLocationPermissionButton(
      BuildContext context, String text,
      {VoidCallback? onPressed}) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
      ),
    );
  }

  static IconButton crossIconButton(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.close_rounded, size: 50, color: Colors.white));
  }

  static FloatingActionButton showRescueChatButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        Dialogs().showRescueChatDialog(context);
      },
      child: Icon(Icons.chat),
    );
  }
}

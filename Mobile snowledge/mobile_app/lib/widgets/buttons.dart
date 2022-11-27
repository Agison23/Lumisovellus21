import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/dialogs.dart';

import '../help_needed_mode.dart';
import '../open_112app.dart';
import '../side_bar/gps_handler.dart';
import '../side_bar/server_communications.dart';

class Buttons {
  // Help button
  String locationMessage = 'LOCATION';
  ElevatedButton helpButton(
      bool gpsSettingIsOff, BuildContext contx, String text, Color color) {
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
          }
          Navigator.of(contx).push(
              MaterialPageRoute(builder: (contx) => const HelpNeeded(true)));
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
}

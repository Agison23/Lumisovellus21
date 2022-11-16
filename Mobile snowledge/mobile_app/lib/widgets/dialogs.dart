import 'package:flutter/material.dart';
import 'package:mobile_app/bottom_bar/state/setSharingLocation.dart';
import 'package:mobile_app/helper/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../side_bar/gps_handler.dart';
import '../../widgets/buttons.dart';

class Dialogs {
  /// Open the help needed dialog
  Future showHelpNeededDialog(context) async {
    return await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                const Text(
                  'Millaista apua tarvitset?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    'Vakavassa hädässä, soita aina hätänumeroon 112.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Avunpyyntö-painike ilmoittaa sijaintisi ja avuntarpeesi lähialueen käyttäjille.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<bool?>(
                        future: GpsHandler.loadGpsSetting(),
                        builder: (context, _snapshot) {
                          return Buttons().helpButton(
                              !(_snapshot.data ?? false),
                              context,
                              'Soita 112',
                              const Color(0xFFDA7272));
                        }),
                    FutureBuilder<bool?>(
                        future: GpsHandler.loadGpsSetting(),
                        builder: (context, _snapshot) {
                          return Buttons().helpButton(
                              !(_snapshot.data ?? false),
                              context,
                              'Avunpyyntö',
                              const Color(0xFF7281DA));
                        })
                  ],
                ),
              ]);
            },
          ),
        );
      },
    );
  }

  /// Open the sharing location dialog
  Future showDialogSharingLocation(context) async {
    var prefs = await SharedPreferences.getInstance();
    return await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                const Text(
                  'Sijaintitiedon jakaminen',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    'Sovellus kerää tietoja sijainnistasi. Tarvitsemme sijaintiasi auttaaksemme sinua hätätilanteen sattuessa. Voit koska tahansa poistaa sijainnin käytöstä.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                      child: Text(
                        'Sijainnin lähettäminen',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SetSharingLocation(),
                  ],
                ),
                const SizedBox(height: 20),
                prefs.getString('lastLocationTime') != null
                    ? Text(
                        'Viimeinen sijaintitieto lähetetty: \n'
                        "${Utility.getTimeAgo(prefs.getString('lastLocationTime'))}"
                        ' sitten',
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      )
                    : const SizedBox()
              ]);
            },
          ),
        );
      },
    );
  }

  Future showDialogMinorHelpQuestions(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Millaista apua tarvitset?'),
            children: [
              SimpleDialogOption(
                onPressed: () {},
                child: const Text('Varusteongelma'),
              ),
              SimpleDialogOption(
                  onPressed: () {}, child: const Text('Terveysongelma')),
              SimpleDialogOption(
                  onPressed: () {}, child: const Text('Olen eksynyt')),
            ],
          );
        });
  }
}

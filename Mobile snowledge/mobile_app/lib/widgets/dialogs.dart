import 'package:flutter/material.dart';
import 'package:mobile_app/bottom_bar/state/setSharingLocation.dart';
import 'package:mobile_app/helper/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../side_bar/gps_handler.dart';
import '../../widgets/buttons.dart';
import '../help_needed_mode.dart';

class Dialogs {
  static Object? _selectedRadio = 0;
  final String minorHelp1 = 'Varusteongelma';
  final String minorHelp2 = 'Terveysongelma';
  final String minorHelp3 = 'Eksynyt';
  final String seriousHelp = 'Vakava hätä, avunpyytäjä on ohjeistettu soittamaan 112';

  String getMinorHelpCondition() {
    int helpNeed = _selectedRadio as int;
    if (helpNeed == 1) {
      return minorHelp1;
    } else if (helpNeed == 2) {
      return minorHelp2;
    } else if (helpNeed == 3) {
      return minorHelp3;
    } else {
      return seriousHelp;
    }
  }

  // needs to be called when exiting help needed mode to ensure that the minor help dialog works right every time
  static void resetRadioSelection() {
    _selectedRadio = 0;
  }

  Future showDialogMinorHelpQuestions(context) async {
    _selectedRadio = 1;
    return await showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Millaista apua tarvitset?'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min, children: [
                RadioListTile(
                  title: const Text('Varusteongelma'),
                  value: 1,
                  groupValue: _selectedRadio,
                  onChanged: (value) {
                    setState(() => _selectedRadio = value);
                  },
                ),
                RadioListTile(
                  title: const Text('Terveysogelma'),
                  value: 2,
                  groupValue: _selectedRadio,
                  onChanged: (value) {
                    setState(() => _selectedRadio = value);
                  },
                ),
                RadioListTile(
                  title: const Text('Olen eksynyt'),
                  value: 3,
                  groupValue: _selectedRadio,
                  onChanged: (value) {
                    setState(() => _selectedRadio = value);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: (() {
                          resetRadioSelection();
                          Navigator.pop(context);
                        }),
                        child: const Text('Peruuta')),
                    ElevatedButton(
                        onPressed: (() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (contx) => const HelpNeeded(true)));
                        }),
                        child: const Text('Jatka'))
                  ],
                )
              ]);
            }),
          );
        });
  }

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
                    const Color(0xffd99222));
              }),
            FutureBuilder<bool?>(
              future: GpsHandler.loadGpsSetting(),
              builder: (context, _snapshot) {
                return Buttons().helpButton(
                    !(_snapshot.data ?? false),
                    context,
                    'Avunpyyntö',
                    const Color(0xff7c94b6));
              })
                ],
              ),
              const SizedBox(height: 80),
              Buttons.crossIconButton(context)
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
                  : const SizedBox(),
              const SizedBox(height: 80),
              Buttons.crossIconButton(context)
                ]);
            },
          ),
        );
      },
    );
  }

  /// Open dialog when no user close
  static showNoUserCloseDialog(context) async {
    return await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                const Text(
                  'Sovelluksen käyttäjiä ei ole lähistöllä',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    'Voit soittaa 112 tai peruuttaa avunpyyntösi.',
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
                    Buttons.cancelButton(context, 'help_request'),
                    FutureBuilder<bool?>(
                        future: GpsHandler.loadGpsSetting(),
                        builder: (context, _snapshot) {
                          return Buttons().helpButton(
                              !(_snapshot.data ?? false),
                              context,
                              'Soita 112',
                              const Color(0xFFDA7272));
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

  /// Open dialog when no user has accepted the request
  static showNoUserHasAcceptedRequestDialog(context) async {
    return await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                const Text(
                  'Kukaan lähellä oleva käyttäjä ei ole hyväksynyt avunpyyntöäsi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    'Voit soittaa 112 tai peruuttaa avunpyyntösi.',
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
                    Buttons.cancelButton(context, 'help_request'),
                    FutureBuilder<bool?>(
                        future: GpsHandler.loadGpsSetting(),
                        builder: (context, _snapshot) {
                          return Buttons().helpButton(
                              !(_snapshot.data ?? false),
                              context,
                              'Soita 112',
                              const Color(0xFFDA7272));
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

  /// Open dialog if user is not sharing his location
  static Future<bool> showGPSDialog(context, bool insistAlwaysOn,
      String dialogMessage, String buttonText) async {
    bool result = false;
    await showDialog<void>(
        context: context,
        barrierColor: Colors.black.withOpacity(0.9),
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      dialogMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 50),
                    Column(
                      children: [
                        // Go to settings button
                        Buttons.goToSettingsButton(
                            context, insistAlwaysOn, result, buttonText),
                        const SizedBox(height: 10),
                        // Cancel button
                        Buttons.cancelButton(context, 'location')
                      ],
                    )
                  ],
                );
              }));
        });
    return result;
  }

  /// Open dialog when user has deleted the request
  static showHelpNeedOverDialog(context) async {
    return await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min,children: <Widget>[
                const Text(
                  'Avuntarve ohi\nKiitos avusta!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: SizedBox(
                    width: 300,
                    child: Buttons.confirmButton(
                        context,
                        'OK',
                        onPressed: () {
                          Navigator.pop(context);
                        }
                    )),
                )
              ]);
            },
          ),
        );
      },
    );
  }

    static showHelperCancelledAcceptanceDialog(context, int count) async {
    return await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min,children: <Widget>[
                Text(
                  'Auttaja on lopettanut avunannon. Tämänhetkinen auttajien määrä: $count.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: SizedBox(
                    width: 300,
                    child: Buttons.confirmButton(
                        context,
                        'OK',
                        onPressed: () {
                          Navigator.pop(context);
                        }
                    )),
                )
              ]);
            },
          ),
        );
      },
    );
  }

  static showHelpRequestedDialog(context, payload) async {
    return await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                const Text(
                  'Lähellä oleva käyttäjä tarvitsee apua.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    'Voit tarjota apua tai ohittaa pyynnön.',
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
                    Buttons.cancelButton(context, 'offer_help'),
                    FutureBuilder<bool?>(
                        future: GpsHandler.loadGpsSetting(),
                        builder: (context, _snapshot) {
                          return Buttons.giveHelpButton(context, payload);
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
}

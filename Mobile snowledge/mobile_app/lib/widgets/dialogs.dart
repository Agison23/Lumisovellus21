import 'package:flutter/material.dart';
import 'package:mobile_app/bottom_bar/state/setSharingLocation.dart';
import 'package:mobile_app/helper/utility.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../side_bar/gps_handler.dart';
import '../../widgets/buttons.dart';
import '../help_needed_mode.dart';
import '../state/appState.dart';

class Dialogs {
  static Object? _selectedRadio = 0;
  // Minor helps:
  // 1: equipment  problems
  // 2: health problems
  // 3: lost (no direction)
  final String minorHelp1 = 'Varusteongelma';
  final String minorHelp2 = 'Terveysongelma';
  final String minorHelp3 = 'Eksynyt';
  final String seriousHelp =
      'Vakava hätä, avunpyytäjä on ohjeistettu soittamaan 112';

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
    var appState = Provider.of<AppState>(context, listen: false);
    _selectedRadio = 1;
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(!appState.isEnglish
                ? 'Millaista apua tarvitset?'
                : 'What kind of help do you need?'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min, children: [
                RadioListTile(
                  title: Text(!appState.isEnglish
                      ? 'Varusteongelma'
                      : 'Equipment problems'),
                  value: 1,
                  groupValue: _selectedRadio,
                  onChanged: (value) {
                    setState(() => _selectedRadio = value);
                  },
                ),
                RadioListTile(
                  title: Text(!appState.isEnglish
                      ? 'Terveysogelma'
                      : 'Health problems'),
                  value: 2,
                  groupValue: _selectedRadio,
                  onChanged: (value) {
                    setState(() => _selectedRadio = value);
                  },
                ),
                RadioListTile(
                  title:
                      Text(!appState.isEnglish ? 'Olen eksynyt' : "I'm lost"),
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
                        child:
                            Text(!appState.isEnglish ? 'Peruuta' : 'Cancel')),
                    // Press this button will run the help needed mode
                    ElevatedButton(
                        onPressed: (() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (contx) => const HelpNeeded(true)));
                        }),
                        child: Text(!appState.isEnglish ? 'Jatka' : 'Choose'))
                  ],
                )
              ]);
            }),
          );
        });
  }

  /// Open the help needed dialog
  Future showHelpNeededDialog(context) async {
    var appState = Provider.of<AppState>(context, listen: false);
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
                Text(
                  !appState.isEnglish
                      ? 'Millaista apua tarvitset?'
                      : 'What kind of help do you need?',
                  // 'What kind of help do you need?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    !appState.isEnglish
                        ? 'Vakavassa hädässä, soita aina hätänumeroon 112.'
                        : 'In a serious emergency, always call the emergency number 112.',
                    // 'In a serious emergency, always call the emergency number 112.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    !appState.isEnglish
                        ? 'Avunpyyntö-painike ilmoittaa sijaintisi ja avuntarpeesi lähialueen käyttäjille.'
                        : 'The Ask for Help button informs nearby users of your location and your need for help.',
                    // 'The Ask for Help button informs nearby users of your location and your need for help.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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
                              !appState.isEnglish ? 'Soita 112' : 'Call 112',
                              // 'Call 112',
                              const Color(0xffd99222));
                        }),
                    FutureBuilder<bool?>(
                        future: GpsHandler.loadGpsSetting(),
                        builder: (context, _snapshot) {
                          return Buttons().helpButton(
                              !(_snapshot.data ?? false),
                              context,
                              !appState.isEnglish
                                  ? 'Avunpyyntö'
                                  : 'Ask for Help',
                              // 'Ask for Help',
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
    var appState = Provider.of<AppState>(context, listen: false);
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
                Text(
                  !appState.isEnglish
                      ? 'Sijaintitiedon jakaminen'
                      : 'Sharing location information',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    !appState.isEnglish
                        ? 'Sovellus kerää tietoja sijainnistasi. Tarvitsemme sijaintiasi auttaaksemme sinua hätätilanteen sattuessa. Voit koska tahansa poistaa sijainnin käytöstä.'
                        : 'The application collects information about your location. We need your location to help you in an emergency. You can disable location at any time.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                      child: Text(
                        !appState.isEnglish
                            ? 'Sijainnin lähettäminen'
                            : 'Sending Location',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SetSharingLocation(),
                  ],
                ),
                const SizedBox(height: 20),
                prefs.getString('lastLocationTime') != null
                    ? Text(
                        !appState.isEnglish
                            ? 'Viimeinen sijaintitieto lähetetty: \n'
                                "${Utility.getTimeAgo(prefs.getString('lastLocationTime'))}"
                                ' sitten'
                            : 'Last location data sent: \n'
                                "${Utility.getTimeAgo(prefs.getString('lastLocationTime'))}"
                                ' ago',
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
    var appState = Provider.of<AppState>(context, listen: false);
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
                Text(
                  !appState.isEnglish
                      ? 'Sovelluksen käyttäjiä ei ole lähistöllä'
                      : 'There are no users of the application nearby',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    !appState.isEnglish
                        ? 'Voit soittaa 112 tai peruuttaa avunpyyntösi.'
                        : 'You can call 112 or cancel your request for help.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Buttons.cancelButton(
                        context,
                        !appState.isEnglish ? "Peruuta" : "Cancel",
                        'help_request'),
                    FutureBuilder<bool?>(
                        future: GpsHandler.loadGpsSetting(),
                        builder: (context, _snapshot) {
                          return Buttons().helpButton(
                              !(_snapshot.data ?? false),
                              context,
                              !appState.isEnglish ? 'Soita 112' : 'Call 112',
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
    var appState = Provider.of<AppState>(context, listen: false);
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
                Text(
                  !appState.isEnglish
                      ? 'Kukaan lähellä oleva käyttäjä ei ole hyväksynyt avunpyyntöäsi'
                      : 'No nearby user has accepted your help request',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    !appState.isEnglish
                        ? 'Voit soittaa 112 tai peruuttaa avunpyyntösi.'
                        : 'You can call 112 or cancel your request for help.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Buttons.cancelButton(
                        context,
                        !appState.isEnglish ? "Peruuta" : "Cancel",
                        'help_request'),
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
    var appState = Provider.of<AppState>(context, listen: false);
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
                        Buttons.cancelButton(
                            context,
                            !appState.isEnglish ? "Peruuta" : "Cancel",
                            'location')
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
    var appState = Provider.of<AppState>(context, listen: false);
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
                Text(
                  !appState.isEnglish
                      ? 'Avuntarve ohi\nKiitos avusta!'
                      : 'The need for help is over.\nThanks for your help!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: SizedBox(
                      width: 300,
                      child:
                          Buttons.confirmButton(context, 'OK', onPressed: () {
                        Navigator.pop(context);
                      })),
                )
              ]);
            },
          ),
        );
      },
    );
  }

  static showHelperCancelledAcceptanceDialog(context, int count) async {
    var appState = Provider.of<AppState>(context, listen: false);
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
                Text(
                  !appState.isEnglish
                      ? 'Auttaja on lopettanut avunannon. Tämänhetkinen auttajien määrä: $count.'
                      : 'A helper has stopped helping. Current number of helpers: $count.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: SizedBox(
                      width: 300,
                      child:
                          Buttons.confirmButton(context, 'OK', onPressed: () {
                        Navigator.pop(context);
                      })),
                )
              ]);
            },
          ),
        );
      },
    );
  }

  static showHelpRequestedDialog(context, payload) async {
    var appState = Provider.of<AppState>(context, listen: false);
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
                Text(
                  !appState.isEnglish
                      ? 'Lähellä oleva käyttäjä tarvitsee apua.'
                      : 'A nearby user needs help.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    !appState.isEnglish
                        ? 'Voit tarjota apua tai ohittaa pyynnön.'
                        : 'You can offer help or ignore the request.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Buttons.cancelButton(
                        context,
                        !appState.isEnglish ? "Peruuta" : "Cancel",
                        'offer_help'),
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

  Future showRescueChatDialog(context) async {
    var appState = Provider.of<AppState>(context, listen: false);
    return await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Colors.transparent,
            child: Dialog(
              child: SizedBox(
                height: 200,
                width: 300,
                child: Column(
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('This is going to be the rescue chat'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

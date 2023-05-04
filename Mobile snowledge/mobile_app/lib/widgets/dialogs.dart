import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/bottom_bar/state/setSharingLocation.dart';
import 'package:mobile_app/helper/utility.dart';
import 'package:mobile_app/widgets/rescue_chat.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../side_bar/gps_handler.dart';
import '../../widgets/buttons.dart';
import '../help_needed_mode.dart';
import '../state/appState.dart';
import '../side_bar/server_communications.dart';
import '../notification_handler.dart';

import '../translations/translations.dart';

class Dialogs {
  static Object? _selectedRadio = 0;
  static bool helpRequestedDialogOpen = false;
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

  // Open the "What kind of help do you need?" dialog
  Future showDialogMinorHelpQuestions(context) async {
    var appState = Provider.of<AppState>(context, listen: false);
    _selectedRadio = 1;
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(translations['helpQuery'][appState.language]),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min, children: [
                RadioListTile(
                  title: Text(translations['eqptProblem'][appState.language]),
                  value: 1,
                  groupValue: _selectedRadio,
                  onChanged: (value) {
                    setState(() => _selectedRadio = value);
                  },
                ),
                RadioListTile(
                  title: Text(translations['healthIssue'][appState.language]),
                  value: 2,
                  groupValue: _selectedRadio,
                  onChanged: (value) {
                    setState(() => _selectedRadio = value);
                  },
                ),
                RadioListTile(
                  title: Text(translations['lost'][appState.language]),
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
                        child: Text(translations['cancel'][appState.language])),
                    ElevatedButton(
                        onPressed: (() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (contx) => const HelpNeeded(true)));
                        }),
                        child:
                            Text(translations['continue'][appState.language]))
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
                  translations['helpQuery'][appState.language],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    translations['alwaysCall'][appState.language],
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
                    translations['helpButtonDesc'][appState.language],
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
                              translations['call112'][appState.language],
                              const Color(0xffd99222));
                        }),
                    FutureBuilder<bool?>(
                        future: GpsHandler.loadGpsSetting(),
                        builder: (context, _snapshot) {
                          return Buttons().helpButton(
                              !(_snapshot.data ?? false),
                              context,
                              translations['helpReq'][appState.language],
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
    var appState = Provider.of<AppState>(context, listen: false);
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
                Text(
                  translations['gpsSharing'][appState.language],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    translations['fullGpsInfo'][appState.language],
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
                        translations['locSharing'][appState.language],
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
                SizedBox(height: 20),
                prefs.getString('lastLocationTime') != null
                    ? Text(
                        translations['lastShare1'][appState.language] +
                            "${Utility.getTimeAgo(prefs.getString('lastLocationTime'))}" +
                            translations['lastShare2'][appState.language],
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

  // Open dialog when no user close
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
                  translations['noNearUsers'][appState.language],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    translations['callOrCancel'][appState.language],
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
                        translations['cancel'][appState.language],
                        'help_request'),
                    FutureBuilder<bool?>(
                        future: GpsHandler.loadGpsSetting(),
                        builder: (context, _snapshot) {
                          return Buttons().helpButton(
                              !(_snapshot.data ?? false),
                              context,
                              translations['call112'][appState.language],
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
                  translations['notAccepted'][appState.language],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    translations['callOrCancel'][appState.language],
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
                        translations['cancel'][appState.language],
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
                            translations['cancel'][appState.language],
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
                  translations['requestOver1'][appState.language],
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
                  translations['helpOver'][appState.language] + '$count.',
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

  // Open dialog when help requester's request is automatically cancelled
  // Different prompts for help requester and helpers
  static showRequestEndedAutomaticallyDialog(context, String user) async {
    var appState = Provider.of<AppState>(context, listen: false);
    String text = '';
    if (user == 'help_requester') {
      text = translations['requesterReqOverAutomatically'][appState.language];
    } else if (user == 'helper') {
      text = translations['helperReqOverAutomatically'][appState.language];
    }
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
                  text,
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

  static showHelpRequestedDialog(context, payload, batteryLevel) async {
    var appState = Provider.of<AppState>(context, listen: false);
    helpRequestedDialogOpen = true;
    return await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            helpRequestedDialogOpen = false;
            NotificationHandler.cancelPushUpNotification();
            ServerComms.messageToServer('HELP_RESPONSE:0');
            return Future.value(true);
          },
          child: AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      translations['nearbyReq'][appState.language],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        bottom: 10.0,
                      ),
                      child: Text(
                        translations['actionOptions'][appState.language],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    if (batteryLevel == 'low')
                      Text(
                        translations['reqBatteryLow'][appState.language],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                        ),
                      ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Buttons.cancelButton(
                          context,
                          translations['cancel'][appState.language],
                          'offer_help',
                        ),
                        FutureBuilder<bool?>(
                          future: GpsHandler.loadGpsSetting(),
                          builder: (context, _snapshot) {
                            return Buttons.giveHelpButton(context, payload);
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future showRescueChatDialog(context) async {
    return await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      barrierDismissible: true,
      builder: (BuildContext context) {
        return RescueChat(context);
      },
    );
  }
}

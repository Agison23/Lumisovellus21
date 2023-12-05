import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_app/help_needed_mode.dart';
import 'package:mobile_app/side_bar/gps_handler.dart';
import 'package:mobile_app/side_bar/side_bar.dart';
import 'package:mobile_app/user_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../open_112app.dart';
import '../widgets_binding_observer_state.dart';
import 'package:provider/provider.dart';
import '../state/appState.dart';
import '../translations/translations.dart';
import 'server_communications.dart';

class SideBarState extends WidgetsBindingObserverState<SideBar> {
  String locationMessage = 'LOCATION';

  static bool _gpsSwitchState = false;

  static bool get gpsSwitchState => _gpsSwitchState;

  static void setGpsSwitchState(bool value) async {
    if (_gpsSwitchState != value) {
      _gpsSwitchState = value;
      if (value) {
        await GpsHandler.startUpdatingGpsVariable();
        ServerComms.startSendingLocationMessages();
      } else {
        GpsHandler.stopUpdatingGpsVariable();
        ServerComms.stopSendingLocationMessages();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setAppResumedWithAlwaysOnPermissionsTask(() => {
          setState(() {
            setGpsSwitchState(true);
          })
        });
    GpsHandler.loadGpsSetting().then((gpsOn) {
      setState(() {
        setGpsSwitchState(gpsOn);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context, listen: false);
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
        child: Text(translations['gpsSharing'][appState.language],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              height: 3,
              fontSize: 25,
            )),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: Text(translations['dataForRescue'][appState.language],
            style: const TextStyle(
              height: 1,
              fontSize: 18,
            )),
      ),
      //
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
          child: TextButton(
            onPressed: () async {
              const url = "https://www.pallaksenpollot.com/privacypolicy";
              if (await canLaunchUrlString(url)) {
                await launchUrlString(url);
              } else {
                // print('ERROR');
              }
            },
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  translations['privPolicy'][appState.language],
                  textAlign: TextAlign.left,
                )),
          )),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: TextButton(
          child: Text(translations['personalInfo'][appState.language]),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserInfoPage()),
            );
          },
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(translations['locSharing'][appState.language],
              style: const TextStyle(fontSize: 19)),
          FutureBuilder<bool?>(
              future: GpsHandler.loadGpsSetting(),
              builder: (context, _snapshot) {
                return Transform.scale(
                  scale: 1.5,
                  child: Switch(
                      value: _snapshot.data ?? false,
                      onChanged: (value) {
                        GpsHandler.setGpsSetting(context, value,
                                insistAlwaysOn: true)
                            .then((gpsOn) {
                          setState(() {
                            value = gpsOn;
                            setGpsSwitchState(value);
                          });
                        });
                      }),
                );
              })
        ],
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(1.0, 20.0, 80.0, 20.0),
        child: Text(translations['dataInterval'][appState.language],
            textAlign: TextAlign.left,
            style: const TextStyle(
              height: 1,
              fontSize: 16,
            )),
      ),

      Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 75.0, 50.0, 15.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            _showDialog(context);
          },
          child: Text(
            translations['emergButton'][appState.language],
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.red,
              fixedSize: const Size(150, 75),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
        ),
      ),

      Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 10.0),
        child: Text(translations['callInfo'][appState.language],
            style: const TextStyle(
              height: 1,
              fontSize: 13,
            )),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        child: TextButton(
            onPressed: () => launch("tel:0405585493"),
            child: new Text("0405585493")),
      ),
    ]));
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    var appState = Provider.of<AppState>(context, listen: true);
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text(translations['mild'][appState.language]), value: "Lievä"),
      DropdownMenuItem(
          child: Text(translations['serious'][appState.language]),
          value: "Vakava"),
    ];
    return menuItems;
  }

  String selectedValue = "Lievä";
  Future _showDialog(context) async {
    var appState = Provider.of<AppState>(context, listen: true);
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red[200],
          title: Text(
              '${translations['emergButtonInfo1'][appState.language]} ${Platform.isIOS ? translations['emergButtonInfo2'][appState.language] : translations['emergButtonInfo3'][appState.language]}'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                  height: 50.0,
                  width: 150.0,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.fromLTRB(50, 20, 50, 50),
                  child: DropdownButton<String>(
                      style:
                          const TextStyle(color: Colors.black, fontSize: 30.0),
                      underline: Container(
                        height: 1,
                        width: 1,
                        color: Colors.black,
                        alignment: Alignment.center,
                      ),
                      value: selectedValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                      items: dropdownItems),
                ),
                FutureBuilder<bool?>(
                    future: GpsHandler.loadGpsSetting(),
                    builder: (context, _snapshot) {
                      return _helpButton(!(_snapshot.data ?? false), context);
                    })
              ]);
            },
          ),
        );
      },
    );
  }

  ElevatedButton _helpButton(bool gpsSettingIsOff, BuildContext contx) {
    var appState = Provider.of<AppState>(context, listen: true);
    return ElevatedButton(
      onPressed: () async {
        if (gpsSettingIsOff) {
          GpsHandler.setGpsSetting(contx, true, insistAlwaysOn: false)
              .then((gpsOn) async {
            if (gpsOn) {
              await GpsHandler.updateGpsVariable(ignoreSwitch: true);
              await ServerComms.messageToServer(locationMessage);
              if (selectedValue != "Lievä") {
                open112();
              }
              Navigator.of(contx).push(
                  MaterialPageRoute(builder: (contx) => HelpNeeded(true)));
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
          if (selectedValue != "Lievä") {
            open112();
          }
          Navigator.of(contx)
              .push(MaterialPageRoute(builder: (contx) => HelpNeeded(false)));
        }
      },
      child: Text(
        translations['alert'][appState.language],
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
          primary: Colors.white,
          fixedSize: const Size(200, 75),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
    );
  }
}

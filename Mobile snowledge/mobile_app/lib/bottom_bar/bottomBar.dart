import 'package:flutter/material.dart';
import 'package:mobile_app/side_bar/gps_handler.dart';
import 'package:mobile_app/widgets_binding_observer_state.dart';

import '../help_needed_mode.dart';
import '../open_112app.dart';
import '../side_bar/server_communications.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends WidgetsBindingObserverState<BottomBar> {
  String locationMessage = 'LOCATION';

  ElevatedButton _helpButton(bool gpsSettingIsOff, BuildContext contx, String text, Color color) {
    return ElevatedButton(
      onPressed: () async {
        if (gpsSettingIsOff) {
          GpsHandler.setGpsSetting(contx, true, insistAlwaysOn: false)
              .then((gpsOn) async {
            if (gpsOn) {
              await GpsHandler.updateGpsVariable(ignoreSwitch: true);
              await ServerComms.messageToServer(locationMessage);
              if (text == 'Soita 112') {
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
                      Text('Toiminto vaatii luvan käyttää laitteen GPS:ää'),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(contx),
                          child: Text('Ok'),
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
              MaterialPageRoute(builder: (contx) => HelpNeeded(true)));
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
          primary: color,
          padding: const EdgeInsets.all(20.0),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
    );
  }

  Future _showDialog(context) async {
    return await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min,children: <Widget>[
                const Text(
                  'Millaista apua tarvitset?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),
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
                          return _helpButton(
                              !(_snapshot.data ?? false),
                              context,
                              'Soita 112',
                              const Color(0xFFDA7272)
                          );
                        }),
                    FutureBuilder<bool?>(
                        future: GpsHandler.loadGpsSetting(),
                        builder: (context, _snapshot) {
                          return _helpButton(
                              !(_snapshot.data ?? false),
                              context,
                              'Avunpyyntö',
                              const Color(0xFF7281DA)
                          );
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

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              height: 60,
              decoration: const BoxDecoration(
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black, offset: Offset(0, 7), blurRadius: 35
                    )
                  ]
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40.0,
                  ),
                  Container(
                    width: 40.0,
                  ),
                  InkWell(
                    onTap: () {
                      // add page infos about sharing location
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.near_me_rounded, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Sijainti', style: TextStyle(
                            color: Colors.white
                        ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                _showDialog(context);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(50.0)
                ),
                child: Center(child: const Text('Pyydäapua', style: TextStyle(color: Colors.white))),
              ),
            ),
          ),
        ]
    );
  }
}

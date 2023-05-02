import 'package:flutter/services.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/side_bar/navigation_drawer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'bottom_bar/bottomBar.dart';
import 'package:provider/provider.dart';
import '../state/appState.dart';
import '../translations/translations.dart';

String? firstName;
String? lastName;
String? phoneNumber;

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController pNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int nameMaxLen = 30;

  @override
  void initState() {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((pref) {
      firstName = pref.getString('fName');
      fNameController.text = firstName.toString();
      lastName = pref.getString('lName');
      lNameController.text = lastName.toString();
      phoneNumber = pref.getString('pNumber');
      pNumberController.text = phoneNumber.toString();
    });
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    return WillPopScope(
      onWillPop: () async {
        if (_globalKey.currentState?.isDrawerOpen == true) {
          Navigator.of(context).pop();
          return false;
        } else {
          final value = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(translations['quitApp'][appState.language]),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(translations['no'][appState.language]),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(translations['yes'][appState.language]),
                    ),
                  ],
                );
              });
          if (value != null) {
            return Future.value(value);
          } else {
            return Future.value(false);
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          key: _globalKey,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: Container(
                                  height: 100,
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: TextFormField(
                                    controller: fNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return translations['fNameQuery']
                                            [appState.language];
                                      }
                                      if (value.length > nameMaxLen) {
                                        return translations['fNameMaxLen1']
                                                [appState.language] +
                                            '${nameMaxLen}' +
                                            translations['fNameMaxLen2']
                                                [appState.language];
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      labelText: translations['fName']
                                          [appState.language],
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  height: 100,
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: TextFormField(
                                    controller: lNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return translations['surnameQuery']
                                            [appState.language];
                                      }
                                      if (value.length > nameMaxLen) {
                                        return translations['surnameMaxLen1']
                                                [appState.language] +
                                            '${nameMaxLen}' +
                                            translations['surnameMaxLen2']
                                                [appState.language];
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      labelText: translations['surname']
                                          [appState.language],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 100,
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            keyboardType: TextInputType.number,
                            controller: pNumberController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return translations['numQuery']
                                    [appState.language];
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: translations['phoneNum']
                                  [appState.language],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _updateName(
                                    context,
                                    fNameController.text,
                                    lNameController.text,
                                    pNumberController.text);
                              }
                            },
                            child: Text(
                              translations['save'][appState.language],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(170, 70),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // Stacking the bottom bar on top of the webview
              const Align(
                  alignment: Alignment.bottomCenter, child: BottomBar()),
              IconButton(
                iconSize: 30,
                icon: Stack(
                  children: [
                    const Icon(Icons.menu),
                  ],
                ),
                onPressed: () {
                  _globalKey.currentState?.openDrawer();
                },
                color: Colors.black,
              ),
            ],
          ),
          drawer: const MyNavigationDrawer(),
        ),
      ),
    );
  }
}

Future _showDialog(BuildContext context, String message) async {
  var appState = Provider.of<AppState>(context, listen: false);
  return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(translations['ok'][appState.language]),
            ),
          ],
        );
      });
}

void _updateName(
    BuildContext context, String fName, String lName, String pNumber) {
  var appState = Provider.of<AppState>(context, listen: false);
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  prefs.then((pref) {
    pref.setString('fName', fName);
    pref.setString('lName', lName);
    pref.setString('pNumber', pNumber);
    _showDialog(context, translations['infoSaved'][appState.language]);
  });
}

import 'package:flutter/services.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/side_bar/navigation_drawer.dart';
import 'bottom_bar/bottomBar.dart';

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
    var appState = Provider.of<AppState>(context, listen: false);
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
                  title: Text(!appState.isEnglish
                      ? 'Haluatko poistua sovelluksesta?'
                      : 'Do you want to exit the app?'),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('En'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(!appState.isEnglish ? 'Kyllä' : 'Yes'),
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
                                        return !appState.isEnglish
                                            ? 'Anna etunimesi'
                                            : 'Enter your first name';
                                      }
                                      if (value.length > nameMaxLen) {
                                        return !appState.isEnglish
                                            ? 'Etunimen enimmäispituus on ${nameMaxLen} merkkiä!'
                                            : 'Maximum length of first name is ${nameMaxLen} characters!';
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
                                      labelText: !appState.isEnglish
                                          ? 'Etunimi'
                                          : 'First name',
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
                                        return !appState.isEnglish
                                            ? 'Anna sukunimesi'
                                            : 'Enter your last name';
                                      }
                                      if (value.length > nameMaxLen) {
                                        return !appState.isEnglish
                                            ? 'Sukunimen enimmäispituus on ${nameMaxLen} merkkiä!'
                                            : 'Maximum length of last name is ${nameMaxLen} characters!';
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
                                      labelText: !appState.isEnglish
                                          ? 'Sukunimi'
                                          : 'Last name',
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
                                return !appState.isEnglish
                                    ? 'Anna puhelinnumerosi'
                                    : 'Enter your phone number';
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
                              labelText: !appState.isEnglish
                                  ? 'Puhelinnumero'
                                  : 'Phone number',
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
                              !appState.isEnglish ? 'Tallenna' : 'Save',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
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
                icon: const Icon(Icons.menu),
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
              child: const Text('Ok'),
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
    _showDialog(
        context,
        !appState.isEnglish
            ? "Tiedot tallennettu"
            : "User information has been saved");
  });
}

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
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

  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
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
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    keyboardType: TextInputType.number,
                    controller: pNumberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return translations['numQuery'][appState.language];
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: translations['phoneNum'][appState.language],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updateName(context, fNameController.text,
                            lNameController.text, pNumberController.text);
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
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  var appState = Provider.of<AppState>(context, listen: false);
  prefs.then((pref) {
    pref.setString('fName', fName);
    pref.setString('lName', lName);
    pref.setString('pNumber', pNumber);
    _showDialog(context, translations['infoSaved'][appState.language]);
  });
}

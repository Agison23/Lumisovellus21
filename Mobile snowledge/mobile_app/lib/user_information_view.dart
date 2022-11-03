import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

String? firstName;
String? lastName;
String? phoneNumber;
class UserInfoPage extends StatefulWidget {

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage>{

  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController pNumberController = TextEditingController();


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

  Widget build(BuildContext context){

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
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: TextFormField(
                //initialValue: firstName,
                controller: fNameController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'Etunimi',
                ),
                onChanged: (String value){
                  firstName=value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: TextFormField(
                //initialValue: lastName,
                controller: lNameController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'Sukunimi',
                ),
                onChanged: (String value){
                  lastName=value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: TextFormField(
                keyboardType: TextInputType.number,
                scrollPadding: const EdgeInsets.only(bottom: 40),
                controller: pNumberController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'Puhelinnumero',
                ),
              ),

            ),
            Center(
              child: ElevatedButton(
                child: const Text(
                  'Tallenna'
                ),
                onPressed: () {
                  int nameMaxLen = 30;
                  if (fNameController.text.isEmpty || lNameController.text.isEmpty) {
                    _showDialog(context, 'Täytä kaikki kentät!');
                  } else if (fNameController.text.length > nameMaxLen || lNameController.text.length > nameMaxLen) {
                    _showDialog(context, 'Yhden nimen enimmäispituus on ${nameMaxLen} merkkiä!');
                  } else {
                    _updateName(context, fNameController.text, lNameController.text);

                  }
                },
              ),
            )
          ],

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

void _updateName(BuildContext context, String fName, String lName){
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  prefs.then((pref) {
    pref.setString('fName', fName);
    pref.setString('lName', lName);
    _showDialog(context, "Tiedot tallennettu");
  });
}


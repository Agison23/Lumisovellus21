import 'package:flutter/material.dart';
import 'package:mobile_app/main_page.dart';
import 'package:mobile_app/second_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NameInputScreen extends StatelessWidget {
  const NameInputScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController fName = TextEditingController();
    TextEditingController lName = TextEditingController();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://static.wixstatic.com/media/5887f2_a1088b1d721e48f2aa8bec5e0088a46a~mv2_d_5656_3770_s_4_2.jpg/v1/fill/w_493,h_618,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Pallas_Lapland_ski_april_2958.jpg'
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: ListView(
        children: <Widget>[
          Column(
            children: [
              const Image(
                image: AssetImage('assets/images/logo_transparent_black.png'),
                width: 250.0,
                height: 250.0,
                fit: BoxFit.cover,

              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(color: Colors.white),
            child: const Text(
                '\nSyötäthän oikean nimesi!\n\nNimeä käytetään sovelluksen GPS-toimintoon. Toiminnolla tuetaan Pallaksen Pöllöjä ja tarvittaessa pelastuslaitosta.\n',
                textAlign: TextAlign.center,
                style: TextStyle(height: 1, fontSize: 15)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: TextFormField(
              scrollPadding: const EdgeInsets.only(bottom: 40),
              controller: fName,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                labelText: 'Anna etunimi',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: TextFormField(
              scrollPadding: const EdgeInsets.only(bottom: 40),
              controller: lName,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                labelText: 'Anna sukunimi',
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              child: const Text(
                'Seuraava',
              ),
              onPressed: () {
                int nameMaxLen = 30;
                if (fName.text.isEmpty || lName.text.isEmpty) {
                  _showDialog(context, 'Täytä kaikki kentät!');
                } else if (fName.text.length > nameMaxLen || lName.text.length > nameMaxLen) {
                  _showDialog(context, 'Yhden nimen enimmäispituus on ${nameMaxLen} merkkiä!');
                } else {
                  _navigateToNextScreen(context, fName.text, lName.text);
                }
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToNextScreen(BuildContext context, String fName, String lName) {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((pref) {
      pref.setString('fName', fName);
      pref.setString('lName', lName);
    });
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false);
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

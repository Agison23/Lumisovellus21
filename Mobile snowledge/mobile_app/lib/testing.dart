import 'package:flutter/material.dart';
import 'package:mobile_app/second_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstScreens extends StatefulWidget {
  const FirstScreens({Key? key}) : super(key: key);

  @override
  _FirstScreensState createState() => _FirstScreensState();
  }


class _FirstScreensState extends State<FirstScreens>{
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
        Widget>[
      const Image(
        image: AssetImage('assets/images/logo_transparent_black.png'),
        width: 250.0,
        height: 250.0,
        fit: BoxFit.cover,
      ),
      Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: const Text(
            'Pallaksen Pöllöjen tuottama lumisovellus.\n tarjoaa tietoja alueella vallitsevista \nlumiolosuhteista',
            style: TextStyle(height: 1, fontSize: 15)),
      ),
      Center(
        child: ElevatedButton(
          child: const Text(
              'Seuraava'),
          onPressed: (){
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SecondScreen()),
                    (route) => false);

          },
        ),
      )
    ]);
  }
}
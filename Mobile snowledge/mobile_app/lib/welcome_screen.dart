import 'package:flutter/material.dart';
import 'package:mobile_app/second_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';



class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WelcomeScreen(),

    );
  }
}
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://static.wixstatic.com/media/5887f2_a1088b1d721e48f2aa8bec5e0088a46a~mv2_d_5656_3770_s_4_2.jpg/v1/fill/w_493,h_618,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Pallas_Lapland_ski_april_2958.jpg'
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <
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
          decoration: BoxDecoration(color: Colors.white),
          child: const Text(
              'Pallaksen Pöllöjen tuottama lumisovellus.\n tarjoaa tietoja alueella vallitsevista \nlumiolosuhteista',
              textAlign: TextAlign.center,
              style: TextStyle(height: 1, fontSize: 15)),
        ),
        Center(
          child: ElevatedButton(
            child: const Text(
                'Seuraava',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            onPressed: (){
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondScreen()),
                      (route) => false);

            },
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(170, 70),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
        )
      ]),
    );
  }
}

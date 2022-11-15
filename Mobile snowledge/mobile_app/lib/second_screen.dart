import 'package:flutter/material.dart';
import 'package:mobile_app/side_bar/gps_handler.dart';
import 'package:mobile_app/widgets_binding_observer_state.dart';
import 'main_page.dart';
import 'name_input_screen.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  WidgetsBindingObserverState<SecondScreen> createState() =>
      _SecondScreenState();
}

class _SecondScreenState extends WidgetsBindingObserverState<SecondScreen> {
  @override
  void initState() {
    super.initState();
    setAppResumedWithAlwaysOnPermissionsTask(() => {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MapTracking()),
              (route) => false)
        });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AskPermission(),
    );
  }
}

class AskPermission extends StatelessWidget {
  const AskPermission({Key? key}) : super(key: key);

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
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
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
              'Sovellus tarvitsee luvan käyttää sijaintia myös näytön ollessa kiinni. Sallitko sijaintiedon keräämisen sovelluksen ollessa taustalla?\n\n*Luvat on mahdollista antaa myös myöhemmässä vaiheessa',
              textAlign: TextAlign.center,
              style: TextStyle(height: 1, fontSize: 15)),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(7, 100, 7, 15),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
              Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (await GpsHandler.checkAndAskGpsAlwaysOnPermission(context)) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const NameInputScreen()),
                            (route) => false);
                  }
                },
                child: const Text(
                  'Salli sijainnin käyttö',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(170, 70),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const NameInputScreen()),
                    (route) => false);
              },
              child: const Text(
                'Älä salli sijaintia',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),

            ),

          ]),
        ),

      ]),
    );
  }
}

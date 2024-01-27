import 'package:flutter/material.dart';
import 'package:mobile_app/map_tracking.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:mobile_app/widgets/buttons.dart';
import 'package:provider/provider.dart';
import '../translations/translations.dart';

class HelpOver extends StatelessWidget {
  const HelpOver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    return SafeArea(
      child: Scaffold(
          body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/TAUSTAKUVA_SOVELLUS.jpg"),
          fit: BoxFit.cover,
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(translations['requestOver1'][appState.language],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 3,
                    fontSize: 30,
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: SizedBox(
                  width: 300,
                  child: Buttons.confirmButton(context, 'OK', onPressed: () {
                    var appState =
                        Provider.of<AppState>(context, listen: false);
                    appState.setPageIndex = 0;
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MapTracking()),
                        (route) => false);
                  }),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

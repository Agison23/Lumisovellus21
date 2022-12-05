import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/map_tracking.dart';
import 'package:mobile_app/side_bar/gps_handler.dart';
import 'package:mobile_app/widgets/buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final pageViewController = PageController();

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/TAUSTAKUVA_SOVELLUS.jpg"),
            fit: BoxFit.cover),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const SizedBox(height: 50),
              const Image(
                image:
                    AssetImage('assets/images/pallaksen_pollot_logo_white.png'),
                width: 250.0,
                fit: BoxFit.fitWidth,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageViewController,
                  children: [
                    //Page1Start
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 120),
                          const Text(
                              'Pallaksen Pöllöjen tuottama lumisovellus tarjoaa tietoja alueella vallitsevista lumiolosuhteista.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  height: 1,
                                  fontSize: 20,
                                  color: Colors.white)),
                          const SizedBox(height: 150),
                          Buttons.onboardingButton(context, 'Seuraava',
                              onPressed: () {
                            pageViewController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          })
                        ],
                      ),
                    ), //Page1end

                    //Page2Start
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 70),
                          const Text(
                              'LUPA SIJAINTIETOIHIN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  height: 1,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          const SizedBox(height: 30.0),
                          const Text(
                              'Sovellus tarvitsee luvan käyttää tietojasi myös näytön ollessa suljettuna. Sallitko sijaintitiedon keräämisen sovelluksen ollessa taustalla?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  height: 1,
                                  fontSize: 20,
                                  color: Colors.white)),
                          const SizedBox(height: 100),
                          Buttons.onboardingButton(context, 'SALLI KÄYTTÖ',
                              onPressed: () async {
                                if (await GpsHandler
                                    .checkAndAskGpsAlwaysOnPermission(
                                    context)) {
                                  pageViewController.nextPage(
                                    duration:
                                    const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              ),
                          const SizedBox(height: 10.0),
                          Buttons.refuseLocationPermissionButton(
                              context,
                              onPressed: () {
                                pageViewController.nextPage(
                                  duration:
                                  const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              },
                          )
                        ],
                      ),
                    ), //Page2End

                    //Page3Start
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                      child: ScrollConfiguration(
                        behavior: MyScrollBehavior(),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const Text(
                                  'Syötäthän oikeat tietosi',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      height: 1,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const SizedBox(height: 20.0),
                              const Text(
                                  'Tietojasi käytetään sovelluksen pelastustoimintoon.\nToiminnon avulla pelastuslaitos voi hälytyksen tapahtuessa löytää sinut helpommin.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      height: 1,
                                      fontSize: 20,
                                      color: Colors.white)),
                              const SizedBox(height: 30),
                              SingleChildScrollView(child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30.0),
                                child: UserInfoForm(pageController: pageViewController),
                              ))
                            ],
                          ),
                        ),
                      ),
                    ), //Page3End

                    //Page4Start
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 70),
                          const Text(
                              'Pallaksen Pöllöjen tuottama lumisovellus toimii tunturissa useilla eri tavoin. Hampurilaisvalikosta navigoimalla voit tutustua Pallaksen tunturialueen lumihavaintoihin, joita sekä oppaat että käyttäjät jättävät, ja säätietoihin. Pelastustoiminto sovelluksessa on käytössä ympäri vuoden ja se on löydettävissä punaisen napin kautta kaikissa näkymissä.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  height: 1,
                                  fontSize: 20,
                                  color: Colors.white)),
                          const SizedBox(height: 100),
                          Buttons.onboardingButton(
                              context,
                              'SEURAAVA',
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const MapTracking()),
                                        (route) => false);
                              }
                          )
                        ],
                      ),
                    ), //Page4End
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfoForm extends StatefulWidget {
  UserInfoForm({Key? key, required this.pageController}) : super(key: key);

  final PageController pageController;

  @override
  UserInfoFormState createState() {
    return UserInfoFormState();
  }
}

class UserInfoFormState extends State<UserInfoForm> {
  final _formKey = GlobalKey<FormState>();
  int nameMaxLen = 30;
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController pNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20
            ),
            textAlign: TextAlign.center,
            controller: fNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Anna etunimesi';
              }
              if (value.length > nameMaxLen) {
                return 'Etunimen enimmäispituus on ${nameMaxLen} merkkiä!';
              }
              return null;
            },
            decoration: InputDecoration(
              floatingLabelAlignment: FloatingLabelAlignment.center,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.white),
                ),
                label: Center(
                  child: Text('Etunimi',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 20
                    ),
                  ))
            ),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20
            ),
            textAlign: TextAlign.center,
            controller: lNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Anna sukunimesi';
              }
              if (value.length > nameMaxLen) {
                return 'Sukunimen enimmäispituus on ${nameMaxLen} merkkiä!';
              }
              return null;
            },
            decoration: InputDecoration(
                floatingLabelAlignment: FloatingLabelAlignment.center,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.white),
                ),
                label: Center(
                    child: Text('Sukunimi',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 20
                      ),
                    ))
            ),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20
            ),
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            keyboardType: TextInputType.number,
            controller: pNumberController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Anna puhelinnumerosi';
              }

              return null;
            },
            decoration: InputDecoration(
                floatingLabelAlignment: FloatingLabelAlignment.center,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.white),
                ),
                label: Center(
                    child: Text('Puhelinnumero',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 20
                      ),
                    ))
            ),
          ),
          const SizedBox(height: 30.0),
          Buttons.onboardingButton(
              context,
              'Seuraava',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _setPreferences(fNameController.text,
                      lNameController.text, pNumberController.text);
                  widget.pageController.nextPage(
                    duration:
                    const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              }
          )
        ],
      ),
    );
  }
}

void _setPreferences(String fName, String lName, String pNumber) {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  prefs.then((pref) {
    pref.setString('fName', fName);
    pref.setString('lName', lName);
    pref.setString('pNumber', pNumber);
  });
}

class MyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
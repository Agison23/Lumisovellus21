import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/map_tracking.dart';

import 'package:mobile_app/side_bar/gps_handler.dart';
import 'package:mobile_app/user_information_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/main_page.dart';

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
          image: NetworkImage(//TODO change the background image
              'https://static.wixstatic.com/media/5887f2_a1088b1d721e48f2aa8bec5e0088a46a~mv2_d_5656_3770_s_4_2.jpg/v1/fill/w_493,h_618,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Pallas_Lapland_ski_april_2958.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const Image(
                image: AssetImage('assets/images/logo_transparent_black.png'),
                width: 250.0,
                height: 250.0,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageViewController,
                  children: [
                    //Page1Start
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                              'Pallaksen Pöllöjen tuottama lumisovellus.\n tarjoaa tietoja alueella vallitsevista \nlumiolosuhteista',
                              textAlign: TextAlign.center,
                              style: TextStyle(height: 1, fontSize: 15)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(100.0),
                          child: ElevatedButton(
                            child: const Text(
                              'Seuraava',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xffffffff),
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () {
                              pageViewController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                    0xff3c4d62), // background (button) color
                                foregroundColor: Color(
                                    0xffffffff), // foreground (text) color
                                fixedSize: const Size(170, 70),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                      ],
                    ), //Page1end

                    //Page2Start
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                              'Sovellus tarvitsee luvan käyttää sijaintia myös näytön ollessa kiinni. Sallitko sijaintiedon keräämisen sovelluksen ollessa taustalla?\n\n*Luvat on mahdollista antaa myös myöhemmässä vaiheessa',
                              textAlign: TextAlign.center,
                              style: TextStyle(height: 1, fontSize: 15)),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(7, 100, 7, 15),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ElevatedButton(
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
                                    child: const Text(
                                      'Salli sijainnin käyttö',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xffffffff),
                                        fontSize: 20,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(
                                          0xff3c4d62), // background (button) color
                                      foregroundColor: Color(
                                          0xffffffff), // foreground (text) color
                                      fixedSize: const Size(170, 70),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    pageViewController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
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
                      ],
                    ), //Page2End

                    //Page3Start
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(8),
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(
                                '\nSyötäthän oikeat tietosi\n\nNimeä käytetään sovelluksen GPS-toimintoon. Toiminnolla tuetaan Pallaksen Pöllöjä ja tarvittaessa pelastuslaitosta.\n',
                                textAlign: TextAlign.center,
                                style: TextStyle(height: 1, fontSize: 15)),
                          ),
                          const UserInfoForm()
                        ],
                      ),
                    ), //Page3End
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
  const UserInfoForm({Key? key}) : super(key: key);

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
                          return 'Anna etunimesi';
                        }
                        if (value.length > nameMaxLen) {
                          return 'Etunimen enimmäispituus on ${nameMaxLen} merkkiä!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Etunimi',
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
                          return 'Anna sukunimesi';
                        }
                        if (value.length > nameMaxLen) {
                          return 'Sukunimen enimmäispituus on ${nameMaxLen} merkkiä!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Sukunimi',
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
                  return 'Anna puhelinnumerosi';
                }

                return null;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Puhelinnumero',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _navigateToNextScreen(context, fNameController.text,
                      lNameController.text, pNumberController.text);
                }
              },
              child: const Text(
                'Siirry sovellukseen',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xffffffff),
                  fontSize: 20,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff3c4d62), // background (button) color
                foregroundColor: Color(0xffffffff), // foreground (text) color
                fixedSize: const Size(170, 70),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

void _navigateToNextScreen(
    BuildContext context, String fName, String lName, String pNumber) {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  prefs.then((pref) {
    pref.setString('fName', fName);
    pref.setString('lName', lName);
    pref.setString('pNumber', pNumber);
  });
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MapTracking()),
      (route) => false);
}

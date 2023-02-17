import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/bottom_bar/state/setSharingLocation.dart';
import 'package:mobile_app/main_page.dart';
import 'package:mobile_app/side_bar/gps_handler.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:mobile_app/widgets/buttons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'translations/translations.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final pageViewController = PageController();
  final page1ScrollController = ScrollController();
  final page2ScrollController = ScrollController();
  final page3ScrollController = ScrollController();
  final page4ScrollController = ScrollController();
  final page5ScrollController = ScrollController();

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
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
                      child: Scrollbar(
                        controller: page1ScrollController,
                        isAlwaysShown: true,
                        child: SingleChildScrollView(
                          controller: page1ScrollController,
                          child: Column(
                            children: [
                              const SizedBox(height: 120),
                              SizedBox(
                                height: 150,
                                child: Text(
                                    translations['snowAppInfo']
                                        [appState.language],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        height: 1,
                                        fontSize: 20,
                                        color: Colors.white)),
                              ),
                              const SizedBox(height: 30),
                              Container(
                                width: 250,
                                child: Buttons.onboardingButton(
                                  context,
                                  translations['next'][appState.language],
                                  onPressed: () {
                                    pageViewController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                width: 250,
                                child: Buttons.onboardingButton(
                                  context,
                                  translations['languageOpt']
                                      [appState.language],
                                  onPressed: () {
                                    //IMPLEMENT THIS

                                    //THIS
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ), //Page1end

                    //Page2Start
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Scrollbar(
                        controller: page2ScrollController,
                        isAlwaysShown: true,
                        child: SingleChildScrollView(
                          controller: page2ScrollController,
                          child: Column(
                            children: [
                              const SizedBox(height: 70),
                              Text(
                                  translations['sharingLocation']
                                      [appState.language],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      height: 1,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const SizedBox(height: 30.0),
                              Text(
                                  translations['rescueFeatureInfo']
                                      [appState.language],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      height: 1,
                                      fontSize: 20,
                                      color: Colors.white)),
                              const SizedBox(height: 70),
                              Buttons.onboardingButton(
                                context,
                                translations['allowAccess'][appState.language],
                                onPressed: () async {
                                  if (await GpsHandler
                                      .checkAndAskGpsAlwaysOnPermission(
                                          context)) {
                                    GpsHandler.setGpsSetting(context, true,
                                        insistAlwaysOn: true);
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
                                translations['noLocationShare']
                                    [appState.language],
                                onPressed: () {
                                  pageViewController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ), //Page2End

                    //Page3Start
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Scrollbar(
                        controller: page3ScrollController,
                        isAlwaysShown: true,
                        child: SingleChildScrollView(
                          controller: page3ScrollController,
                          child: Column(
                            children: [
                              const SizedBox(height: 70),
                              Text(
                                  translations['sharingLocation']
                                      [appState.language],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      height: 1,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const SizedBox(height: 30.0),
                              Text(
                                  translations['whyLocationShare']
                                      [appState.language],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      height: 1,
                                      fontSize: 20,
                                      color: Colors.white)),
                              const SizedBox(height: 20.0),
                              SetSharingLocation(),
                              const SizedBox(height: 50),
                              Buttons.onboardingButton(context,
                                  translations['next'][appState.language],
                                  onPressed: () {
                                pageViewController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              })
                            ],
                          ),
                        ),
                      ),
                    ),
                    //Page3End

                    //Page4Start
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0),
                      child: ScrollConfiguration(
                        behavior: MyScrollBehavior(),
                        child: Scrollbar(
                          controller: page4ScrollController,
                          isAlwaysShown: true,
                          child: SingleChildScrollView(
                            controller: page4ScrollController,
                            child: Column(
                              children: [
                                Text(
                                    translations['correctInfo']
                                        [appState.language],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        height: 1,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                const SizedBox(height: 20.0),
                                Text(
                                    translations['infoUsage']
                                        [appState.language],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        height: 1,
                                        fontSize: 20,
                                        color: Colors.white)),
                                const SizedBox(height: 30),
                                SingleChildScrollView(
                                    child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 30.0),
                                  child: UserInfoForm(
                                      pageController: pageViewController),
                                ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ), //PageEnd

                    //Page5Start
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Scrollbar(
                        controller: page5ScrollController,
                        isAlwaysShown: true,
                        child: SingleChildScrollView(
                          controller: page5ScrollController,
                          child: Column(
                            children: [
                              const SizedBox(height: 70),
                              Text(
                                  translations['appFuncDesc']
                                      [appState.language],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      height: 1,
                                      fontSize: 20,
                                      color: Colors.white)),
                              const SizedBox(height: 100),
                              Buttons.onboardingButton(context,
                                  translations['next'][appState.language],
                                  onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MainPage()),
                                    (route) => false);
                              })
                            ],
                          ),
                        ),
                      ),
                    ), //Page5End
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
    var appState = Provider.of<AppState>(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            style: const TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
            controller: fNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return translations['fNameQuery'][appState.language];
              }
              if (value.length > nameMaxLen) {
                return translations['fNameMaxLen1'][appState.language] +
                    nameMaxLen +
                    translations['fNameMaxLen2'][appState.language];
              }
              return null;
            },
            decoration: InputDecoration(
                floatingLabelAlignment: FloatingLabelAlignment.center,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.white),
                ),
                label: Center(
                    child: Text(
                  translations['fName'][appState.language],
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5), fontSize: 20),
                ))),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            style: const TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
            controller: lNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return translations['surnameQuery'][appState.language];
              }
              if (value.length > nameMaxLen) {
                return translations['surnameMaxLen1'][appState.language] +
                    nameMaxLen +
                    translations['surnameMaxLen2'][appState.language];
              }
              return null;
            },
            decoration: InputDecoration(
                floatingLabelAlignment: FloatingLabelAlignment.center,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.white),
                ),
                label: Center(
                    child: Text(
                  translations['surname'][appState.language],
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5), fontSize: 20),
                ))),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            style: const TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
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
                floatingLabelAlignment: FloatingLabelAlignment.center,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.white),
                ),
                label: Center(
                    child: Text(
                  translations['phoneNum'][appState.language],
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5), fontSize: 20),
                ))),
          ),
          const SizedBox(height: 30.0),
          Buttons.onboardingButton(
              context, translations['next'][appState.language], onPressed: () {
            if (_formKey.currentState!.validate()) {
              _setPreferences(fNameController.text, lNameController.text,
                  pNumberController.text);
              FocusScope.of(context).unfocus();
              widget.pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          })
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

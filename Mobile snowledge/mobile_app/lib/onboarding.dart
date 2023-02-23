import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/bottom_bar/state/setSharingLocation.dart';
import 'package:mobile_app/main_page.dart';
import 'package:mobile_app/side_bar/gps_handler.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:mobile_app/widgets/buttons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                              const SizedBox(height: 50),
                              SizedBox(
                                height: 100,
                                child: Text(
                                    !appState.isEnglish
                                        ? 'Pallaksen Pöllöjen tuottama lumisovellus tarjoaa tietoja alueella vallitsevista lumiolosuhteista.'
                                        : 'The snow application produced by Pallasen Pöllöje provides information about the prevailing snow conditions in the area.',
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
                                  !appState.isEnglish ? 'Seuraava' : 'Continue',
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
                                  appState.isEnglish
                                      ? 'Suomen kielellä'
                                      : 'In English',
                                  onPressed: () {
                                    appState.toggleLanguage = true;
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
                              // const SizedBox(height: 20),
                              Text(
                                  !appState.isEnglish
                                      ? 'SIJAINTITIEDON JAKAMINEN'
                                      : 'SHARING OF LOCATION INFORMATION',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      height: 1,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const SizedBox(height: 30.0),
                              Text(
                                  !appState.isEnglish
                                      ? 'Sovelluksen pelastustoiminto kerää tietoja sijainnistasi. Sen avulla tarjoamme pelastamiseen tukea. Sijaintia käyttäen pelastuslaitos voi hyödyntää reittiäsi ja voit pyytää apua ympärillä olevilta kulkijoilta. Myös sinä voit auttaa muita. Voit koska tahansa poistaa sijainnin käytöstä.'
                                      : "The app's rescue function collects information about your location. With it, we offer rescue support. Using the location, the rescue service can take advantage of your route and you can ask for help from passers-by around you. You too can help others. You can disable location at any time.",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      height: 1,
                                      fontSize: 20,
                                      color: Colors.white)),
                              const SizedBox(height: 30),
                              Buttons.onboardingButton(
                                context,
                                !appState.isEnglish
                                    ? 'SALLI KÄYTTÖ'
                                    : 'ALLOW ACCESS',
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
                                !appState.isEnglish
                                    ? 'Älä salli sijaintia'
                                    : 'Do not allow location access',
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
                              // const SizedBox(height: 70),
                              Text(
                                  !appState.isEnglish
                                      ? 'SIJAINTITIEDON JAKAMINEN'
                                      : 'SHARING OF LOCATION INFORMATION',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      height: 1,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const SizedBox(height: 30.0),
                              Text(
                                  !appState.isEnglish
                                      ? "Sijainnin jakaminen tulee olla päällä, jotta pystymme paikantamaan sinut avuntarpeessa ja auttajan roolissa. Jos poistat käytöstä sijainnin jakamisen, et saa ilmoituksia apua tarvitsevilta."
                                      : "Location sharing must be turned on so that we can locate you in need of help and in the role of a helper. If you disable location sharing, you will not receive notifications from those who need help.",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      height: 1,
                                      fontSize: 20,
                                      color: Colors.white)),
                              const SizedBox(height: 20),
                              SetSharingLocation(),
                              const SizedBox(height: 20),
                              Buttons.onboardingButton(context,
                                  !appState.isEnglish ? 'Seuraava' : 'Continue',
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
                          top: 0.0, left: 20.0, right: 20.0),
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
                                    !appState.isEnglish
                                        ? 'Syötäthän oikeat tietosi'
                                        : 'Enter your correct information',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        height: 1,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                const SizedBox(height: 15),
                                Text(
                                    !appState.isEnglish
                                        ? 'Tietojasi käytetään sovelluksen pelastustoimintoon.\nToiminnon avulla pelastuslaitos voi hälytyksen tapahtuessa löytää sinut helpommin.'
                                        : "Your information is used for the application's rescue function.\nThe function allows the rescue service to find you more easily in the event of an alarm.",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        height: 1,
                                        fontSize: 20,
                                        color: Colors.white)),
                                const SizedBox(height: 10),
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
                              const SizedBox(height: 10),
                              Text(
                                  !appState.isEnglish
                                      ? 'Pallaksen Pöllöjen tuottama lumisovellus toimii tunturissa usein eri tavoin. Hampurilaisvalikosta navigoimalla voit tutustua Pallaksen tunturialueen lumihavaintoihin, joita sekä oppaat että käyttäjät jättävät, ja säätietoihin. Pelastustoiminto sovelluksessa on käytössä ympäri vuoden ja se on löydettävissä oranssin napin kautta kaikissa näkymissä.'
                                      : "The snow application produced by Pallas Pöllöj often works in different ways in the fells. By navigating the hamburger menu, you can familiarize yourself with the snow observations of the Pallas fell area, which are left by both guides and users, and weather information. The rescue function in the application is available all year round and can be found via the orange button in all views.",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      height: 1,
                                      fontSize: 20,
                                      color: Colors.white)),
                              const SizedBox(height: 50),
                              Buttons.onboardingButton(context,
                                  !appState.isEnglish ? 'SEURAAVA' : 'CONTINUE',
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
                return !appState.isEnglish
                    ? 'Anna etunimesi'
                    : 'Enter your first name';
              }
              if (value.length > nameMaxLen) {
                return !appState.isEnglish
                    ? 'Etunimen enimmäispituus on ${nameMaxLen} merkkiä!'
                    : 'The maximum length of a first name is ${nameMaxLen} characters!';
              }
              return null;
            },
            decoration: InputDecoration(
              floatingLabelAlignment: FloatingLabelAlignment.center,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.white),
              ),
              hintText: !appState.isEnglish ? 'Etunimi' : 'First name',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          TextFormField(
            style: const TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
            controller: lNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return !appState.isEnglish
                    ? 'Anna sukunimesi'
                    : 'Enter your last name';
              }
              if (value.length > nameMaxLen) {
                return !appState.isEnglish
                    ? 'Sukunimen enimmäispituus on ${nameMaxLen} merkkiä!'
                    : 'The maximum length of the last name is ${nameMaxLen} characters!';
              }
              return null;
            },
            decoration: InputDecoration(
              floatingLabelAlignment: FloatingLabelAlignment.center,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.white),
              ),
              hintText: !appState.isEnglish ? 'Sukunimi' : 'Last name',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
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
                return !appState.isEnglish
                    ? 'Anna puhelinnumerosi'
                    : 'Enter your phone number';
              }

              return null;
            },
            decoration: InputDecoration(
              floatingLabelAlignment: FloatingLabelAlignment.center,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.white),
              ),
              hintText: !appState.isEnglish ? 'Puhelinnumero' : 'Phone number',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          Buttons.onboardingButton(
              context, !appState.isEnglish ? 'Seuraava' : 'Continue',
              onPressed: () {
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

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get snowAppInfo =>
      'Pallaksen Pöllöt -lumisovellus tarjoaa tietoa alueella vallitsevista lumiolosuhteista.';

  @override
  String get next => 'Jatka';

  @override
  String get sharingLocation => 'SIJAINTITIEDON JAKAMINEN';

  @override
  String get rescueFeatureInfo =>
      'Sovelluksen pelastustoiminto kerää tietoa sijainnistasi. Tämän avulla voimme tarjota apua pelastustilanteissa. Pelastusviranomaiset näkevät reittisi ja sovellus voi pyytää apua muilta käyttäjiltä ympärilläsi. Voit myös auttaa muita käyttäjiä. Sijainnin jakamisen voi poistaa käytöstä milloin tahansa.';

  @override
  String get allowSharing => 'SALLI JAKAMINEN';

  @override
  String get noLocationShare => 'Älä salli sijainnin jakamista';

  @override
  String get correctInfo => 'Varmista, että syötät oikeat tiedot';

  @override
  String get infoUsage =>
      'Tietojasi käytetään sovelluksen pelastustoimintoon. Toiminto auttaa pelastuspalvelua löytämään sinut helpommin.';

  @override
  String get fName => 'Etunimi';

  @override
  String get surname => 'Sukunimi';

  @override
  String get phoneNum => 'Puhelinnumero';

  @override
  String get definitions => 'MÄÄRITELMÄT';

  @override
  String get avalancheWarning => 'Lumivyöryvaroitus';

  @override
  String get avalancheWarningDesc =>
      'Pallaksen lumivyöryalueet sisältävät useita kuroja kuten Pyhäkuru, Palkaskuru, Rihmakuru ja kaikki yli 25 asteen jyrkät rinteet Lommoltunturissa, Keimiötunturissa ja Lehmäkerossa. Yksittäisiä pienempiä lumivyöryjä voi esiintyä myös muualla jyrkän maaston läheisyydessä. Lumivyöryjen todennäköisyys kasvaa säämuutosten myötä.';

  @override
  String get snowTypes => 'Lumityypit';

  @override
  String get newSnow => 'Uusi lumi';

  @override
  String get newSnowDesc => 'Vastasatanut pehmeä lumi.';

  @override
  String get freshWetSnow => 'Märkä uusi lumi';

  @override
  String get freshWetSnowDesc =>
      'Lunta, josta voit helposti tehdä lumipallon. Märkää lunta muodostuu sateen tapahtuessa lähellä nollaa tai reilusti suojan puolella.';

  @override
  String get powderSnow => 'Puuterilumi';

  @override
  String get powderSnowDesc =>
      'Vastasatanutta, irtonaista ja höyhenenkevyttä lunta. Puuterilunta muodostuu yleensä tyynellä ilmalla ja kovalla pakkasella.';

  @override
  String get freshSnow => 'Vitilumi';

  @override
  String get freshSnowDesc =>
      'Vastasatanutta, kevyttä, pehmeää ja hieman tiivistyvää pakkaslunta.';

  @override
  String get crust => 'Korppu';

  @override
  String get crustDesc =>
      'Kova hangen pinnalla oleva kansi. Korppu voi olla luonteeltaan tasaista tai rosoista.';

  @override
  String get concrete => 'Kantava korppu';

  @override
  String get concreteDesc =>
      'Tukeva ja kantava lumikansi, jonka pinta on usein hyvin kovaa ja tiivistä.';

  @override
  String get thinCrust => 'Ohut korppu';

  @override
  String get thinCrustDesc =>
      'Hiihtäjän painosta rikkoutuva lumikansi. Korpun alla lumi voi olla paikoitellen upottavaa.';

  @override
  String get collapsingCrust => 'Rikkoutuva korppu';

  @override
  String get collapsingCrustDesc =>
      'Satunnaisesti kantava, yllättäen rikkoutuva lumen pinta. Kansi voi olla hyvinkin paksu, jos sen alla on huokoista lunta.';

  @override
  String get windpackedSnow => 'Tuulen pieksemä lumi';

  @override
  String get windpackedSnowDesc =>
      'Tuulen kovettama ja moninpaikoin epätasaiseksi muotoilema lumi.';

  @override
  String get driftsAndBanks => 'Aaltoileva lumi';

  @override
  String get driftsAndBanksDesc =>
      'Tuulen muotoilema uuden lumen alue. Aallot ovat pehmeitä ja hyvin rikottavissa.';

  @override
  String get sastrug => 'Sastrugi';

  @override
  String get sastrugDesc =>
      'Tuulen aiheuttamaa lumiaallokkoa, joka on kovaa, jäistä ja terväharjanteista.';

  @override
  String get windblownSnow => 'Tuiskulumi';

  @override
  String get windblownSnowDesc =>
      'Tasainen, tuulen kerrostama ja pakkaama laatta tai linssi. Tuiskulunta voi kertyä myös ilman lumisadetta, jos tuuli siirtää lunta paikasta toiseen. Tuiskulunta syntyy yleensä suojapuolelle.';

  @override
  String get ice => 'Jää';

  @override
  String get iceDesc =>
      'Hangen pinnalla oleva kova ja rikkoutumaton jäinen kerros. Jää on syntynyt sulamis-jäätymisreaktion tuloksena.';

  @override
  String get breakableIce => 'Rikkoutuva jää';

  @override
  String get breakableIceDesc =>
      'Hangen pinnalla oleva kova ja rikkoutuva jäinen kerros.';

  @override
  String get slush => 'Sohjo';

  @override
  String get slushDesc => 'Vesipitoinen ja osittain sulanut lumi suojasäällä.';

  @override
  String get wettingSnow => 'Kastuva lumi';

  @override
  String get wettingSnowDesc =>
      'Lämpenemisen tai vesisateen myötä pinnalta alkaen märkä tai kostea lumi.';

  @override
  String get saturatedSnow => 'Saturoitunut lumi';

  @override
  String get saturatedSnowDesc =>
      'Märkä, läpi koko kerroksen sohjoutuva ja kermavaahtomainen lumi.';

  @override
  String get littleSnow => 'Vähäinen lumi';

  @override
  String get mapOfflineModeMessage =>
      'Olet offline-tilassa - käytetään tallennettuja karttatietoja';

  @override
  String get mapOfflineModeMessageNoData =>
      'Olet offline-tilassa - karttatietoja ei saatavilla';

  @override
  String get weather => 'Sää';

  @override
  String get dayBeforeYesterday => 'Toissapäivänä';

  @override
  String get yesterday => 'Eilen';

  @override
  String get now => 'Nyt';

  @override
  String get temperature => 'Lämpötila';

  @override
  String get snowDepth => 'Lumen syvyys';

  @override
  String get wind => 'Tuuli';

  @override
  String get airPressure => 'Ilmanpaine';

  @override
  String get north => 'Pohjoinen';

  @override
  String get northeast => 'Koillinen';

  @override
  String get east => 'Itä';

  @override
  String get southeast => 'Kaakko';

  @override
  String get south => 'Etelä';

  @override
  String get southwest => 'Lounas';

  @override
  String get west => 'Länsi';

  @override
  String get northwest => 'Luode';

  @override
  String get trend => 'Muutokset';

  @override
  String get lastFewDaysWeather => 'Lähipäivien sää';

  @override
  String get snowDepthChange => 'Lumensyvyyden kasvu';

  @override
  String get temperature3Days => 'Lämpötila 3 vuorokauden aikana';

  @override
  String get highest => 'Korkein';

  @override
  String get lowest => 'Matalin';

  @override
  String get countDaysAboveFreezing => 'Suojapäivien määrä';

  @override
  String get daysAboveFreezing => 'Suojapäivät';

  @override
  String get wind3Days => 'Tuuli 3 vuorokauden aikana';

  @override
  String get avgSpeed => 'Keskimääräinen nopeus';

  @override
  String get avgDirection => 'Keskimääräinen suunta';

  @override
  String get maxWind => 'Kovin tuuli';

  @override
  String get lastThreeDays => 'Viimeiset 3 päivää';

  @override
  String get lastSevenDays => 'Viimeiset 7 päivää';

  @override
  String get snowDefinitionsPageTitle => 'Määritelmät';

  @override
  String get noAvalancheWarning => 'Ei lumivyöryvaroitusta';

  @override
  String get close => 'Sulje';

  @override
  String get addObservation => 'Lisää havainto';

  @override
  String get rescue => 'Pelastus';

  @override
  String get rescuePageTitle => 'Pelastus';

  @override
  String get rescuePageCoordinateSystem => 'Koordinaattijärjestelmä';

  @override
  String get rescuePageShowOnMap => 'Näytä kartalla';

  @override
  String get rescuePageAccuracy => 'Sijainnin tarkkuus';

  @override
  String get rescuePageHelpRequestDescription =>
      'Hätäpyyntö ilmoittaa sijaintisi lähistöllä oleville pelastajille';

  @override
  String get rescuePageEmergencyCallDescription =>
      'Hätätilanteessa soita aina 112';

  @override
  String get rescuePageEmergencyCallFailed =>
      'Puhelinsovellusta ei voitu avata';

  @override
  String get rescuePageIndicateNeed => 'Ilmoita tarpeesi';

  @override
  String get rescuePageHealthIssue => 'Terveysongelma';

  @override
  String get rescuePageEquipmentIssue => 'Varusteongelma';

  @override
  String get rescuePageImLost => 'Olen eksynyt';

  @override
  String get rescuePageRequestHelp => 'Pyydä apua';

  @override
  String get rescuePageEndEvent => 'Lopeta tapahtuma';

  @override
  String get rescueEndEventDialogTitle => 'Lopeta avunpyyntö';

  @override
  String get rescueEndEventDialogDescription =>
      'Kuinka haluat lopettaa tämän avunpyynnön?';

  @override
  String get rescueEndEventDialogCancel => 'Peruuta avunpyyntö';

  @override
  String get rescueEndEventDialogComplete => 'Merkitse valmiiksi';

  @override
  String get rescuePageRequestHelpConfirm =>
      'Lähetetäänkö avunpyyntö lähellä oleville pelastajille?';

  @override
  String get map => 'Kartta';

  @override
  String get settings => 'Asetukset';

  @override
  String get callForHelp => 'Hälytä apua';

  @override
  String get currentLocation => 'Nykyinen sijainti';

  @override
  String get locationNotAvailable => 'Sijaintia ei saatavilla';

  @override
  String get userInformation => 'Käyttäjätiedot';

  @override
  String get userInformationSubtitle => 'Hallitse henkilökohtaisia tietojasi';

  @override
  String get settingsPageSnowDefinitions => 'Lumimääritelmät';

  @override
  String get settingsPageSnowDefinitionsSubtitle =>
      'Näytä lumityyppien määritelmät';

  @override
  String get language => 'Kieli';

  @override
  String get languageSubtitle => 'Vaihda sovelluksen kieli';

  @override
  String get selectLanguage => 'Valitse kieli';

  @override
  String get english => 'English';

  @override
  String get finnish => 'Suomi';

  @override
  String get userInfoNotImplemented => 'Käyttäjätietotoiminto tulossa pian';

  @override
  String get dialogConfirm => 'Vahvista';

  @override
  String get back => 'Takaisin';

  @override
  String get submit => 'Lähetä';

  @override
  String get obstacles => 'Esteet';

  @override
  String get selectSnowType => 'Valitse lumityyppi';

  @override
  String get specifySnowType => 'Täsmennä lumityyppi';

  @override
  String get dialogCancel => 'Peruuta';

  @override
  String get coordinateDirectionNorth => 'P';

  @override
  String get coordinateDirectionSouth => 'E';

  @override
  String get coordinateDirectionEast => 'I';

  @override
  String get coordinateDirectionWest => 'L';

  @override
  String get sensors => 'Anturit';

  @override
  String get segments => 'Segmentit';

  @override
  String get firstName => 'Etunimi';

  @override
  String get lastName => 'Sukunimi';

  @override
  String get fieldRequired => 'Pakollinen kenttä';

  @override
  String get email => 'Sähköposti';

  @override
  String get invalidEmail => 'Virheellinen sähköposti';

  @override
  String get password => 'Salasana';

  @override
  String get passwordTooShort => 'Salasana on liian lyhyt';

  @override
  String get confirmPassword => 'Vahvista salasana';

  @override
  String get passwordsDoNotMatch => 'Salasanat eivät täsmää';

  @override
  String get cancel => 'Peruuta';

  @override
  String get min6Characters => 'Vähintään 6 merkkiä';

  @override
  String get logIn => 'Kirjaudu sisään';

  @override
  String get register => 'Rekisteröidy';

  @override
  String get alreadyHaveAccount => 'Onko sinulla jo käyttäjä?';

  @override
  String get dontHaveAccount => 'Eikö sinulla ole käyttäjää?';

  @override
  String get passwordRequirements => 'Salasanan vaatimukset';

  @override
  String get registrationFailed => 'Rekisteröityminen epäonnistui';

  @override
  String get loginFailed => 'Kirjautuminen epäonnistui';

  @override
  String get loggedIn => 'Kirjauduttiin sisään';

  @override
  String get registeredSuccesfully => 'Rekisteröityminen onnistui';

  @override
  String get loggedInAs => 'Kirjautunut sisään käyttäjänä';

  @override
  String get role => 'Rooli';

  @override
  String get phoneNumber => 'Puhelinnumero';

  @override
  String get registeredAt => 'Rekisteröitynyt';

  @override
  String get logout => 'Kirjaudu ulos';

  @override
  String get guideHazards => 'Esteet';

  @override
  String get guideInfoFromUsers =>
      'Alla oleva tieto perustuu muiden käyttäjien havaintoihin.';

  @override
  String get timeJustNow => 'juuri äsken';

  @override
  String get timeUnderMinuteAgo => 'alle minuutti sitten';

  @override
  String get timeOneMinuteAgo => '1 minuutti sitten';

  @override
  String timeNMinutesAgo(Object minutes) {
    return '$minutes minuuttia sitten';
  }

  @override
  String get timeOneHourAgo => '1 tunti sitten';

  @override
  String timeNHoursAgo(Object hours) {
    return '$hours tuntia sitten';
  }

  @override
  String get timeOneDayAgo => '1 päivä sitten';

  @override
  String timeNDaysAgo(Object days) {
    return '$days päivää sitten';
  }

  @override
  String get dataPointUnavailable => 'Tuntematon';

  @override
  String get degrees => '°';

  @override
  String get degreesCelsius => '°C';

  @override
  String get metersPerSecond => 'm/s';

  @override
  String get centimeters => 'cm';

  @override
  String get stones => 'Kiviä';

  @override
  String get branches => 'Oksia';

  @override
  String get translationMissing => 'Virhe: Käännös puuttuu';
}

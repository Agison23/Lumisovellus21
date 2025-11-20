// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get snowAppInfo =>
      'Pallasen Pöllöt -sovellus tarjoaa tietoa alueen vallitsevista lumisuhteista.';

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
      'Tietojasi käytetään sovelluksen pelastustoimintoon. Toiminto auttaa pelastuspalvelua löytämään sinut helpommin 112.';

  @override
  String get fName => 'Etunimi';

  @override
  String get surname => 'Sukunimi';

  @override
  String get phoneNum => 'Puhelinnumero';

  @override
  String get definitions => 'MÄÄRITELMÄT';

  @override
  String get snowDefinitionsPageTitle => 'Määritelmät';

  @override
  String get avalancheWarning => 'Lumivyöryvaroitus';

  @override
  String get noAvalancheWarning => 'Ei lumivyöryvaroitusta';

  @override
  String get avalancheWarningDesc =>
      'Pallasen lumialueet sisältävät useita kuruja, kuten Pyhäkuru, Palkaskuru, Rihmakuru, sekä kaikki jyrkät rinteet yli 25° Lommoltunturilla, Keimiötunturilla ja Lehmäkerolla. Pienempiä yksittäisiä lumivyöryjä voi esiintyä myös muualla jyrkillä alueilla. Lumivyöryn todennäköisyys kasvaa säämuutosten myötä.';

  @override
  String get snowTypes => 'Lumityypit';

  @override
  String get newSnow => 'Uusi lumi';

  @override
  String get newSnowDesc => 'Vasta satanut pehmeä lumi.';

  @override
  String get freshWetSnow => 'Tuore märkä lumi';

  @override
  String get freshWetSnowDesc =>
      'Lumi, josta voi helposti tehdä lumipallon. Märkä lumi muodostuu sateesta ja nollan yläpuolisista lämpötiloista.';

  @override
  String get powderSnow => 'Höylälumi';

  @override
  String get powderSnowDesc =>
      'Tuore, irtonainen ja erittäin kevyt lumi. Höylälumet esiintyvät tyynellä ja erittäin kylmällä säällä.';

  @override
  String get freshSnow => 'Tuore lumi';

  @override
  String get freshSnowDesc =>
      'Tuore, kevyt, pehmeä ja hieman pakkautunut lumi.';

  @override
  String get crust => 'Kuori';

  @override
  String get crustDesc =>
      'Kova kuori lumipinnalla. Kuori voi olla tasainen tai epätasainen.';

  @override
  String get concrete => 'Betonilumi';

  @override
  String get concreteDesc => 'Kova ja tiivis lumikuori, yleensä erittäin kova.';

  @override
  String get thinCrust => 'Ohut kuori';

  @override
  String get thinCrustDesc =>
      'Kuori, joka murtuu hiihtäjän painosta. Kuoren alla lumi voi olla pehmeää ja uppoavaa.';

  @override
  String get collapsingCrust => 'Murtuva kuori';

  @override
  String get collapsingCrustDesc =>
      'Kiinteä, mutta ajoittain murtuva lumikuori. Kuori voi olla erittäin paksu, jos alla on huokoista lunta.';

  @override
  String get windpackedSnow => 'Tuulen pakkauttama lumi';

  @override
  String get windpackedSnowDesc =>
      'Tuulen kovettamaa lunta, joka on epätasainen monin paikoin.';

  @override
  String get driftsAndBanks => 'Tuulen muokkaamat kinokset ja paikat';

  @override
  String get driftsAndBanksDesc =>
      'Tuoreen lumen alue, jonka tuuli on muokannut. Aallot ovat pehmeitä ja helposti murrettavia.';

  @override
  String get sastrug => 'Sastrugi';

  @override
  String get sastrugDesc =>
      'Tuulen aiheuttama aaltoileva lumi, joka on kova, jäinen ja teräväreunainen.';

  @override
  String get windblownSnow => 'Tuulen siirtämä lumi';

  @override
  String get windblownSnowDesc =>
      'Tasainen, tuulen kerrostama ja tiivistynyt lumi. Tuulen siirtämää lunta voi kerääntyä ilman uutta lumisadetta, jos tuuli liikuttaa lunta paikasta toiseen. Usein muodostuu tuulen suojapuolelle tunturissa.';

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
  String get rescuePageRequestHelpConfirm =>
      'Lähetetäänkö avunpyyntö lähellä oleville pelastajille?';

  @override
  String get map => 'Kartta';

  @override
  String get weather => 'Sää';

  @override
  String get settings => 'Asetukset';

  @override
  String get callForHelp => 'Soita apua';

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
  String get settingsPageSnowDefinitionsSubtitle => 'Lumimääritelmät';

  @override
  String get language => 'Kieli';

  @override
  String get languageSubtitle => 'Vaihda sovelluksen kieli';

  @override
  String get selectLanguage => 'Valitse kieli';

  @override
  String get english => 'Englanti';

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
  String get loggedInAs => 'Kirjautunut sisään käyttäjällä';

  @override
  String get role => 'Rooli';

  @override
  String get phoneNumber => 'Puhelinnumero';

  @override
  String get registeredAt => 'Rekisteröitynyt';

  @override
  String get logout => 'Kirjaudu ulos';
}

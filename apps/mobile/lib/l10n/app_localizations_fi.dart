// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get snowAppInfo =>
      'Pallaksen Pöllöjen tuottama lumisovellus tarjoaa tietoja alueella vallitsevista lumiolosuhteista.';

  @override
  String get next => 'Seuraava';

  @override
  String get sharingLocation => 'SIJAINTITIEDON JAKAMINEN';

  @override
  String get rescueFeatureInfo =>
      'Sovelluksen pelastustoiminto kerää tietoja sijainnistasi. Sen avulla tarjoamme pelastamiseen tukea. Sijaintia käyttäen pelastuslaitos voi hyödyntää reittiäsi ja voit pyytää apua ympärillä olevilta kulkijoilta. Myös sinä voit auttaa muita. Voit koska tahansa poistaa sijainnin käytöstä.';

  @override
  String get allowSharing => 'SALLI JAKO';

  @override
  String get noLocationShare => 'Älä salli sijaintia';

  @override
  String get correctInfo => 'Syötäthän oikeat tietosi';

  @override
  String get infoUsage =>
      'Tietojasi käytetään sovelluksen pelastustoimintoon.\nToiminnon avulla pelastuslaitos voi hälytyksen tapahtuessa löytää sinut helpommin.';

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
  String get close => 'Sulje';

  @override
  String get addObservation => 'Lisää havainto';

  @override
  String get rescue => 'Pelastus';

  @override
  String get rescuePageTitle => 'Pelastus';

  @override
  String get rescuePageLatitude => 'Leveysaste';

  @override
  String get rescuePageLongitude => 'Pituusaste';

  @override
  String get rescuePageAccuracy => 'Paikannustarkkuus';

  @override
  String get rescuePageHelpRequestDescription =>
      'Avunpyyntö hälyttää ja lähettää sijaintisi lähellä oleville auttajille';

  @override
  String get rescuePageEmergencyCallDescription =>
      'Vakavassa hätätilanteessa soita hätänumeroon 112';

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
  String get rescuePageImLost => 'Olen eksyksissä';

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
  String get callForHelp => 'Pyydä apua';

  @override
  String get currentLocation => 'Nykyinen sijainti';

  @override
  String get locationNotAvailable => 'Sijainti ei saatavilla';

  @override
  String get userInformation => 'Käyttäjätiedot';

  @override
  String get userInformationSubtitle => 'Hallitse henkilökohtaisia tietojasi';

  @override
  String get settingsPageSnowDefinitions => 'Lumityypit';

  @override
  String get settingsPageSnowDefinitionsSubtitle =>
      'Näytä lumityyppien määritelmät';

  @override
  String get language => 'Kieli';

  @override
  String get languageSubtitle => 'Vaihda sovelluksen kieltä';

  @override
  String get selectLanguage => 'Valitse kieli';

  @override
  String get english => 'Englanti (English)';

  @override
  String get finnish => 'Suomi';

  @override
  String get userInfoNotImplemented => 'Käyttäjätieto-ominaisuus tulossa pian';

  @override
  String get dialogConfirm => 'Vahvista';

  @override
  String get dialogCancel => 'Peruuta';

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
}

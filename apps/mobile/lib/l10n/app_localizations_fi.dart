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
  String get mapOfflineModeMessage =>
      'Olet offline-tilassa - käytetään tallennettuja karttatietoja';
}

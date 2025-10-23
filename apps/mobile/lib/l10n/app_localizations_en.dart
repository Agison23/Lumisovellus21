// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get snowAppInfo =>
      'The snow application produced by Pallasen Pöllöt provides information about the prevailing snow conditions in the area.';

  @override
  String get next => 'Continue';

  @override
  String get sharingLocation => 'SHARING OF LOCATION INFORMATION';

  @override
  String get rescueFeatureInfo =>
      'The app\'s rescue feature collects information about your location. With it, we can provide help for rescues. Using your location, the rescue department can see the route you have taken and the app can request for help from other users around you. You can help other users, too. Location sharing can be disabled at any time.';

  @override
  String get allowSharing => 'ALLOW SHARING';

  @override
  String get noLocationShare => 'Do not allow location sharing';

  @override
  String get correctInfo => 'Make sure to enter the correct information';

  @override
  String get infoUsage =>
      'Your information will be used for the application\'s rescue function.\nThe function allows the rescue service to find you more easily in the event of an emergency.';

  @override
  String get fName => 'First name';

  @override
  String get surname => 'Last name';

  @override
  String get phoneNum => 'Phone number';

  @override
  String get definitions => 'DEFINITIONS';

  @override
  String get avalancheWarning => 'Avalanche warning';

  @override
  String get avalancheWarningDesc =>
      'The avalanche terrains of Pallas include several kurus such as Pyhäkuru, Palkaskuru,Rihmakuru and all steep slopes of over 25 degrees in Lommoltunturi, Keimiötunturi and Lehmäkero.Individual smaller avalanches can also occur elsewhere in the vicinity of steep terrain.The likelihood of an avalanche increases with weather changes.';

  @override
  String get snowTypes => 'Snow types';

  @override
  String get newSnow => 'New snow';

  @override
  String get newSnowDesc => 'Freshly rained soft snow.';

  @override
  String get freshWetSnow => 'Fresh wet snow';

  @override
  String get freshWetSnowDesc =>
      'Snow, from which you can easily make a snowball. Wet snow forms due to rain and temperatures above freezing point';

  @override
  String get powderSnow => 'Powder snow';

  @override
  String get powderSnowDesc =>
      'Fresh, loose ja extremely light snow. Powder snowfall occurs in calm and very cold weather.';

  @override
  String get freshSnow => 'Fresh snow';

  @override
  String get freshSnowDesc => 'Fresh, light, soft and slightly packed snow.';

  @override
  String get crust => 'Crust';

  @override
  String get crustDesc =>
      'A hard crust on the surface of the snow. The crust can be flat or jagged.';

  @override
  String get concrete => 'Concrete';

  @override
  String get concreteDesc =>
      'Solid snow crust, which is usually extremely hard and compact.';

  @override
  String get thinCrust => 'Thin crust';

  @override
  String get thinCrustDesc =>
      'A crust that that breaks from the weight of a skier. Under the crust, the snow can be submersive.';

  @override
  String get collapsingCrust => 'Collapsing crust';

  @override
  String get collapsingCrustDesc =>
      'Firm, however occasionally breaking crust of snow. The crust can be extremely thick, if there is porous snow underneath.';

  @override
  String get windpackedSnow => 'Windpacked snow';

  @override
  String get windpackedSnowDesc =>
      'Snow hardened by the wind and uneven in many places.';

  @override
  String get driftsAndBanks => 'Drifts and banks of windblown snow';

  @override
  String get driftsAndBanksDesc =>
      'An area of new snow shaped by the wind. waves are soft and easy to break.';

  @override
  String get sastrug => 'Sastrug';

  @override
  String get sastrugDesc =>
      'Wind-induced wavy snow, which is hard, icy and has sharp ridges.';

  @override
  String get windblownSnow => 'Windblown snow';

  @override
  String get windblownSnowDesc =>
      'Flat, wind-layered and compressed tile or lens. Windblown snow can also accumulate without snowfall if wind moves snow from one place to another. Windblown snow is usually formed on the side of the fell protected from wind.';

  @override
  String get ice => 'Ice';

  @override
  String get iceDesc =>
      'A hard and unbreakable icy layer on the surface of the snow. Hard, glazed surface caused by melt-freeze process.';

  @override
  String get breakableIce => 'Brekable ice';

  @override
  String get breakableIceDesc =>
      'A hard and breakable icy layer on the surface of the snow.';

  @override
  String get slush => 'Slush';

  @override
  String get slushDesc =>
      'Wet and partially melted snow in above zero degrees weather.';

  @override
  String get wettingSnow => 'Wetting snow';

  @override
  String get wettingSnowDesc =>
      'Wet or moist snow resulting from warm weather or rainfall.';

  @override
  String get saturatedSnow => 'Saturated snow';

  @override
  String get saturatedSnowDesc =>
      'Completely wet , slushing and whipped cream like snow.';

  @override
  String get littleSnow => 'Little snow';

  @override
  String get mapOfflineModeMessage =>
      'You\'re offline - showing saved map data';
}

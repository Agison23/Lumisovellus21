import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart' deferred as app_localizations_en;
import 'app_localizations_fi.dart' deferred as app_localizations_fi;

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fi'),
  ];

  /// No description provided for @snowAppInfo.
  ///
  /// In en, this message translates to:
  /// **'The snow application produced by Pallasen Pöllöt provides information about the prevailing snow conditions in the area.'**
  String get snowAppInfo;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get next;

  /// No description provided for @sharingLocation.
  ///
  /// In en, this message translates to:
  /// **'SHARING OF LOCATION INFORMATION'**
  String get sharingLocation;

  /// No description provided for @rescueFeatureInfo.
  ///
  /// In en, this message translates to:
  /// **'The app\'\'s rescue feature collects information about your location. With it, we can provide help for rescues. Using your location, the rescue department can see the route you have taken and the app can request help from other users around you. You can help other users, too. Location sharing can be disabled at any time.'**
  String get rescueFeatureInfo;

  /// No description provided for @allowSharing.
  ///
  /// In en, this message translates to:
  /// **'ALLOW SHARING'**
  String get allowSharing;

  /// No description provided for @noLocationShare.
  ///
  /// In en, this message translates to:
  /// **'Do not allow location sharing'**
  String get noLocationShare;

  /// No description provided for @correctInfo.
  ///
  /// In en, this message translates to:
  /// **'Make sure to enter the correct information'**
  String get correctInfo;

  /// No description provided for @infoUsage.
  ///
  /// In en, this message translates to:
  /// **'Your information will be used for the application\'\'s rescue function.\nThe function allows the rescue service to find you more easily in the event of an emergency.'**
  String get infoUsage;

  /// No description provided for @fName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get fName;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get surname;

  /// No description provided for @phoneNum.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNum;

  /// No description provided for @definitions.
  ///
  /// In en, this message translates to:
  /// **'DEFINITIONS'**
  String get definitions;

  /// No description provided for @snowDefinitionsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Definitions'**
  String get snowDefinitionsPageTitle;

  /// No description provided for @avalancheWarning.
  ///
  /// In en, this message translates to:
  /// **'Avalanche warning'**
  String get avalancheWarning;

  /// No description provided for @noAvalancheWarning.
  ///
  /// In en, this message translates to:
  /// **'No avalanche warning'**
  String get noAvalancheWarning;

  /// No description provided for @avalancheWarningDesc.
  ///
  /// In en, this message translates to:
  /// **'The avalanche terrains of Pallas include several kurus such as Pyhäkuru, Palkaskuru, Rihmakuru and all steep slopes of over 25 degrees in Lommoltunturi, Keimiötunturi and Lehmäkero. Individual smaller avalanches can also occur elsewhere in the vicinity of steep terrain. The likelihood of an avalanche increases with weather changes.'**
  String get avalancheWarningDesc;

  /// No description provided for @snowTypes.
  ///
  /// In en, this message translates to:
  /// **'Snow types'**
  String get snowTypes;

  /// No description provided for @newSnow.
  ///
  /// In en, this message translates to:
  /// **'New snow'**
  String get newSnow;

  /// No description provided for @newSnowDesc.
  ///
  /// In en, this message translates to:
  /// **'Freshly rained soft snow.'**
  String get newSnowDesc;

  /// No description provided for @freshWetSnow.
  ///
  /// In en, this message translates to:
  /// **'Fresh wet snow'**
  String get freshWetSnow;

  /// No description provided for @freshWetSnowDesc.
  ///
  /// In en, this message translates to:
  /// **'Snow from which you can easily make a snowball. Wet snow forms due to rain and temperatures above freezing point.'**
  String get freshWetSnowDesc;

  /// No description provided for @powderSnow.
  ///
  /// In en, this message translates to:
  /// **'Powder snow'**
  String get powderSnow;

  /// No description provided for @powderSnowDesc.
  ///
  /// In en, this message translates to:
  /// **'Fresh, loose and extremely light snow. Powder snow forms in calm and very cold weather.'**
  String get powderSnowDesc;

  /// No description provided for @freshSnow.
  ///
  /// In en, this message translates to:
  /// **'Fresh snow'**
  String get freshSnow;

  /// No description provided for @freshSnowDesc.
  ///
  /// In en, this message translates to:
  /// **'Fresh, light, soft and slightly packed snow.'**
  String get freshSnowDesc;

  /// No description provided for @crust.
  ///
  /// In en, this message translates to:
  /// **'Crust'**
  String get crust;

  /// No description provided for @crustDesc.
  ///
  /// In en, this message translates to:
  /// **'A hard crust on the surface of the snow. The crust can be flat or jagged.'**
  String get crustDesc;

  /// No description provided for @concrete.
  ///
  /// In en, this message translates to:
  /// **'Concrete'**
  String get concrete;

  /// No description provided for @concreteDesc.
  ///
  /// In en, this message translates to:
  /// **'Solid snow crust, which is usually extremely hard and compact.'**
  String get concreteDesc;

  /// No description provided for @thinCrust.
  ///
  /// In en, this message translates to:
  /// **'Thin crust'**
  String get thinCrust;

  /// No description provided for @thinCrustDesc.
  ///
  /// In en, this message translates to:
  /// **'A crust that breaks from the weight of a skier. Under the crust, the snow can be submersive.'**
  String get thinCrustDesc;

  /// No description provided for @collapsingCrust.
  ///
  /// In en, this message translates to:
  /// **'Collapsing crust'**
  String get collapsingCrust;

  /// No description provided for @collapsingCrustDesc.
  ///
  /// In en, this message translates to:
  /// **'Firm, however occasionally breaking crust of snow. The crust can be extremely thick if there is porous snow underneath.'**
  String get collapsingCrustDesc;

  /// No description provided for @windpackedSnow.
  ///
  /// In en, this message translates to:
  /// **'Windpacked snow'**
  String get windpackedSnow;

  /// No description provided for @windpackedSnowDesc.
  ///
  /// In en, this message translates to:
  /// **'Snow hardened by the wind and uneven in many places.'**
  String get windpackedSnowDesc;

  /// No description provided for @driftsAndBanks.
  ///
  /// In en, this message translates to:
  /// **'Drifts and banks of windblown snow'**
  String get driftsAndBanks;

  /// No description provided for @driftsAndBanksDesc.
  ///
  /// In en, this message translates to:
  /// **'An area of new snow shaped by the wind. Waves are soft and easy to break.'**
  String get driftsAndBanksDesc;

  /// No description provided for @sastrug.
  ///
  /// In en, this message translates to:
  /// **'Sastrug'**
  String get sastrug;

  /// No description provided for @sastrugDesc.
  ///
  /// In en, this message translates to:
  /// **'Wind-induced wavy snow, which is hard, icy and has sharp ridges.'**
  String get sastrugDesc;

  /// No description provided for @windblownSnow.
  ///
  /// In en, this message translates to:
  /// **'Windblown snow'**
  String get windblownSnow;

  /// No description provided for @windblownSnowDesc.
  ///
  /// In en, this message translates to:
  /// **'Flat, wind-layered and compressed tile or lens. Windblown snow can also accumulate without snowfall if wind moves snow from one place to another. Windblown snow is usually formed on the side of the fell protected from wind.'**
  String get windblownSnowDesc;

  /// No description provided for @ice.
  ///
  /// In en, this message translates to:
  /// **'Ice'**
  String get ice;

  /// No description provided for @iceDesc.
  ///
  /// In en, this message translates to:
  /// **'A hard and unbreakable icy layer on the surface of the snow. Hard, glazed surface caused by melt-freeze process.'**
  String get iceDesc;

  /// No description provided for @breakableIce.
  ///
  /// In en, this message translates to:
  /// **'Breakable ice'**
  String get breakableIce;

  /// No description provided for @breakableIceDesc.
  ///
  /// In en, this message translates to:
  /// **'A hard and breakable icy layer on the surface of the snow.'**
  String get breakableIceDesc;

  /// No description provided for @slush.
  ///
  /// In en, this message translates to:
  /// **'Slush'**
  String get slush;

  /// No description provided for @slushDesc.
  ///
  /// In en, this message translates to:
  /// **'Wet and partially melted snow in above zero degree weather.'**
  String get slushDesc;

  /// No description provided for @wettingSnow.
  ///
  /// In en, this message translates to:
  /// **'Wetting snow'**
  String get wettingSnow;

  /// No description provided for @wettingSnowDesc.
  ///
  /// In en, this message translates to:
  /// **'Wet or moist snow resulting from warm weather or rainfall.'**
  String get wettingSnowDesc;

  /// No description provided for @saturatedSnow.
  ///
  /// In en, this message translates to:
  /// **'Saturated snow'**
  String get saturatedSnow;

  /// No description provided for @saturatedSnowDesc.
  ///
  /// In en, this message translates to:
  /// **'Completely wet, slushing and whipped cream-like snow.'**
  String get saturatedSnowDesc;

  /// No description provided for @littleSnow.
  ///
  /// In en, this message translates to:
  /// **'Little snow'**
  String get littleSnow;

  /// No description provided for @mapOfflineModeMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'\'re offline - showing saved map data'**
  String get mapOfflineModeMessage;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @addObservation.
  ///
  /// In en, this message translates to:
  /// **'Add observation'**
  String get addObservation;

  /// No description provided for @rescue.
  ///
  /// In en, this message translates to:
  /// **'Rescue'**
  String get rescue;

  /// No description provided for @rescuePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Rescue'**
  String get rescuePageTitle;

  /// No description provided for @rescuePageLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get rescuePageLatitude;

  /// No description provided for @rescuePageLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get rescuePageLongitude;

  /// No description provided for @rescuePageAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Position accuracy'**
  String get rescuePageAccuracy;

  /// No description provided for @rescuePageHelpRequestDescription.
  ///
  /// In en, this message translates to:
  /// **'Help request alerts and sends your location to nearby rescuers'**
  String get rescuePageHelpRequestDescription;

  /// No description provided for @rescuePageEmergencyCallDescription.
  ///
  /// In en, this message translates to:
  /// **'In serious emergency, call the emergency number 112'**
  String get rescuePageEmergencyCallDescription;

  /// No description provided for @rescuePageEmergencyCallFailed.
  ///
  /// In en, this message translates to:
  /// **'The phone app could not be opened'**
  String get rescuePageEmergencyCallFailed;

  /// No description provided for @rescuePageIndicateNeed.
  ///
  /// In en, this message translates to:
  /// **'Please indicate your need'**
  String get rescuePageIndicateNeed;

  /// No description provided for @rescuePageHealthIssue.
  ///
  /// In en, this message translates to:
  /// **'Health issue'**
  String get rescuePageHealthIssue;

  /// No description provided for @rescuePageEquipmentIssue.
  ///
  /// In en, this message translates to:
  /// **'Equipment issue'**
  String get rescuePageEquipmentIssue;

  /// No description provided for @rescuePageImLost.
  ///
  /// In en, this message translates to:
  /// **'I am lost'**
  String get rescuePageImLost;

  /// No description provided for @rescuePageRequestHelp.
  ///
  /// In en, this message translates to:
  /// **'Request help'**
  String get rescuePageRequestHelp;

  /// No description provided for @rescuePageRequestHelpConfirm.
  ///
  /// In en, this message translates to:
  /// **'Send help request to nearby rescuers?'**
  String get rescuePageRequestHelpConfirm;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @weather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weather;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @callForHelp.
  ///
  /// In en, this message translates to:
  /// **'Call for Help'**
  String get callForHelp;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @locationNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Location not available'**
  String get locationNotAvailable;

  /// No description provided for @userInformation.
  ///
  /// In en, this message translates to:
  /// **'User Information'**
  String get userInformation;

  /// No description provided for @userInformationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your personal information'**
  String get userInformationSubtitle;

  /// No description provided for @settingsPageSnowDefinitions.
  ///
  /// In en, this message translates to:
  /// **'Snow definitions'**
  String get settingsPageSnowDefinitions;

  /// No description provided for @settingsPageSnowDefinitionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show snow type definitions'**
  String get settingsPageSnowDefinitionsSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get languageSubtitle;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @finnish.
  ///
  /// In en, this message translates to:
  /// **'Finnish (Suomi)'**
  String get finnish;

  /// No description provided for @userInfoNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'User information feature coming soon'**
  String get userInfoNotImplemented;

  /// No description provided for @dialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get dialogConfirm;

  /// No description provided for @dialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogCancel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return lookupAppLocalizations(locale);
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

Future<AppLocalizations> lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return app_localizations_en.loadLibrary().then(
        (dynamic _) => app_localizations_en.AppLocalizationsEn(),
      );
    case 'fi':
      return app_localizations_fi.loadLibrary().then(
        (dynamic _) => app_localizations_fi.AppLocalizationsFi(),
      );
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

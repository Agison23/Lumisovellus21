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
    Locale('fi')
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
  /// **'The app\'\'s rescue feature collects information about your location. With it, we can provide help for rescues. Using your location, the rescue department can see the route you have taken and the app can request for help from other users around you. You can help other users, too. Location sharing can be disabled at any time.'**
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
      return app_localizations_en
          .loadLibrary()
          .then((dynamic _) => app_localizations_en.AppLocalizationsEn());
    case 'fi':
      return app_localizations_fi
          .loadLibrary()
          .then((dynamic _) => app_localizations_fi.AppLocalizationsFi());
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

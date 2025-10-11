import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get snowAppInfo => 'The snow application produced by Pallasen Pöllöt provides information about the prevailing snow conditions in the area.';

  @override
  String get next => 'Continue';

  @override
  String get sharingLocation => 'SHARING OF LOCATION INFORMATION';

  @override
  String get rescueFeatureInfo => 'The app\'s rescue feature collects information about your location. With it, we can provide help for rescues. Using your location, the rescue department can see the route you have taken and the app can request for help from other users around you. You can help other users, too. Location sharing can be disabled at any time.';

  @override
  String get allowSharing => 'ALLOW SHARING';

  @override
  String get noLocationShare => 'Do not allow location sharing';

  @override
  String get correctInfo => 'Make sure to enter the correct information';

  @override
  String get infoUsage => 'Your information will be used for the application\'s rescue function.\nThe function allows the rescue service to find you more easily in the event of an emergency.';

  @override
  String get fName => 'First name';

  @override
  String get surname => 'Last name';

  @override
  String get phoneNum => 'Phone number';
}

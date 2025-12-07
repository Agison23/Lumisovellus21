// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get snowAppInfo =>
      'The snow application produced by Pallaksen Pöllöt provides information about the prevailing snow conditions in the area.';

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
      'The avalanche terrains of Pallas include several kurus such as Pyhäkuru, Palkaskuru, Rihmakuru and all steep slopes of over 25 degrees in Lommoltunturi, Keimiötunturi and Lehmäkero. Individual smaller avalanches can also occur elsewhere in the vicinity of steep terrain. The likelihood of an avalanche increases with weather changes.';

  @override
  String get snowTypes => 'Snow types';

  @override
  String get newSnow => 'New snow';

  @override
  String get newSnowDesc => 'Freshly landed soft snow.';

  @override
  String get freshWetSnow => 'Fresh wet snow';

  @override
  String get freshWetSnowDesc =>
      'Snow from which you can easily make a snowball. Wet snow forms due to rain and temperatures above freezing point.';

  @override
  String get powderSnow => 'Powder snow';

  @override
  String get powderSnowDesc =>
      'Fresh, loose and extremely light snow. Powder snowfall occurs in calm and very cold weather.';

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
      'A crust that breaks from the weight of a skier. Under the crust, a foot may sink deep.';

  @override
  String get collapsingCrust => 'Collapsing crust';

  @override
  String get collapsingCrustDesc =>
      'Firm, however occasionally breaking crust of snow. The crust can be extremely thick if there is porous snow underneath.';

  @override
  String get windpackedSnow => 'Windpacked snow';

  @override
  String get windpackedSnowDesc =>
      'Snow hardened by the wind and uneven in many places.';

  @override
  String get driftsAndBanks => 'Drifts and banks of windblown snow';

  @override
  String get driftsAndBanksDesc =>
      'An area of new snow shaped by the wind. Waves are soft and easy to break.';

  @override
  String get sastrug => 'Sastrug';

  @override
  String get sastrugDesc =>
      'Wind-induced wavy snow, which is hard, icy and has sharp ridges.';

  @override
  String get windblownSnow => 'Windblown snow';

  @override
  String get windblownSnowDesc =>
      'Flat, wind-layered and compressed tile or lens. Windblown snow can also accumulate without snowfall if wind moves snow from one place to another. Windblown snow is usually formed on the side of the fell protected from the wind.';

  @override
  String get ice => 'Ice';

  @override
  String get iceDesc =>
      'A hard and unbreakable icy layer on the surface of the snow. Hard, glazed surface caused by melt-freeze process.';

  @override
  String get breakableIce => 'Breakable ice';

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
      'Completely wet, slushing and whipped cream-like snow.';

  @override
  String get littleSnow => 'Little snow';

  @override
  String get mapOfflineModeMessage =>
      'You\'re offline - showing saved map data';

  @override
  String get mapOfflineModeMessageNoData =>
      'You\'re offline - no map data available';

  @override
  String get weather => 'Weather';

  @override
  String get dayBeforeYesterday => '2 days ago';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get now => 'Now';

  @override
  String get temperature => 'Temperature';

  @override
  String get snowDepth => 'Snow depth';

  @override
  String get wind => 'Wind';

  @override
  String get airPressure => 'Air pressure';

  @override
  String get north => 'North';

  @override
  String get northeast => 'Northeast';

  @override
  String get east => 'East';

  @override
  String get southeast => 'Southeast';

  @override
  String get south => 'South';

  @override
  String get southwest => 'Southwest';

  @override
  String get west => 'West';

  @override
  String get northwest => 'Northwest';

  @override
  String get trend => 'Trend';

  @override
  String get lastFewDaysWeather => 'Recent weather';

  @override
  String get snowDepthChange => 'Change in snow depth';

  @override
  String get temperature3Days => 'Temperature over 3 days';

  @override
  String get highest => 'Highest';

  @override
  String get lowest => 'Lowest';

  @override
  String get countDaysAboveFreezing => 'Number of days above freezing';

  @override
  String get daysAboveFreezing => 'Days above freezing';

  @override
  String get wind3Days => 'Wind over 3 days';

  @override
  String get avgSpeed => 'Average speed';

  @override
  String get avgDirection => 'Average direction';

  @override
  String get maxWind => 'Maximum wind speed';

  @override
  String get lastThreeDays => 'Last three days';

  @override
  String get lastSevenDays => 'Last seven days';

  @override
  String get snowDefinitionsPageTitle => 'Definitions';

  @override
  String get noAvalancheWarning => 'No avalanche warning';

  @override
  String get close => 'Close';

  @override
  String get addObservation => 'Add observation';

  @override
  String get rescue => 'Rescue';

  @override
  String get rescuePageTitle => 'Rescue';

  @override
  String get rescuePageCoordinateSystem => 'Coordinate system';

  @override
  String get rescuePageShowOnMap => 'Show on map';

  @override
  String get rescuePageAccuracy => 'Position accuracy';

  @override
  String get rescuePageHelpRequestDescription =>
      'A help request alerts and sends your location to nearby rescuers';

  @override
  String get rescuePageEmergencyCallDescription =>
      'In an emergency, always call 112';

  @override
  String get rescuePageEmergencyCallFailed =>
      'The phone app could not be opened';

  @override
  String get rescuePageIndicateNeed => 'Please indicate your need';

  @override
  String get rescuePageHealthIssue => 'Health issue';

  @override
  String get rescuePageEquipmentIssue => 'Equipment issue';

  @override
  String get rescuePageImLost => 'I am lost';

  @override
  String get rescuePageRequestHelp => 'Request Help';

  @override
  String get rescuePageEndEvent => 'End Event';

  @override
  String get rescueEndEventDialogTitle => 'End Help Event';

  @override
  String get rescueEndEventDialogDescription =>
      'How would you like to end this help event?';

  @override
  String get rescueEndEventDialogCancel => 'Cancel Event';

  @override
  String get rescueEndEventDialogComplete => 'Complete Event';

  @override
  String get rescuePageRequestHelpConfirm =>
      'Send help request to nearby rescuers?';

  @override
  String get map => 'Map';

  @override
  String get settings => 'Settings';

  @override
  String get callForHelp => 'Call for Help';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get locationNotAvailable => 'Location not available';

  @override
  String get userInformation => 'User Information';

  @override
  String get userInformationSubtitle => 'Manage your personal information';

  @override
  String get settingsPageSnowDefinitions => 'Snow definitions';

  @override
  String get settingsPageSnowDefinitionsSubtitle =>
      'Show snow type definitions';

  @override
  String get language => 'Language';

  @override
  String get languageSubtitle => 'Change app language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get finnish => 'Suomi';

  @override
  String get userInfoNotImplemented => 'User information feature coming soon';

  @override
  String get dialogConfirm => 'Confirm';

  @override
  String get back => 'Back';

  @override
  String get submit => 'Submit';

  @override
  String get obstacles => 'Obstacles';

  @override
  String get selectSnowType => 'Select snow type';

  @override
  String get specifySnowType => 'Specify snow type';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get coordinateDirectionNorth => 'N';

  @override
  String get coordinateDirectionSouth => 'S';

  @override
  String get coordinateDirectionEast => 'E';

  @override
  String get coordinateDirectionWest => 'W';

  @override
  String get sensors => 'Sensors';

  @override
  String get segments => 'Segments';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get email => 'Email';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String get password => 'Password';

  @override
  String get passwordTooShort => 'Password is too short';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get cancel => 'Cancel';

  @override
  String get min6Characters => 'At least 6 characters';

  @override
  String get logIn => 'Log in';

  @override
  String get register => 'Register';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get passwordRequirements => 'Password Requirements';

  @override
  String get registrationFailed => 'Registration failed';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get loggedIn => 'Logged in';

  @override
  String get registeredSuccesfully => 'Registered successfully';

  @override
  String get loggedInAs => 'Logged in as';

  @override
  String get role => 'Role';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get registeredAt => 'Registered at';

  @override
  String get logout => 'Logout';

  @override
  String get guideHazards => 'Hazards';

  @override
  String get guideInfoFromUsers =>
      'The information below is based on observations from other users.';

  @override
  String get timeJustNow => 'just now';

  @override
  String get timeUnderMinuteAgo => 'under a minute ago';

  @override
  String get timeOneMinuteAgo => '1 minute ago';

  @override
  String timeNMinutesAgo(Object minutes) {
    return '$minutes minutes ago';
  }

  @override
  String get timeOneHourAgo => '1 hour ago';

  @override
  String timeNHoursAgo(Object hours) {
    return '$hours hours ago';
  }

  @override
  String get timeOneDayAgo => '1 day ago';

  @override
  String timeNDaysAgo(Object days) {
    return '$days days ago';
  }

  @override
  String get dataPointUnavailable => 'Unknown';

  @override
  String get degrees => '°';

  @override
  String get degreesCelsius => '°C';

  @override
  String get metersPerSecond => 'm/s';

  @override
  String get centimeters => 'cm';

  @override
  String get stones => 'Stones';

  @override
  String get branches => 'Branches';

  @override
  String get translationMissing => 'Error: Translation missing';

  @override
  String get errorNoInternetConnection =>
      'No internet connection. Please check your network and try again.';

  @override
  String get errorConnectionFailed =>
      'Connection failed. Please try again later.';

  @override
  String get errorRequestHelpFailed =>
      'Failed to request help. Please try again.';

  @override
  String get errorCancelHelpFailed =>
      'Failed to cancel help request. Please try again.';

  @override
  String get errorCompleteHelpFailed =>
      'Failed to complete help request. Please try again.';

  @override
  String get errorServerUnavailable =>
      'Server is temporarily unavailable. Please try again later.';

  @override
  String get errorUnknown => 'An unexpected error occurred. Please try again.';

  @override
  String get settingsDefaultTab => 'Default Tab';

  @override
  String get settingsDefaultTabSubtitle =>
      'Choose which screen to show when the app starts';

  @override
  String get settingsDefaultTabRescue => 'Rescue';

  @override
  String get settingsDefaultTabMap => 'Map';

  @override
  String get settingsDefaultTabWeather => 'Weather';

  @override
  String get settingsDefaultTabSettings => 'Settings';
}

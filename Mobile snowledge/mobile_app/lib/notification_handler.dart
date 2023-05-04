import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_app/state/appState.dart';
import 'onboarding.dart';
import 'help_offered.dart';
import 'main.dart';
import 'package:mobile_app/translations/translations.dart';

class NotificationHandler {
  static final NotificationHandler _notificationService =
      NotificationHandler._internal();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationHandler() {
    return _notificationService;
  }

  Future<void> init(context) async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logo_transparent_black');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification:
            onSelectNotification); //(context) => selectNotification
  }

  Future onSelectNotification(String? payload) async {
    try {
      //if notification = new help request alert notification
      if (payload != "") {
        await MyApp.navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => HelpOffered(payload, true)));
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  void onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    try {
      await MyApp.navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => const OnBoardingPage()));
    } catch (e) {
      // print(e.toString());
    }
  }

  NotificationHandler._internal();

  static const IOSNotificationDetails _iosNotificationDetails =
      IOSNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          badgeNumber: 1,
          attachments: null,
          subtitle: "",
          threadIdentifier: "threadID");

  static void cancelPushUpNotification({int id = 12345}) {
    flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> helpRequestCancelledNotification(AppState state,
      {int id = 12345}) async {
    flutterLocalNotificationsPlugin.show(
      id,
      translations['requestOver1'][state.language],
      translations['requestOver2'][state.language],
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name',
              channelDescription: 'your channel description',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker'),
          iOS: _iosNotificationDetails),
    );
  }

  static Future<void> helperCancelledAcceptanceNotification(AppState state,
      {int id = 12345}) async {
    String? payload = "";
    flutterLocalNotificationsPlugin.show(
      id,
      translations['helperEnded'][state.language],
      "",
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name',
              channelDescription: 'your channel description',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker'),
          iOS: _iosNotificationDetails),
    );
  }

  static Future<void> pushUpNotification(
      String coords, String distance, AppState state,
      {int id = 12345}) async {
    String payload = coords + ':' + distance;
    flutterLocalNotificationsPlugin.show(
        id,
        translations['reqDist1'][state.language] +
            '$distance' +
            translations['reqDist2'][state.language],
        translations['seeRequest'][state.language],
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description',
                importance: Importance.max,
                priority: Priority.high,
                ticker: 'ticker'),
            iOS: _iosNotificationDetails),
        payload: payload);
  }

  static Future<void> locationCancelledRequestNotification(
      AppState state, String user,
      {int id = 12345}) async {
    String title = '';
    String text = '';

    if (user == 'help_requester') {
      title = translations['requesterReqOverAutomatically1'][state.language];
      text = translations['requesterReqOverAutomatically2'][state.language];
    } else if (user == 'helper') {
      title = translations['helperReqOverAutomatically1'][state.language];
      text = translations['helperReqOverAutomatically2'][state.language];
    }

    flutterLocalNotificationsPlugin.show(
      id,
      title,
      text,
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name',
              channelDescription: 'your channel description',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker'),
          iOS: _iosNotificationDetails),
    );
  }

  static Future<void> helpModeBatteryLowNotification(
      AppState state, String user,
      {int id = 12345}) async {
    String title = '';
    String text = '';

    if (user == 'help_requester') {
      title = translations['lowBatteryTitle'][state.language];
      text = translations['lowBatteryWarningHelper'][state.language];
    } else if (user == 'helper') {
      title = translations['lowBatteryTitle'][state.language];
      text = translations['lowBatteryWarningRequester'][state.language];
    }

    flutterLocalNotificationsPlugin.show(
      id,
      title,
      text,
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name',
              channelDescription: 'your channel description',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker'),
          iOS: _iosNotificationDetails),
    );
  }

  static Future<void> newMessageNotification(message, sender, AppState state,
      {int id = 12345}) async {
    flutterLocalNotificationsPlugin.show(
      id,
      translations[sender][state.language] +
          translations['hasSent'][state.language],
      message,
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name',
              channelDescription: 'your channel description',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker'),
          iOS: _iosNotificationDetails),
    );
  }
}

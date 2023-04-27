import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../state/appState.dart';

class Utility {
  /// Returns the time between the date passed in arguments and the current date
  static String getTimeAgo(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    String time = '';
    var dt = DateTime.parse(date).toLocal();

    if (DateTime.now().toLocal().isBefore(dt)) {
      return DateFormat.jm().format(DateTime.parse(date).toLocal()).toString();
    }

    var dur = DateTime.now().toLocal().difference(dt);
    if (dur.inDays > 365) {
      time = DateFormat.yMMMd().format(dt);
    } else if (dur.inDays > 30) {
      time = DateFormat.yMMMd().format(dt);
    } else if (dur.inDays > 0) {
      time = '${dur.inDays} d';
    } else if (dur.inHours > 0) {
      time = '${dur.inHours} h';
    } else if (dur.inMinutes > 0) {
      time = '${dur.inMinutes} min';
    } else if (dur.inSeconds > 0) {
      time = '${dur.inSeconds} sec';
    } else {
      time = 'now';
    }
    return time;
  }

  static bool getSummerOrWinter() {
    int month = DateTime.now().month;
    int day = DateTime.now().day;
    bool winter;

    // summertime 10.6. -> 15.10.
    if ((month > 5 && month < 11)) {
      if (month == 6 && day < 10) {
        winter = true;
      } else if (month == 10 && day > 15) {
        winter = true;
      } else {
        winter = false;
      }
    } else {
      winter = true;
    }

    return winter;
  }

  static Future<Map<String, String>> parseStringToMap(
      {String assetsFileName = '.env'}) async {
    final lines = await rootBundle.loadString(assetsFileName);
    Map<String, String> environment = {};
    for (String line in lines.split('\n')) {
      line = line.trim();
      if (line.contains('=') //Set Key Value Pairs on lines separated by =
          &&
          !line.startsWith(RegExp(r'=|#'))) {
        //No need to add emty keys and remove comments
        List<String> contents = line.split('=');
        environment[contents[0]] = contents.sublist(1).join('=');
      }
    }
    return environment;
  }

  // Creates a new chat room, with ID being the phone number of this user
  static void createChatRoom(BuildContext context) {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    var appState = Provider.of<AppState>(context, listen: false);
    String? phoneNum;

    prefs.then((pref) {
      phoneNum = pref.getString('pNumber');

      final _firestore = FirebaseFirestore.instance;
      final data = {
        'users': [
          // Only add the phone number of this request as the "requester", with a red color
          {'$phoneNum': 'red'},
        ]
      };
      try {
        final createdRoom = _firestore.collection('Rooms').doc(phoneNum);
        createdRoom.set(data);
        createdRoom.collection('Messages'); // create Messages sub-collection
        appState.setChatRoomId = phoneNum!;
      } catch (e) {
        print(e);
      }
    });
  }
}

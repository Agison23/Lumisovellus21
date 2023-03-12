import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // Basically calls firestore, and try to set a new entry at user ID under "Users" collection
  // that holds name, date, time, and email of the login user at this instance
  static void updateAvailability() {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    String? firstName, lastName, fullName, phoneNum;

    prefs.then((pref) {
      firstName = pref.getString('fName');
      lastName = pref.getString('lName');
      phoneNum = pref.getString('pNumber');
      fullName = firstName! + " " + lastName!;

      final _firestore = FirebaseFirestore.instance;
      final data = {
        'name': fullName,
        'date_time': DateTime.now(),
        'phone': phoneNum,
      };
      try {
        _firestore.collection('Users').doc(phoneNum).set(data);
      } catch (e) {
        print(e);
      }
    });
  }
}

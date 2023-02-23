import 'package:intl/intl.dart';

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
}

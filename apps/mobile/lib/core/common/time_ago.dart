import 'package:lumisovellus/l10n/app_localizations.dart';

extension TimeAgoLocalization on AppLocalizations {
  String timeAgo(DateTime submittedAt) {
    final diff = DateTime.now().difference(submittedAt);

    final seconds = diff.inSeconds;
    final minutes = diff.inMinutes;
    final hours = diff.inHours;
    final days = diff.inDays;

    if (seconds <= 5) {
      return timeJustNow;
    }

    if (minutes == 0) {
      return timeUnderMinuteAgo;
    }

    if (minutes == 1) {
      return timeOneMinuteAgo;
    }

    if (minutes < 60) {
      return timeNMinutesAgo(minutes.toString());
    }

    if (hours == 1) {
      return timeOneHourAgo;
    }

    if (hours < 24) {
      return timeNHoursAgo(hours.toString());
    }

    if (days == 1) {
      return timeOneDayAgo;
    }

    return timeNDaysAgo(days.toString());
  }
}

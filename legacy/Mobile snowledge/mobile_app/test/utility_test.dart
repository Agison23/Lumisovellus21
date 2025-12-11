import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/helper/utility.dart';

void main() {
  test('Time difference is correctly returned', () {
    expect(
        Utility.getTimeAgo(
            DateTime.now().subtract(const Duration(seconds: 15)).toString()),
        '15 sec');
    expect(
        Utility.getTimeAgo(
            DateTime.now().subtract(const Duration(minutes: 10)).toString()),
        '10 min');
    expect(
        Utility.getTimeAgo(
            DateTime.now().subtract(const Duration(hours: 1)).toString()),
        '1 h');
    expect(
        Utility.getTimeAgo(
            DateTime.now().subtract(const Duration(days: 1)).toString()),
        '1 d');
    expect(
        Utility.getTimeAgo(
            DateTime.now().subtract(const Duration(days: 5)).toString()),
        '5 d');
  });
}

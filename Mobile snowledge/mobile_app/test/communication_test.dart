import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/side_bar/server_communications.dart';

void main() {
  test("test getAddress ip", () async {
    var expectedIp = await InternetAddress.lookup('dev.lumisovellus.fi',
        type: InternetAddressType.any);
    String expected = expectedIp[0].address;
    String address = await ServerComms.initAddress();
    expect(address, expected);
  });
}

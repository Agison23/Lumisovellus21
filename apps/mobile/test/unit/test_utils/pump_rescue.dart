import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lumisovellus/features/rescue/view/rescue_page.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_geolocator.dart';

Future<void> pumpRescueWithFakeLocation(
  WidgetTester tester, {
  required bool serviceEnabled,
  required LocationPermission permission,
  required Position? position,
  List<Override> overrides = const <Override>[],
}) async {
  installFakeGeolocator(
    serviceEnabled: serviceEnabled,
    permission: permission,
    position: position,
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: const MaterialApp(
        home: RescuePage(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: [Locale('en'), Locale('fi')],
      ),
    ),
  );
  await tester.pumpAndSettle();
}



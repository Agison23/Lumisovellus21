import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/side_bar/navigation_drawer.dart';

void main() {
  group('Language dropdown menu tests - ', () {
    testWidgets(
        'GIVEN the language is Finnish, '
        'WHEN changing the language from the side bar, '
        'THEN the language should change to English.', (tester) async {
      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<AppState>(create: (_) => AppState())
        ],
        child: const MaterialApp(
          home: Scaffold(
            drawer: MyNavigationDrawer(),
          ),
        ),
      ));

      // Open the side bar
      final ScaffoldState scaffoldState = tester.state(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      // Check that the texts are in Finnish and we didn't build the app
      // with English as default language
      expect(find.text('Lumiolosuhteet Pallaksella'), findsOneWidget);
      expect(find.text('Karttanäkymä'), findsOneWidget);
      expect(find.text('Sää Pallaksella'), findsOneWidget);
      expect(find.text('Lumityyppien selitteet'), findsOneWidget);
      expect(find.text('Käyttäjätiedot'), findsOneWidget);
      expect(find.text('Tietoa palvelusta'), findsOneWidget);
      expect(find.text('Tietosuojaseloste'), findsOneWidget);

      // Find the side bar's language dropdown button
      final Finder buttonToTap = find.byKey(const Key('languageSideDropdown'));

      // Drag the dropdown button until it is visible. This is needed because
      // the dropdown button for some reason is not wholly visible initially
      await tester.dragUntilVisible(
          buttonToTap, find.byType(DropdownButton), const Offset(0, 50));

      await tester.tap(buttonToTap);
      await tester.pumpAndSettle();

      // Change the language to English
      await tester.tap(find.byKey(const ValueKey('ENGLISH')).last);
      await tester.pumpAndSettle();

      // Check that the language has changed to English
      expect(find.text('Snow conditions in Pallas'), findsOneWidget);
      expect(find.text('Map view'), findsOneWidget);
      expect(find.text('Weather in Pallas'), findsOneWidget);
      expect(find.text('Definitions of Snow types'), findsOneWidget);
      expect(find.text('User Information'), findsOneWidget);
      expect(find.text('About the service'), findsOneWidget);
      expect(find.text('Privacy statement'), findsOneWidget);
    });

    testWidgets(
        'GIVEN the language is Finnish, '
        'WHEN changing the language in the start screen, '
        'THEN the language should change to English.', (tester) async {
      await tester.pumpWidget(MyApp());

      // Check that the texts are in Finnish and we didn't build the app
      // with English as default language
      expect(find.text('Seuraava'), findsOneWidget);

      // Find the start screen's language dropdown button
      final Finder buttonToTap = find.byKey(const Key('languageStartDropdown'));

      // Drag the dropdown button until it is visible. This is needed because
      // the dropdown button for some reason is not wholly visible initially
      await tester.dragUntilVisible(
          buttonToTap, find.byType(DropdownButton), const Offset(50, 0));

      await tester.tap(buttonToTap);
      await tester.pumpAndSettle();

      // Change the language to English
      await tester.tap(find.byKey(const ValueKey('ENGLISH')).last);
      await tester.pumpAndSettle();

      // Check that the language has changed to English
      expect(find.text('Continue'), findsOneWidget);
    });
  });
}

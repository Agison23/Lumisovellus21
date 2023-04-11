import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/widgets/buttons.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Language change integration tests - ', () {
    testWidgets(
        'GIVEN user launches the app for the first time and sets language to Finnish, '
        'WHEN user navigates to main page and changes the language to English, '
        'THEN texts in other pages are changed to English aswell',
        (tester) async {
      await tester.pumpWidget(MyApp());

      await tester.tap(find.text('Seuraava'));
      await tester.pumpAndSettle();

      // Don't allow location sharing as it is not needed for this test
      await tester.tap(find.text('Älä salli sijaintia'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Seuraava'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey('fName')), "First");
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey('sName')), "Last");
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey('phone')), "123456789");
      await tester.pumpAndSettle();

      // Scroll down to the next button
      await tester.dragUntilVisible(
        find.text('Seuraava'),
        find.byType(Buttons),
        const Offset(0, 50),
      );

      await tester.tap(find.byType(ElevatedButton).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Seuraava'));
      await tester.pumpAndSettle();

      // Check that the user has reached the main page
      expect(find.text('Pyydä\napua'), findsOneWidget);

      // Open the side bar
      final ScaffoldState scaffoldState = tester.state(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      expect(find.text('Käyttäjätiedot'), findsOneWidget);

      final Finder buttonToTap = find.byKey(const Key('languageSideDropdown'));

      // Make sure the dropdown is visible
      await tester.dragUntilVisible(
        buttonToTap,
        find.byType(DropdownButton),
        const Offset(0, 50),
      );

      await tester.tap(buttonToTap);
      await tester.pumpAndSettle();

      // Change the language to English
      await tester.tap(find.byKey(const ValueKey('ENGLISH')).last);
      await tester.pumpAndSettle();

      // Check that the language has changed in the side bar
      expect(find.text('User Information'), findsOneWidget);

      await tester.tap(find.text('User Information'));
      await tester.pumpAndSettle();

      // Check that the language has changed inside user information page
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets(
        'GIVEN user launches the app for the first time and sets language to English, '
        'WHEN user navigates to main page and changes the language to Finnish, '
        'THEN texts in other pages are changed to Finnish aswell',
        (tester) async {
      await tester.pumpWidget(MyApp());

      // Set the language to English from the start screen
      final Finder startDropdown =
          find.byKey(const Key('languageStartDropdown'));

      await tester.dragUntilVisible(
        startDropdown,
        find.byType(DropdownButton),
        const Offset(0, 50),
      );

      await tester.tap(startDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('ENGLISH')).last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Don't allow location sharing as it is not needed for this test
      await tester.tap(find.text('Do not allow location sharing'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey('fName')), "First");
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey('sName')), "Last");
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey('phone')), "123456789");
      await tester.pumpAndSettle();

      // Scroll down to the next button
      await tester.dragUntilVisible(
        find.text('Continue'),
        find.byType(Buttons),
        const Offset(0, 50),
      );

      await tester.tap(find.byType(ElevatedButton).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Check that the user has reached the main page
      expect(find.text('Ask for\nhelp'), findsOneWidget);

      // Open the side bar
      final ScaffoldState scaffoldState = tester.state(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      expect(find.text('User Information'), findsOneWidget);

      final Finder sideDropdown = find.byKey(const Key('languageSideDropdown'));

      // Make sure the dropdown is visible
      await tester.dragUntilVisible(
          sideDropdown, find.byType(DropdownButton), const Offset(0, 50));

      await tester.tap(sideDropdown);
      await tester.pumpAndSettle();

      // Change the language to English
      await tester.tap(find.byKey(const ValueKey('SUOMI')).last);
      await tester.pumpAndSettle();

      // Check that the language has changed in the side bar
      expect(find.text('Käyttäjätiedot'), findsOneWidget);

      await tester.tap(find.text('Käyttäjätiedot'));
      await tester.pumpAndSettle();

      // Check that the language has changed inside user information page
      expect(find.text('Tallenna'), findsOneWidget);
    });
  });
}

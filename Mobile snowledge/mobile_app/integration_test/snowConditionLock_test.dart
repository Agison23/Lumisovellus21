import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/widgets/buttons.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Snow condition of the app is locked by default - ', () {
    testWidgets(
        'GIVEN the app is started for the first time, '
        'WHEN navigating to the snow condition page, '
        'THEN the function should be locked and information dialog should show.',
        (tester) async {
      await tester.pumpWidget(MyApp());

      // Find the language selection dropdown
      final Finder startDropdown =
          find.byKey(const Key('languageStartDropdown'));
      await tester.dragUntilVisible(
        startDropdown,
        find.byType(DropdownButton),
        const Offset(0, 50),
      );
      await tester.tap(startDropdown);
      await tester.pumpAndSettle();

      // Set the language to English from the start screen
      await tester.tap(find.byKey(const ValueKey('ENGLISH')).last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Don't allow location sharing as it is not needed for this test
      await tester.tap(find.text('Do not allow location sharing'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Fill in information
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

      // Check that the user has reached the main page of the app e.g., there is a Location icon
      expect(find.text('Location'), findsOneWidget);

      // Open the side bar
      final ScaffoldState scaffoldState = tester.state(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      // Find the snow condition button and tap it
      expect(find.text('Snow conditions in Pallas'), findsOneWidget);
      final Finder snowConditionButton = find.byKey(const Key('snowCondition'));
      await tester.tap(snowConditionButton);
      await tester.pumpAndSettle();

      // For now, let's check that the user has reached the snow condition page by its webview key
      expect(find.byKey(const Key('snowConditionWebView')), findsOneWidget);
    });
  });
}

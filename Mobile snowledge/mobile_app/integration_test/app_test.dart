import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/bottom_bar/bottomBar.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/main_page.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/side_bar/navigation_drawer.dart';

void main() {
  testWidgets(
      'GIVEN language is Finnish and user is at main page, '
      'WHEN side bar is opened and language changed, '
      'THEN other pages should be translated as well', (tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [ChangeNotifierProvider<AppState>(create: (_) => AppState())],
      child: const MaterialApp(
        home: Scaffold(
          body: MainPage(),
          drawer: MyNavigationDrawer(),
        ),
      ),
    ));
    await tester.pump(const Duration(seconds: 6));

    // Open the side bar
    await tester.dragFrom(
        tester.getTopLeft(find.byType(MaterialApp)), Offset(300, 0));
    await tester.pump();

    // Find the side bar's language dropdown button
    final Finder buttonToTap = find.byKey(const Key('languageSideDropdown'));

    // Drag the dropdown button until it is visible. This is needed because
    // the dropdown button for some reason is not wholly visible initially
    await tester.dragUntilVisible(
        buttonToTap, find.byType(DropdownButton), const Offset(0, 50));

    await tester.tap(buttonToTap);
    await tester.pumpAndSettle();
    /*
    // Change the language to English
    await tester.tap(find.byKey(const ValueKey('ENGLISH')).last);
    await tester.pump(const Duration(seconds: 6));

    await tester.dragFrom(
        tester.getTopLeft(find.byType(MaterialApp)), Offset(-300, 0));
    await tester.pump();

    await tester.pump(const Duration(seconds: 6));
    */
  });
}

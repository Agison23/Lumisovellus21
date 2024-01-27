import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/bottom_bar/bottomBar.dart';
import 'package:mobile_app/state/appState.dart';
import 'package:provider/provider.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'GIVEN the user is at the main screen, '
      'WHEN the user presses the request help button, '
      'THEN the help screen should pop up', (tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [ChangeNotifierProvider<AppState>(create: (_) => AppState())],
      child: const MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BottomBar(),
        ),
      ),
    ));
    await tester.tap(find.text('Pyydä\napua'));
    await tester.pumpAndSettle();

    expect(find.text('Mihin ongelmaan tarvitset apua?'), findsOneWidget);
  });
}

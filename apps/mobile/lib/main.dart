import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'core/i18n/locale_provider.dart';
import 'features/onboarding/view/onboarding_page.dart';
import 'features/map/views/map_screen.dart';
import 'features/snow_definitions/view/snow_definitions_page.dart';

void main() => runApp(const ProviderScope(child: App()));

class App extends ConsumerWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const RootScaffold(), // <- persistent nav here
      routes: {
        '/snow-definitions': (context) => const SnowDefinitionsPage(),
      },
    );
  }
}

class RootScaffold extends ConsumerStatefulWidget {
  const RootScaffold({super.key});
  @override
  ConsumerState<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends ConsumerState<RootScaffold> {
  int _currentIndex = 0;

  static const List<Widget> _pages = <Widget>[
    MapScreen(),
    SnowDefinitionsPage(),
    // simple placeholder - replace with real weather page when available
    Center(
        child: Text('Weather (coming soon)',
            style: TextStyle(fontSize: 20))),
  ];

  void _onTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // allow body to be rendered under the bottomNavigationBar so the translucent
      // background actually shows the content beneath it
      extendBody: true,
      // keep the pages but preserve state with IndexedStack
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // semi-transparent, always-on bottom navigation bar
      bottomNavigationBar: SafeArea(
        child: Container(
          // container provides the translucent background
          color: const Color(0x99000000), // ~60% opacity black
          child: BottomNavigationBar(
            // make the bar itself transparent so the container's opacity shows
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Map',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info_outline),
                label: 'Definitions',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cloud_outlined),
                label: 'Weather',
              ),
            ],
            onTap: _onTap,
          ),
        ),
      ),
    );
  }
}

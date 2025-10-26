import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'package:lumisovellus/features/rescue/view/rescue_page.dart';
import 'package:lumisovellus/features/settings/view/settings_page.dart';
import 'package:lumisovellus/features/map/views/map_screen.dart';

// Global locale notifier for simple app-wide locale switching.
// Replace with your preferred state management/localization solution as needed.
final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('en'));

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, locale, _) {
        return MaterialApp(
          title: 'RescueApp',
          locale: locale,
          supportedLocales: const [
            Locale('en'),
            Locale('fi'),
            // add other supported locales here
          ],
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: ThemeData(useMaterial3: true),
          home: const MainShell(),
        );
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    RescuePage(),
    MapScreen(), // existing screen in your project
    _WeatherPlaceholder(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (idx) => setState(() => _currentIndex = idx),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_hospital),
            label: AppLocalizations.of(context).rescue,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: AppLocalizations.of(context).map,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.cloud),
            label: AppLocalizations.of(context).weather,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context).settings,
          ),
        ],
      ),
    );
  }
}

class _WeatherPlaceholder extends StatelessWidget {
  const _WeatherPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.white);
  }
}

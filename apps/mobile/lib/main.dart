import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisovellus/core/theme/rescue_theme.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'package:lumisovellus/features/rescue/view/rescue_page.dart';
import 'package:lumisovellus/features/settings/view/settings_page.dart';
import 'package:lumisovellus/features/map/views/map_screen.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:lumisovellus/core/auth/viewmodel/auth_notifier.dart';

// Global locale notifier for simple app-wide locale switching.
// Replace with your preferred state management/localization solution as needed.
final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('en'));

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  final token = dotenv.env['ACCESS_TOKEN'] ?? '';
  MapboxOptions.setAccessToken(token);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final container = ProviderContainer();
  await container.read(authSessionProvider.notifier).loadSession();

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
          navigatorKey: navigatorKey,
          title: 'RescueApp',
          locale: locale,
          supportedLocales: const [
            Locale('en'),
            Locale('fi'),
            // add other supported locales here
          ],
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0D1B2A), // <-- this is your new primary color
            ),
            extensions: <ThemeExtension<dynamic>>[
              RescueTheme.light(),
            ],
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0D1B2A),
              brightness: Brightness.dark,
            ),
            extensions: <ThemeExtension<dynamic>>[
              RescueTheme.dark(),
            ],
          ),
          themeMode: ThemeMode.light,
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
    MapScreen(), 
    _WeatherPlaceholder(),
    SettingsPage(),
  ];

  @override
 Widget build(BuildContext context) {
  return Scaffold(
    body: IndexedStack(index: _currentIndex, children: _pages),
    bottomNavigationBar: Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300, 
            width: 0.6,               
          ),
        ),
      ),
      child: BottomNavigationBar(
        iconSize: 30,
        backgroundColor: Theme.of(context).extension<RescueTheme>()?.pageBackground ??
            const Color(0xFAFAFAFA),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 52, 73, 95),
        unselectedItemColor: const Color.fromARGB(255, 148, 158, 167),
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
    ),
  );
  }
}

class _WeatherPlaceholder extends StatelessWidget {
  const _WeatherPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.white, body: Center(child: Text('Weather screen coming soon!')));
  }
}

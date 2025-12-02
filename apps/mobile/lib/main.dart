import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisovellus/core/theme/rescue_theme.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'package:lumisovellus/features/rescue/view/rescue_page.dart';
import 'package:lumisovellus/features/rescue/viewmodel/rescue_view_model.dart';
import 'package:lumisovellus/features/settings/view/settings_page.dart';
import 'package:lumisovellus/features/map/views/map_screen.dart';
import 'package:lumisovellus/features/map/providers.dart';
import 'package:lumisovellus/features/weather/view/weather_page.dart';
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

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;
  bool _previousHasActiveEvent = false;

  final List<Widget> _pages = const [
    RescuePage(),
    MapScreen(), 
    WeatherPage(),
    SettingsPage(),
  ];

  // Reddish color theme constants for active help event
  static const Color _activeRescueColor = Color(0xFFD32F2F); // Red-700
  static const Color _activeRescueColorLight = Color(0xFFEF5350); // Red-400
  static const Color _normalSelectedColor = Color.fromARGB(255, 52, 73, 95);
  static const Color _normalUnselectedColor = Color.fromARGB(255, 148, 158, 167);

  /// Returns the color for the Rescue button based on whether it's selected and if there's an active event
  Color _getRescueButtonColor(bool isSelected, bool hasActiveEvent) {
    if (hasActiveEvent) {
      return isSelected ? _activeRescueColor : _activeRescueColorLight;
    }
    return isSelected ? _normalSelectedColor : _normalUnselectedColor;
  }

  /// Builds a BottomNavigationBarItem for the Rescue button with conditional reddish theme
  BottomNavigationBarItem _buildRescueNavItem(
    BuildContext context,
    bool isSelected,
    bool hasActiveEvent,
  ) {
    final color = _getRescueButtonColor(isSelected, hasActiveEvent);
    final label = AppLocalizations.of(context).rescue;
    
    return BottomNavigationBarItem(
      icon: Icon(Icons.local_hospital, color: color),
      activeIcon: Icon(Icons.local_hospital, color: color),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    final rescueState = ref.watch(rescueViewModelProvider);
    final hasActiveEvent = rescueState.hasActiveEvent;

    // Listen for snap-to-location requests - navigate to map if not already there
    ref.listen<bool>(snapToLocationProvider, (previous, next) {
      if (next && _currentIndex != 1 && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _currentIndex = 1; // Navigate to Map screen
            });
          }
        });
      }
    });

    // Listen for when help event becomes active and navigate to map
    if (hasActiveEvent && !_previousHasActiveEvent && _currentIndex != 1) {
      // Use WidgetsBinding to ensure the build is complete before changing state
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // Signal the map to snap to location (this will also trigger navigation)
          ref.read(snapToLocationProvider.notifier).state = true;
        }
      });
    }

    _previousHasActiveEvent = hasActiveEvent;

    final isRescueSelected = _currentIndex == 0;
    // When Rescue is selected and has active event, use reddish color for selected items
    // (Note: This affects all selected items, but since only one can be selected at a time, it's acceptable)
    final selectedColor = (hasActiveEvent && isRescueSelected)
        ? _getRescueButtonColor(true, true)
        : _normalSelectedColor;

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
          selectedItemColor: selectedColor,
          unselectedItemColor: _normalUnselectedColor,
          onTap: (idx) => setState(() => _currentIndex = idx),
          items: [
            _buildRescueNavItem(context, isRescueSelected, hasActiveEvent),
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
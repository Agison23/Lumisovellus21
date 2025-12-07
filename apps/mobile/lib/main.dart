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
import 'package:lumisovellus/core/config/app_configuration_provider.dart';
import 'package:lumisovellus/core/settings/default_tab_provider.dart';
import 'package:lumisovellus/core/i18n/locale_provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file if available (for local development)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // .env file is optional - continue without it
    debugPrint('Note: .env file not found, using defaults and Remote Config');
  }

  // Initialize Firebase first (required for Remote Config)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Create provider container for the app
  final container = ProviderContainer();
  
  // Wait for configuration to load (this will fetch Remote Config)
  final config = await container.read(appConfigurationProvider.future);
  
  // Set Mapbox access token from centralized configuration
  if (config.mapboxAccessToken.isNotEmpty) {
    MapboxOptions.setAccessToken(config.mapboxAccessToken);
  } else {
    debugPrint('Warning: Mapbox access token is empty');
  }

  // Load auth session
  await container.read(authSessionProvider.notifier).loadSession();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        // Use persisted locale from provider, fallback to English
        final locale = ref.watch(localeProvider) ?? const Locale('en');
        
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
  int? _currentIndex; // null until we load from provider
  bool _previousHasActiveEvent = false;
  bool _hasUserChangedTab = false; // Track if user manually changed tabs
  
  void _setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
      _hasUserChangedTab = true; // Mark that user manually changed tabs
    });
  }
  
  int get currentIndex => _currentIndex ?? TabIndex.map;

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
    
    // Watch the default tab provider - it will update when async load completes
    final defaultTab = ref.watch(defaultTabProvider);
    debugPrint('MainShell: Watching defaultTabProvider, value: $defaultTab, _currentIndex: $_currentIndex, _hasUserChangedTab: $_hasUserChangedTab');
    
    // Update current index from provider only on initial load (before user changes tabs)
    // This handles both the initial null state and when the provider updates after async load
    if (!_hasUserChangedTab && _currentIndex != defaultTab) {
      // Provider value has changed (either initial load or after async load completes)
      debugPrint('MainShell: Updating _currentIndex from $_currentIndex to $defaultTab');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_hasUserChangedTab) {
          setState(() {
            _currentIndex = defaultTab;
          });
        }
      });
    }

    // Listen for snap-to-location requests - navigate to map if not already there
    ref.listen<bool>(snapToLocationProvider, (previous, next) {
      if (next && currentIndex != TabIndex.map && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _currentIndex = TabIndex.map; // Navigate to Map screen
            });
          }
        });
      }
    });

    // Listen for when help event becomes active and navigate to map
    if (hasActiveEvent && !_previousHasActiveEvent && currentIndex != TabIndex.map) {
      // Use WidgetsBinding to ensure the build is complete before changing state
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // Signal the map to snap to location (this will also trigger navigation)
          ref.read(snapToLocationProvider.notifier).state = true;
        }
      });
    }

    _previousHasActiveEvent = hasActiveEvent;

    final isRescueSelected = currentIndex == TabIndex.rescue;
    // When Rescue is selected and has active event, use reddish color for selected items
    // (Note: This affects all selected items, but since only one can be selected at a time, it's acceptable)
    final selectedColor = (hasActiveEvent && isRescueSelected)
        ? _getRescueButtonColor(true, true)
        : _normalSelectedColor;

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _pages),
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
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: selectedColor,
          unselectedItemColor: _normalUnselectedColor,
          onTap: (idx) => _setCurrentIndex(idx),
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
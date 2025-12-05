import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Constants for bottom navigation bar tab indices
class TabIndex {
  static const int rescue = 0;
  static const int map = 1;
  static const int weather = 2;
  static const int settings = 3;
}

/// Key for storing default tab preference in SharedPreferences
const String _defaultTabKey = 'defaultTabIndex';

/// Provider for default tab preference.
/// 
/// Manages which tab should be shown by default when the app launches.
/// Defaults to map tab (TabIndex.map = 1) if no preference is set.
class DefaultTabNotifier extends StateNotifier<int> {
  DefaultTabNotifier() : super(TabIndex.map) {
    // Load synchronously if possible, otherwise load async
    _load();
  }

  /// Loads the default tab preference from SharedPreferences
  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIndex = prefs.getInt(_defaultTabKey);
      debugPrint('DefaultTabNotifier: Loading saved index: $savedIndex');
      if (savedIndex != null && savedIndex >= 0 && savedIndex <= 3) {
        state = savedIndex;
        debugPrint('DefaultTabNotifier: Loaded saved tab index: $savedIndex');
      } else {
        debugPrint('DefaultTabNotifier: No saved index found, using default: ${TabIndex.map}');
      }
    } catch (e) {
      // If loading fails, keep the default value (TabIndex.map)
      debugPrint('Failed to load default tab preference: $e');
    }
  }

  /// Sets the default tab preference and persists it
  Future<void> setDefaultTab(int index) async {
    if (index < 0 || index > 3) {
      throw ArgumentError('Tab index must be between 0 and 3');
    }
    state = index;
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setInt(_defaultTabKey, index);
    debugPrint('DefaultTabNotifier: Saved tab index $index to SharedPreferences: $saved');
  }
}

/// Provider for the default tab preference
final defaultTabProvider = StateNotifierProvider<DefaultTabNotifier, int>((ref) {
  return DefaultTabNotifier();
});


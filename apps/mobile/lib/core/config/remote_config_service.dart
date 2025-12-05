import 'package:firebase_remote_config/firebase_remote_config.dart';

/// Service for fetching and managing Firebase Remote Config values.
class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService(this._remoteConfig);

  /// Fetches and activates Remote Config values.
  /// 
  /// Returns true if fetch was successful, false otherwise.
  /// On failure, cached values (if any) will still be available.
  Future<bool> fetchAndActivate() async {
    try {
      await _remoteConfig.fetchAndActivate();
      return true;
    } catch (e) {
      // Log error but don't throw - we'll use cached/default values
      return false;
    }
  }

  /// Gets a string value from Remote Config.
  /// Returns null if the key doesn't exist or value is empty.
  String? getString(String key) {
    final value = _remoteConfig.getString(key);
    return value.isEmpty ? null : value;
  }

  /// Gets a boolean value from Remote Config.
  /// Returns the boolean value (which may be from Remote Config or defaults).
  /// Note: Since we set defaults, this will always return a valid boolean.
  bool getBool(String key) {
    return _remoteConfig.getBool(key);
  }

  /// Gets an int value from Remote Config.
  int? getInt(String key) {
    try {
      return _remoteConfig.getInt(key);
    } catch (e) {
      return null;
    }
  }

  /// Gets a double value from Remote Config.
  double? getDouble(String key) {
    try {
      return _remoteConfig.getDouble(key);
    } catch (e) {
      return null;
    }
  }
}

/// Creates a configured Firebase Remote Config instance.
Future<FirebaseRemoteConfig> createRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  // Set default values (these match the Firebase console defaults)
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: const Duration(hours: 1),
  ));

  // Set defaults that match what's in Firebase console
  await remoteConfig.setDefaults({
    'BACKEND_URL': 'https://beta.lumisovellus.fi/backend-api',
    'MAPBOX_ACCESS_TOKEN': '',
  });

  return remoteConfig;
}


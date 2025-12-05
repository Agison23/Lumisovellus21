import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'app_configuration.dart';
import 'remote_config_service.dart';

/// Provider for Firebase Remote Config instance.
final remoteConfigProvider = FutureProvider<FirebaseRemoteConfig>((ref) async {
  return createRemoteConfig();
});

/// Provider for Remote Config Service.
final remoteConfigServiceProvider = FutureProvider<RemoteConfigService>((ref) async {
  final remoteConfig = await ref.watch(remoteConfigProvider.future);
  return RemoteConfigService(remoteConfig);
});

/// Provider for the centralized application configuration.
/// 
/// This provider:
/// 1. Starts with build-time defaults
/// 2. Applies .env overrides (if available, typically dev only)
/// 3. Fetches and applies Firebase Remote Config values (highest priority)
/// 
/// The configuration is loaded asynchronously, so consumers should handle
/// the AsyncValue state appropriately.
final appConfigurationProvider = FutureProvider<AppConfiguration>((ref) async {
  // Start with build-time defaults
  var config = AppConfiguration.fromDefaults();

  // Apply .env overrides if available (for local development)
  if (dotenv.isInitialized) {
    try {
      config = config.applyEnvOverrides();
    } catch (e) {
      // If dotenv isn't loaded, that's fine - we'll use defaults
      debugPrint('Warning: Could not apply dotenv overrides: $e');
    }
  }

  // Fetch and apply Remote Config values (highest priority)
  try {
    final remoteConfigService = await ref.watch(remoteConfigServiceProvider.future);
    
    // Fetch latest values (with timeout handling)
    await remoteConfigService.fetchAndActivate();

    // Apply Remote Config overrides
    final remoteBackendUrl = remoteConfigService.getString('BACKEND_URL');
    final remoteMapboxToken = remoteConfigService.getString('MAPBOX_ACCESS_TOKEN');

    config = config.applyRemoteConfig(
      backendBaseUrl: remoteBackendUrl,
      mapboxAccessToken: remoteMapboxToken,
    );
  } catch (e) {
    // If Remote Config fails, log but continue with defaults/env values
    debugPrint('Warning: Could not fetch Remote Config: $e');
  }

  return config;
});

/// Synchronous provider that provides the current configuration.
/// 
/// This will throw if configuration hasn't loaded yet. Use this only
/// when you're certain the config is available (e.g., after app initialization).
/// For most cases, use `appConfigurationProvider` and handle AsyncValue.
final appConfigurationSyncProvider = Provider<AppConfiguration>((ref) {
  final asyncValue = ref.watch(appConfigurationProvider);
  return asyncValue.maybeWhen(
    data: (config) => config,
    orElse: () {
      // Fallback to defaults if not loaded yet
      return AppConfiguration.fromDefaults();
    },
  );
});


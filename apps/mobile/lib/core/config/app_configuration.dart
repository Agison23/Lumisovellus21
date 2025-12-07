import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized application configuration model.
/// 
/// This model represents all configuration values used throughout the app.
/// Values are resolved in the following precedence order:
/// 1. Firebase Remote Config (highest priority)
/// 2. Local .env file (for development)
/// 3. Build-time defaults (lowest priority)
class AppConfiguration {
  final String backendBaseUrl;
  final String mapboxAccessToken;

  const AppConfiguration({
    required this.backendBaseUrl,
    required this.mapboxAccessToken,
  });

  /// Creates configuration from build-time defaults.
  /// These are the fallback values if no other source provides them.
  factory AppConfiguration.fromDefaults() {
    const baseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: '',
    );
    const mapboxToken = String.fromEnvironment(
      'MAPBOX_ACCESS_TOKEN',
      defaultValue: '',
    );

    return const AppConfiguration(
      backendBaseUrl: baseUrl,
      mapboxAccessToken: mapboxToken,
    );
  }

  /// Applies overrides from dotenv (.env file).
  /// This is typically used only in development.
  AppConfiguration applyEnvOverrides() {
    final envBaseUrl = dotenv.env['BACKEND_URL'];
    final envMapboxToken = dotenv.env['MAPBOX_ACCESS_TOKEN'];

    return AppConfiguration(
      backendBaseUrl: envBaseUrl ?? backendBaseUrl,
      mapboxAccessToken: envMapboxToken ?? mapboxAccessToken,
    );
  }

  /// Applies overrides from Firebase Remote Config.
  /// Remote Config values take highest precedence.
  AppConfiguration applyRemoteConfig({
    String? backendBaseUrl,
    String? mapboxAccessToken,
  }) {
    return AppConfiguration(
      backendBaseUrl: backendBaseUrl ?? this.backendBaseUrl,
      mapboxAccessToken: mapboxAccessToken ?? this.mapboxAccessToken,
    );
  }

  /// Creates a copy with updated values.
  AppConfiguration copyWith({
    String? backendBaseUrl,
    String? mapboxAccessToken,
  }) {
    return AppConfiguration(
      backendBaseUrl: backendBaseUrl ?? this.backendBaseUrl,
      mapboxAccessToken: mapboxAccessToken ?? this.mapboxAccessToken,
    );
  }

  @override
  String toString() {
    return 'AppConfiguration('
        'backendBaseUrl: $backendBaseUrl, '
        'mapboxAccessToken: ${mapboxAccessToken.isNotEmpty ? "***" : "empty"}'
        ')';
  }
}


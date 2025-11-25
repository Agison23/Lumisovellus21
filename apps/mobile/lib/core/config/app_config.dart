import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppConfig {
  final bool useRealBackend;
  final String apiBaseUrl;

  const AppConfig({
    required this.useRealBackend,
    required this.apiBaseUrl,
  });
}

final appConfigProvider = Provider<AppConfig>((ref) {
  const useReal = bool.fromEnvironment('USE_REAL_BACKEND', defaultValue: false);
  const baseUrl = String.fromEnvironment('API_BASE_URL');
  return const AppConfig(useRealBackend: useReal, apiBaseUrl: baseUrl);
});

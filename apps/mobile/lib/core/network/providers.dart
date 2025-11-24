import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'api_client.dart';

final _connectivityStreamProvider = StreamProvider<bool>((ref) {
  final connectivity = Connectivity();
  final internet = InternetConnection();

  return connectivity.onConnectivityChanged.asyncMap((results) async {
    final hasNetwork = results.isNotEmpty && !results.contains(ConnectivityResult.none);
    if (!hasNetwork) return false;
    return await internet.hasInternetAccess;
  }).distinct();
});

final connectivityProvider = Provider<bool>((ref) {
  final asyncValue = ref.watch(_connectivityStreamProvider);
  return asyncValue.asData?.value ?? false;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  const baseUrl = 'http://localhost:3001';
  return ApiClient(baseUrl: baseUrl);
});
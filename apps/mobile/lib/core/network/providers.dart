import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:lumisovellus/main.dart';
import '../auth/viewmodel/auth_notifier.dart';

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

final apiClientProvider = Provider<ApiClient>((ref)  {
  final baseUrl = dotenv.env['BACKEND_URL'] ?? 'http://localhost:3001';

  return ApiClient(
    baseUrl: baseUrl,
    on401: (req, res) {
      final ctx = navigatorKey.currentContext;
      if (ctx == null) return;

      showDialog(
        context: ctx,
        builder: (context) => AlertDialog(
          title: const Text('Unauthorized'),
          content: const Text("You don't have permission to do that."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    },
  );
});

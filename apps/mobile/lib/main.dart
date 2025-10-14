import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'core/i18n/locale_provider.dart';
import 'core/data/providers.dart';
// import 'features/onboarding/view/onboarding_page.dart';
import 'features/map/views/map_screen.dart';

void main() {
  runApp(const ProviderScope(child: App()));
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final container = ProviderContainer();
    unawaited(container.read(jobRunnerProvider).runOnce(batch: 32));
  });
}

class App extends ConsumerWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MapScreen(),
    );
  }
}

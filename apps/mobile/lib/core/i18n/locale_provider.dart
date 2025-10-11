import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';

class LocaleController extends StateNotifier<Locale?> {
  LocaleController() : super(null) { _load(); }
  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final code = p.getString('languageCode');
    if (code != null) state = _match(Locale(code));
  }
  Future<void> setLanguageCode(String? code) async {
    final p = await SharedPreferences.getInstance();
    if (code == null) {
      await p.remove('languageCode');
      state = null;
    } else {
      final loc = _match(Locale(code));
      await p.setString('languageCode', loc.languageCode);
      state = loc;
    }
  }
  Locale _match(Locale desired) {
    for (final l in AppLocalizations.supportedLocales) {
      if (l.languageCode == desired.languageCode) return l;
    }
    return AppLocalizations.supportedLocales.first;
  }
}
final localeProvider = StateNotifierProvider<LocaleController, Locale?>((ref) => LocaleController());

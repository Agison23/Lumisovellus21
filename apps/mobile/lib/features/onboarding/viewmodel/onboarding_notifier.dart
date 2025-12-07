import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_state.dart';

class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  void setNames(String f, String l) {
    state = state.copyWith(fName: f, lName: l);
  }

  void setPhone(String p) {
    state = state.copyWith(pNumber: p);
  }

  Future<void> save() async {
    state = state.copyWith(saving: true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fName', state.fName);
    await prefs.setString('lName', state.lName);
    await prefs.setString('pNumber', state.pNumber);
    state = state.copyWith(saving: false);
  }
}

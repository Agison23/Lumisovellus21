import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'viewmodel/onboarding_notifier.dart';
import 'viewmodel/onboarding_state.dart';

final onboardingProvider =
  NotifierProvider<OnboardingNotifier, OnboardingState>(OnboardingNotifier.new);

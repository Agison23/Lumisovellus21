import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/i18n/locale_provider.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'package:lumisovellus/features/onboarding/providers.dart';
import 'widgets/intro_step.dart';
import 'widgets/location_step.dart';
import 'widgets/info_step.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});
  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final page = PageController();
  final fName = TextEditingController();
  final lName = TextEditingController();
  final phone = TextEditingController();

  @override
  void dispose() {
    page.dispose();
    fName.dispose();
    lName.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(onboardingProvider);
    final t = AppLocalizations.of(context);
    const langs = {'fi', 'en'};
    final sel = langs.lookup(ref.watch(localeProvider)?.languageCode) ?? 'en';
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Image.asset('assets/images/pallaksen_pollot_logo_white.png', width: 220, errorBuilder: (_, __, ___) => const SizedBox(height: 80)),
            const SizedBox(height: 16),
            Expanded(
              child: PageView(
                controller: page,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  IntroStep(
                    text: t.snowAppInfo,
                    selected: sel,
                    onLangChange: (v) => ref.read(localeProvider.notifier).setLanguageCode(v),
                    onNext: () => page.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut),
                    tNext: t.next,
                  ),
                  LocationStep(
                    title: t.sharingLocation,
                    body: t.rescueFeatureInfo,
                    allowText: t.allowSharing,
                    skipText: t.noLocationShare,
                    onAllow: () => page.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut),
                    onSkip: () => page.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut),
                  ),
                  InfoStep(
                    title: t.correctInfo,
                    body: t.infoUsage,
                    firstNameLabel: t.fName,
                    lastNameLabel: t.surname,
                    phoneLabel: t.phoneNum,
                    fName: fName,
                    lName: lName,
                    phone: phone,
                    saving: vm.saving,
                    onSave: () async {
                      ref.read(onboardingProvider.notifier).setNames(fName.text, lName.text);
                      ref.read(onboardingProvider.notifier).setPhone(phone.text);
                      await ref.read(onboardingProvider.notifier).save();
                      if (!context.mounted) return;
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const _MainPageStub()));
                    },
                    tNext: t.next,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainPageStub extends StatelessWidget {
  const _MainPageStub();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Main')));
  }
}

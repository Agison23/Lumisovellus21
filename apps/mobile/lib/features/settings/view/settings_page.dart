import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisovellus/features/settings/view/widgets/auth_page.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'package:lumisovellus/features/snow_definitions/view/snow_definitions_page.dart';
import 'package:country_flags/country_flags.dart';
import 'package:lumisovellus/core/settings/default_tab_provider.dart';
import 'package:lumisovellus/core/i18n/locale_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  void _showDefaultTabDialog(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final currentDefaultTab = ref.watch(defaultTabProvider);

    final tabs = [
      (Icons.local_hospital, TabIndex.rescue, t.settingsDefaultTabRescue),
      (Icons.map, TabIndex.map, t.settingsDefaultTabMap),
      (Icons.cloud, TabIndex.weather, t.settingsDefaultTabWeather),
      (Icons.settings, TabIndex.settings, t.settingsDefaultTabSettings),
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(t.settingsDefaultTab),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: tabs.map((tab) {
            final (icon, index, displayName) = tab;
            final isSelected = currentDefaultTab == index;

            return Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(icon, color: isSelected 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey.shade700),
                title: Text(displayName),
                onTap: () {
                  ref.read(defaultTabProvider.notifier).setDefaultTab(index);
                  Navigator.of(context).pop();
                },
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.dialogCancel),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider) ?? const Locale('en');

    final languages = [('GB', 'en', t.english), ('FI', 'fi', t.finnish)];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(t.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((language) {
            final (countryCode, localeCode, displayName) = language;
            final isSelected = currentLocale.languageCode == localeCode;

            return Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CountryFlag.fromCountryCode(
                  countryCode,
                  theme: const ImageTheme(shape: Circle()),
                ),
                title: Text(displayName),
                onTap: () {
                  ref.read(localeProvider.notifier).setLanguageCode(localeCode);
                  Navigator.of(context).pop();
                },
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.dialogCancel),
          ),
        ],
      ),
    );
  }

  void _openUserInfoPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Minimal Header ----
              Padding(
                padding: const EdgeInsets.only(bottom: 28, top: 8),
                child: Text(
                  t.settings,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey.shade900,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              // ---- Settings cards ----
              Expanded(
                child: ListView(
                  children: [
                    _buildSettingsCard(
                      context: context,
                      icon: Icons.person_outline_rounded,
                      title: t.userInformation,
                      subtitle: t.userInformationSubtitle,
                      onTap: () => _openUserInfoPage(context),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsCard(
                      context: context,
                      icon: Icons.info_outline_rounded,
                      title: t.settingsPageSnowDefinitions,
                      subtitle: t.settingsPageSnowDefinitionsSubtitle,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SnowDefinitionsPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsCard(
                      context: context,
                      icon: Icons.home_rounded,
                      title: t.settingsDefaultTab,
                      subtitle: t.settingsDefaultTabSubtitle,
                      onTap: () => _showDefaultTabDialog(context, ref),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsCard(
                      context: context,
                      icon: Icons.language_rounded,
                      title: t.language,
                      subtitle: t.languageSubtitle,
                      onTap: () => _showLanguageDialog(context, ref),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              // Previously: Colors.grey.withOpacity(0.05)
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade800, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

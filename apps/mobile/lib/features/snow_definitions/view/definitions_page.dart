import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import '../data/snow_definitions_data.dart';
import '../widgets/snow_type_card.dart';

class DefinitionsPage extends StatelessWidget {
  const DefinitionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: Colors.white, // Updated background for better contrast
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              height: 80,
              color: const Color(0xff324c6d),
              child: Center(
                child: Text(
                  t.definitions,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Avalanche warning section
                    _buildAvalancheWarningSection(context, t),
                    const SizedBox(height: 32),
                    // Snow types section
                    _buildSnowTypesSection(context, t),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvalancheWarningSection(BuildContext context, AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.all(50),
      child: Column(
        children: [
          // Avalanche icon
          SizedBox(
            width: 100,
            height: 100,
            child: SvgPicture.asset(
              SnowDefinitionsData.avalancheWarning.iconPath,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            t.avalancheWarning,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          // Description
          Text(
            t.avalancheWarningDesc,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSnowTypesSection(BuildContext context, AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            t.snowTypes,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            runSpacing: 16,
            children: [
              ...SnowDefinitionsData.snowTypes.map((s) => SnowTypeCard(snowType: s)),
            ],
          ),
        ],
      ),
    );
  }
}

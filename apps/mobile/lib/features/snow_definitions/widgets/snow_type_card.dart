import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import '../models/snow_type.dart';

class SnowTypeCard extends StatelessWidget {
  final SnowType snowType;

  const SnowTypeCard({super.key, required this.snowType});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Container(
      width: 500,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Snow type icon
          SizedBox(
            width: 100,
            height: 100,
            child: SvgPicture.asset(snowType.iconPath, fit: BoxFit.contain),
          ),
          const SizedBox(width: 16),
          // Description and skiability rating
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getLocalizedText(t, snowType.nameKey),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                if (snowType.descriptionKey.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    _getLocalizedText(t, snowType.descriptionKey),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.black),
                  ),
                ],
                if (snowType.skiabilityRating > 0) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 20,
                    width: 100,
                    child: SvgPicture.asset(
                      'assets/icons/skiability/${snowType.skiabilityRating}.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLocalizedText(AppLocalizations t, String key) {
    switch (key) {
      case 'newSnow':
        return t.newSnow;
      case 'newSnowDesc':
        return t.newSnowDesc;
      case 'freshWetSnow':
        return t.freshWetSnow;
      case 'freshWetSnowDesc':
        return t.freshWetSnowDesc;
      case 'powderSnow':
        return t.powderSnow;
      case 'powderSnowDesc':
        return t.powderSnowDesc;
      case 'freshSnow':
        return t.freshSnow;
      case 'freshSnowDesc':
        return t.freshSnowDesc;
      case 'crust':
        return t.crust;
      case 'crustDesc':
        return t.crustDesc;
      case 'concrete':
        return t.concrete;
      case 'concreteDesc':
        return t.concreteDesc;
      case 'thinCrust':
        return t.thinCrust;
      case 'thinCrustDesc':
        return t.thinCrustDesc;
      case 'collapsingCrust':
        return t.collapsingCrust;
      case 'collapsingCrustDesc':
        return t.collapsingCrustDesc;
      case 'windpackedSnow':
        return t.windpackedSnow;
      case 'windpackedSnowDesc':
        return t.windpackedSnowDesc;
      case 'driftsAndBanks':
        return t.driftsAndBanks;
      case 'driftsAndBanksDesc':
        return t.driftsAndBanksDesc;
      case 'sastrug':
        return t.sastrug;
      case 'sastrugDesc':
        return t.sastrugDesc;
      case 'windblownSnow':
        return t.windblownSnow;
      case 'windblownSnowDesc':
        return t.windblownSnowDesc;
      case 'ice':
        return t.ice;
      case 'iceDesc':
        return t.iceDesc;
      case 'breakableIce':
        return t.breakableIce;
      case 'breakableIceDesc':
        return t.breakableIceDesc;
      case 'slush':
        return t.slush;
      case 'slushDesc':
        return t.slushDesc;
      case 'wettingSnow':
        return t.wettingSnow;
      case 'wettingSnowDesc':
        return t.wettingSnowDesc;
      case 'saturatedSnow':
        return t.saturatedSnow;
      case 'saturatedSnowDesc':
        return t.saturatedSnowDesc;
      case 'littleSnow':
        return t.littleSnow;
      default:
        return key;
    }
  }
}

import '../model/snow_type.dart';

class SnowDefinitionsData {
  static const AvalancheWarning avalancheWarning = AvalancheWarning(
    titleKey: 'avalancheWarning',
    descriptionKey: 'avalancheWarningDesc',
    iconPath: 'assets/icons/avalanche.svg',
  );
  // TODO: add asset prefix for DRYer iconPaths.
  static const List<SnowType> snowTypes = [
    SnowType(
      nameKey: 'newSnow',
      descriptionKey: 'newSnowDesc',
      iconPath: 'assets/icons/lumilogot/icon_uusi.svg',
      skiabilityRating: 4,
    ),
    SnowType(
      nameKey: 'freshWetSnow',
      descriptionKey: 'freshWetSnowDesc',
      iconPath: 'assets/icons/lumilogot/icon_newSnow_wet.svg',
      skiabilityRating: 4,
    ),
    SnowType(
      nameKey: 'powderSnow',
      descriptionKey: 'powderSnowDesc',
      iconPath: 'assets/icons/lumilogot/icon_puuteri.svg',
      skiabilityRating: 5,
    ),
    SnowType(
      nameKey: 'freshSnow',
      descriptionKey: 'freshSnowDesc',
      iconPath: 'assets/icons/lumilogot/icon_uusi_viti.svg',
      skiabilityRating: 5,
    ),
    SnowType(
      nameKey: 'crust',
      descriptionKey: 'crustDesc',
      iconPath: 'assets/icons/lumilogot/icon_korppu.svg',
      skiabilityRating: 3,
    ),
    SnowType(
      nameKey: 'concrete',
      descriptionKey: 'concreteDesc',
      iconPath: 'assets/icons/lumilogot/icon_korppu_kantava.svg',
      skiabilityRating: 3,
    ),
    SnowType(
      nameKey: 'thinCrust',
      descriptionKey: 'thinCrustDesc',
      iconPath: 'assets/icons/lumilogot/icon_korppu_ohut.svg',
      skiabilityRating: 3,
    ),
    SnowType(
      nameKey: 'collapsingCrust',
      descriptionKey: 'collapsingCrustDesc',
      iconPath: 'assets/icons/lumilogot/icon_korppu_rikkoutuva.svg',
      skiabilityRating: 2,
    ),
    SnowType(
      nameKey: 'windpackedSnow',
      descriptionKey: 'windpackedSnowDesc',
      iconPath: 'assets/icons/lumilogot/wind_driven_snow.svg',
      skiabilityRating: 3,
    ),
    SnowType(
      nameKey: 'driftsAndBanks',
      descriptionKey: 'driftsAndBanksDesc',
      iconPath: 'assets/icons/lumilogot/icon_tuulenPieksema_aaltoileva.svg',
      skiabilityRating: 4,
    ),
    SnowType(
      nameKey: 'sastrug',
      descriptionKey: 'sastrugDesc',
      iconPath: 'assets/icons/lumilogot/icon_tuulenPieksema_sasturgi.svg',
      skiabilityRating: 1,
    ),
    SnowType(
      nameKey: 'windblownSnow',
      descriptionKey: 'windblownSnowDesc',
      iconPath: 'assets/icons/lumilogot/icon_tuulenPieksema_tuisku.svg',
      skiabilityRating: 4,
    ),
    SnowType(
      nameKey: 'ice',
      descriptionKey: 'iceDesc',
      iconPath: 'assets/icons/lumilogot/icon_jaa.svg',
      skiabilityRating: 2,
    ),
    SnowType(
      nameKey: 'breakableIce',
      descriptionKey: 'breakableIceDesc',
      iconPath: 'assets/icons/lumilogot/icon_jaa_rikkoutuva.svg',
      skiabilityRating: 1,
    ),
    SnowType(
      nameKey: 'slush',
      descriptionKey: 'slushDesc',
      iconPath: 'assets/icons/lumilogot/icon_sohjo.svg',
      skiabilityRating: 2,
    ),
    SnowType(
      nameKey: 'wettingSnow',
      descriptionKey: 'wettingSnowDesc',
      iconPath: 'assets/icons/lumilogot/icon_sohjo_kastuva.svg',
      skiabilityRating: 3,
    ),
    SnowType(
      nameKey: 'saturatedSnow',
      descriptionKey: 'saturatedSnowDesc',
      iconPath: 'assets/icons/lumilogot/icon_sohjo_saturoitunut.svg',
      skiabilityRating: 2,
    ),
    SnowType(
      nameKey: 'littleSnow',
      descriptionKey: '',
      iconPath: 'assets/icons/lumilogot/Lumetonmaa.svg',
      skiabilityRating: 0,
    ),
  ];
}

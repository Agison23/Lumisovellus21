import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import '../../domain/models/index.dart';
import '../services/help_service.dart';
import 'rescue_mapper.auto_mappr.dart';

@AutoMappr([
  MapType<HelpRequest, ServiceHelpRequest>(
    fields: [
      Field('needType', custom: RescueMappr.mapNeedType),
      Field('latitude', custom: RescueMappr.mapLatitude),
      Field('longitude', custom: RescueMappr.mapLongitude),
      Field('accuracyMeters', custom: RescueMappr.mapAccuracy),
    ],
  ),
  MapType<ServiceHelpResponse, HelpResponse>(
    fields: [
      Field('needType', custom: RescueMappr.mapNeedTypeFromDynamic),
      Field('status', custom: RescueMappr.mapStatusFromDynamic),
      Field('location', custom: RescueMappr.mapLocation),
    ],
  ),
])
class RescueMappr extends $RescueMappr {
  // Custom mapping for needType (enum to dynamic)
  static dynamic mapNeedType(HelpRequest source) => source.needType;

  // Custom mapping for needType (dynamic to enum)
  static HelpNeedType mapNeedTypeFromDynamic(ServiceHelpResponse source) =>
      source.needType as HelpNeedType;

  // Custom mapping for status (dynamic to enum)
  static HelpEventStatus mapStatusFromDynamic(ServiceHelpResponse source) =>
      source.status as HelpEventStatus;

  // Custom mapping for flattening Location to latitude
  static double? mapLatitude(HelpRequest source) => source.location.latitude;

  // Custom mapping for flattening Location to longitude
  static double? mapLongitude(HelpRequest source) => source.location.longitude;

  // Custom mapping for flattening Location to accuracyMeters
  static double? mapAccuracy(HelpRequest source) => source.location.accuracy;

  // Custom mapping for constructing Location from flat fields
  static Location mapLocation(ServiceHelpResponse source) => Location(
        latitude: source.latitude,
        longitude: source.longitude,
        accuracy: source.accuracy ?? 0.0,
      );
}


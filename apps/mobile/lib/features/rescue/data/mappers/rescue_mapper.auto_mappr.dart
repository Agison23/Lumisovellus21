// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoMapprGenerator
// **************************************************************************

// ignore_for_file: type=lint, unnecessary_cast, unused_local_variable

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_mappr_annotation/auto_mappr_annotation.dart' as _i1;

import '../../domain/models/help_request.dart' as _i2;
import '../../domain/models/help_response.dart' as _i4;
import '../services/help_service.dart' as _i3;
import 'rescue_mapper.dart' as _i5;

/// {@template package:lumisovellus/features/rescue/data/mappers/rescue_mapper.dart}
/// Available mappings:
/// - `HelpRequest` → `ServiceHelpRequest`.
/// - `ServiceHelpResponse` → `HelpResponse`.
/// {@endtemplate}
class $RescueMappr implements _i1.AutoMapprInterface {
  const $RescueMappr();

  Type _typeOf<T>() => T;

  List<_i1.AutoMapprInterface> get _delegates => const [];

  /// {@macro AutoMapprInterface:canConvert}
  /// {@macro package:lumisovellus/features/rescue/data/mappers/rescue_mapper.dart}
  @override
  bool canConvert<SOURCE, TARGET>({bool recursive = true}) {
    final sourceTypeOf = _typeOf<SOURCE>();
    final targetTypeOf = _typeOf<TARGET>();
    if ((sourceTypeOf == _typeOf<_i2.HelpRequest>() ||
            sourceTypeOf == _typeOf<_i2.HelpRequest?>()) &&
        (targetTypeOf == _typeOf<_i3.ServiceHelpRequest>() ||
            targetTypeOf == _typeOf<_i3.ServiceHelpRequest?>())) {
      return true;
    }
    if ((sourceTypeOf == _typeOf<_i3.ServiceHelpResponse>() ||
            sourceTypeOf == _typeOf<_i3.ServiceHelpResponse?>()) &&
        (targetTypeOf == _typeOf<_i4.HelpResponse>() ||
            targetTypeOf == _typeOf<_i4.HelpResponse?>())) {
      return true;
    }
    if (recursive) {
      for (final mappr in _delegates) {
        if (mappr.canConvert<SOURCE, TARGET>()) {
          return true;
        }
      }
    }
    return false;
  }

  /// {@macro AutoMapprInterface:convert}
  /// {@macro package:lumisovellus/features/rescue/data/mappers/rescue_mapper.dart}
  @override
  TARGET convert<SOURCE, TARGET>(SOURCE? model) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return _convert(model)!;
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.convert(model)!;
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  /// {@macro AutoMapprInterface:tryConvert}
  /// {@macro package:lumisovellus/features/rescue/data/mappers/rescue_mapper.dart}
  @override
  TARGET? tryConvert<SOURCE, TARGET>(
    SOURCE? model, {
    void Function(Object error, StackTrace stackTrace, SOURCE? source)?
    onMappingError,
  }) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return _safeConvert(model, onMappingError: onMappingError);
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.tryConvert(model, onMappingError: onMappingError);
      }
    }

    return null;
  }

  /// {@macro AutoMapprInterface:convertIterable}
  /// {@macro package:lumisovellus/features/rescue/data/mappers/rescue_mapper.dart}
  @override
  Iterable<TARGET> convertIterable<SOURCE, TARGET>(Iterable<SOURCE?> model) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return model.map<TARGET>((item) => _convert(item)!);
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.convertIterable(model);
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  /// For iterable items, converts from SOURCE to TARGET if such mapping is configured, into Iterable.
  ///
  /// When an item in the source iterable is null, uses `whenSourceIsNull` if defined or null
  ///
  /// {@macro package:lumisovellus/features/rescue/data/mappers/rescue_mapper.dart}
  @override
  Iterable<TARGET?> tryConvertIterable<SOURCE, TARGET>(
    Iterable<SOURCE?> model, {
    void Function(Object error, StackTrace stackTrace, SOURCE? source)?
    onMappingError,
  }) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return model.map<TARGET?>(
        (item) => _safeConvert(item, onMappingError: onMappingError),
      );
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.tryConvertIterable(model, onMappingError: onMappingError);
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  /// {@macro AutoMapprInterface:convertList}
  /// {@macro package:lumisovellus/features/rescue/data/mappers/rescue_mapper.dart}
  @override
  List<TARGET> convertList<SOURCE, TARGET>(Iterable<SOURCE?> model) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return convertIterable<SOURCE, TARGET>(model).toList();
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.convertList(model);
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  /// For iterable items, converts from SOURCE to TARGET if such mapping is configured, into List.
  ///
  /// When an item in the source iterable is null, uses `whenSourceIsNull` if defined or null
  ///
  /// {@macro package:lumisovellus/features/rescue/data/mappers/rescue_mapper.dart}
  @override
  List<TARGET?> tryConvertList<SOURCE, TARGET>(
    Iterable<SOURCE?> model, {
    void Function(Object error, StackTrace stackTrace, SOURCE? source)?
    onMappingError,
  }) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return tryConvertIterable<SOURCE, TARGET>(
        model,
        onMappingError: onMappingError,
      ).toList();
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.tryConvertList(model, onMappingError: onMappingError);
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  /// {@macro AutoMapprInterface:convertSet}
  /// {@macro package:lumisovellus/features/rescue/data/mappers/rescue_mapper.dart}
  @override
  Set<TARGET> convertSet<SOURCE, TARGET>(Iterable<SOURCE?> model) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return convertIterable<SOURCE, TARGET>(model).toSet();
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.convertSet(model);
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  /// For iterable items, converts from SOURCE to TARGET if such mapping is configured, into Set.
  ///
  /// When an item in the source iterable is null, uses `whenSourceIsNull` if defined or null
  ///
  /// {@macro package:lumisovellus/features/rescue/data/mappers/rescue_mapper.dart}
  @override
  Set<TARGET?> tryConvertSet<SOURCE, TARGET>(
    Iterable<SOURCE?> model, {
    void Function(Object error, StackTrace stackTrace, SOURCE? source)?
    onMappingError,
  }) {
    if (canConvert<SOURCE, TARGET>(recursive: false)) {
      return tryConvertIterable<SOURCE, TARGET>(
        model,
        onMappingError: onMappingError,
      ).toSet();
    }
    for (final mappr in _delegates) {
      if (mappr.canConvert<SOURCE, TARGET>()) {
        return mappr.tryConvertSet(model, onMappingError: onMappingError);
      }
    }

    throw Exception('No ${_typeOf<SOURCE>()} -> ${_typeOf<TARGET>()} mapping.');
  }

  TARGET? _convert<SOURCE, TARGET>(
    SOURCE? model, {
    bool canReturnNull = false,
  }) {
    final sourceTypeOf = _typeOf<SOURCE>();
    final targetTypeOf = _typeOf<TARGET>();
    if ((sourceTypeOf == _typeOf<_i2.HelpRequest>() ||
            sourceTypeOf == _typeOf<_i2.HelpRequest?>()) &&
        (targetTypeOf == _typeOf<_i3.ServiceHelpRequest>() ||
            targetTypeOf == _typeOf<_i3.ServiceHelpRequest?>())) {
      if (canReturnNull && model == null) {
        return null;
      }
      return (_map__i2$HelpRequest_To__i3$ServiceHelpRequest(
            (model as _i2.HelpRequest?),
          )
          as TARGET);
    }
    if ((sourceTypeOf == _typeOf<_i3.ServiceHelpResponse>() ||
            sourceTypeOf == _typeOf<_i3.ServiceHelpResponse?>()) &&
        (targetTypeOf == _typeOf<_i4.HelpResponse>() ||
            targetTypeOf == _typeOf<_i4.HelpResponse?>())) {
      if (canReturnNull && model == null) {
        return null;
      }
      return (_map__i3$ServiceHelpResponse_To__i4$HelpResponse(
            (model as _i3.ServiceHelpResponse?),
          )
          as TARGET);
    }
    throw Exception('No ${model.runtimeType} -> $targetTypeOf mapping.');
  }

  TARGET? _safeConvert<SOURCE, TARGET>(
    SOURCE? model, {
    void Function(Object error, StackTrace stackTrace, SOURCE? source)?
    onMappingError,
  }) {
    if (!useSafeMapping<SOURCE, TARGET>()) {
      return _convert(model, canReturnNull: true);
    }
    try {
      return _convert(model, canReturnNull: true);
    } catch (e, s) {
      onMappingError?.call(e, s, model);
      return null;
    }
  }

  /// {@macro AutoMapprInterface:useSafeMapping}
  /// {@macro package:lumisovellus/features/rescue/data/mappers/rescue_mapper.dart}
  @override
  bool useSafeMapping<SOURCE, TARGET>() {
    return false;
  }

  _i3.ServiceHelpRequest _map__i2$HelpRequest_To__i3$ServiceHelpRequest(
    _i2.HelpRequest? input,
  ) {
    final model = input;
    if (model == null) {
      throw Exception(
        r'Mapping HelpRequest → ServiceHelpRequest failed because HelpRequest was null, and no default value was provided. '
        r'Consider setting the whenSourceIsNull parameter on the MapType<HelpRequest, ServiceHelpRequest> to handle null values during mapping.',
      );
    }
    return _i3.ServiceHelpRequest(
      needType: _i5.RescueMappr.mapNeedType(model),
      latitude: _i5.RescueMappr.mapLatitude(model),
      longitude: _i5.RescueMappr.mapLongitude(model),
      accuracyMeters: _i5.RescueMappr.mapAccuracy(model),
    );
  }

  _i4.HelpResponse _map__i3$ServiceHelpResponse_To__i4$HelpResponse(
    _i3.ServiceHelpResponse? input,
  ) {
    final model = input;
    if (model == null) {
      throw Exception(
        r'Mapping ServiceHelpResponse → HelpResponse failed because ServiceHelpResponse was null, and no default value was provided. '
        r'Consider setting the whenSourceIsNull parameter on the MapType<ServiceHelpResponse, HelpResponse> to handle null values during mapping.',
      );
    }
    return _i4.HelpResponse(
      requestId: model.requestId,
      createdAt: model.createdAt,
      needType: _i5.RescueMappr.mapNeedTypeFromDynamic(model),
      status: _i5.RescueMappr.mapStatusFromDynamic(model),
      notifiedNearbyCount: model.notifiedNearbyCount,
      location: _i5.RescueMappr.mapLocation(model),
    );
  }
}

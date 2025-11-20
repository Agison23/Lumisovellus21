import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisovellus/core/network/providers.dart';
import 'package:lumisovellus/features/map/data/repositories/snow_types_repository.dart';
import 'package:lumisovellus/features/map/data/services/snow_types_service.dart';
import '../data/repositories/segments_repository.dart';
import '../data/services/segments_service.dart';
import './map_state.dart';

final segmentsServiceProvider = Provider<SegmentsService>(
  (ref) => SegmentsService(ref.watch(apiClientProvider)),
);

final segmentsRepositoryProvider = Provider<SegmentsRepository>(
  (ref) => SegmentsRepository(ref.watch(segmentsServiceProvider)),
);

class SegmentsNotifier extends AutoDisposeAsyncNotifier<SegmentsState> {
  @override
  Future<SegmentsState> build() async {
    final repo = ref.watch(segmentsRepositoryProvider);
    final segments = await repo.getAreas();
    return SegmentsState(segments: segments);
  }

  void select(String? id) =>
      state = state.whenData((s) => s.copyWith(selectedId: id));

  void hover(String? id) =>
      state = state.whenData((s) => s.copyWith(hoveredId: id));
}

final segmentsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SegmentsNotifier, SegmentsState>(
      SegmentsNotifier.new,
    );

final snowTypesServiceProvider = Provider<SnowTypesService>(
  (ref) => SnowTypesService(ref.watch(apiClientProvider)),
);

final snowTypesRepositoryProvider = Provider<SnowTypesRepository>(
  (ref) => SnowTypesRepository(ref.watch(snowTypesServiceProvider)),
);

class SnowTypesNotifier extends AutoDisposeAsyncNotifier<SnowTypesState> {
  @override
  Future<SnowTypesState> build() async {
    final repo = ref.watch(snowTypesRepositoryProvider);
    final snowTypes = await repo.getSnowTypes();
    return SnowTypesState(snowTypes: snowTypes);
  }
}


final snowTypesNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SnowTypesNotifier, SnowTypesState>(
      SnowTypesNotifier.new,
    );
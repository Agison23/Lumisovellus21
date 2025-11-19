import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumisovellus/core/network/providers.dart';
import 'package:lumisovellus/features/map/data/services/snow_type_service.dart';
import 'package:lumisovellus/features/map/data/services/mock_snow_type_service.dart';
import '../data/repositories/segments_repository.dart';
import '../data/services/segments_service.dart';
import '../data/models/snow_type.dart';
import '../data/repositories/snow_type_repository.dart';
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

final snowTypeServiceProvider = Provider<SnowTypeService>(
  (ref) => MockSnowTypeService(),
);

final snowTypeRepositoryProvider = Provider(
  (ref) => SnowTypeRepository(ref.watch(snowTypeServiceProvider)),
);

class SnowTypesNotifier extends AutoDisposeAsyncNotifier<List<SnowType>> {
  @override
  Future<List<SnowType>> build() async {
    final repo = ref.watch(snowTypeRepositoryProvider);
    return repo.getSnowTypes();
  }
}

final snowTypesNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SnowTypesNotifier, List<SnowType>>(
      SnowTypesNotifier.new,
    );

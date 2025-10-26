import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/interactive_area_repository.dart';
import '../data/services/mock_interactive_area_service.dart';
import '../data/services/interactive_area_service.dart';
import './map_state.dart';

final interactiveAreaServiceProvider = Provider<InteractiveAreaService>(
  (ref) => MockInteractiveAreaService(),
);

final interactiveAreaRepositoryProvider = Provider<InteractiveAreaRepository>(
  (ref) => InteractiveAreaRepository(ref.watch(interactiveAreaServiceProvider)),
);

class InteractiveAreaNotifier extends AutoDisposeAsyncNotifier<InteractiveAreaState> {
  @override
  Future<InteractiveAreaState> build() async {
    final repo = ref.watch(interactiveAreaRepositoryProvider);
    final areas = await repo.getAreas();
    final fc = {
      'type': 'FeatureCollection',
      'features': areas.map((e) => e.toMap()).toList(),
    };
    return InteractiveAreaState(fc: fc);
  }

  void select(String? id) => state = state.whenData((s) => s.copyWith(selectedId: id));
  void hover(String? id) => state = state.whenData((s) => s.copyWith(hoveredId: id));
  void setFc(Map<String, dynamic> fc) => state = state.whenData((s) => s.copyWith(fc: fc));
}

final interactiveAreaNotifierProvider =
  AutoDisposeAsyncNotifierProvider<InteractiveAreaNotifier, InteractiveAreaState>(
    InteractiveAreaNotifier.new,
  );
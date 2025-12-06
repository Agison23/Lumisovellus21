import 'package:flutter_test/flutter_test.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';
import 'package:lumisovellus/features/map/viewmodel/map_state.dart';

Segment _segment(String id) => Segment(
  id: id,
  name: 'Seg $id',
  terrain: 'Terrain',
  avalancheDanger: false,
  isLowerSegment: null,
  points: const [],
  guideUpdate: null,
  userReviews: const [],
);

SnowType _snowType(String id) => SnowType(
  id: id,
  identifier: id,
  name: 'Snow $id',
  colour: '#000000',
  skiability: 3,
  primarySnowTypeId: null,
  explanation: 'desc',
);

void main() {
  group('SegmentsState', () {
    test('copyWith keeps existing selectedId/hoveredId when omitted', () {
      final initial = SegmentsState(
        segments: [_segment('s1')],
        selectedId: 'sel-1',
        hoveredId: 'hov-1',
      );

      final updated = initial.copyWith(
        segments: [_segment('s1'), _segment('s2')],
      );

      expect(updated.segments!.length, 2);
      expect(updated.selectedId, 'sel-1');
      expect(updated.hoveredId, 'hov-1');
    });

    test('copyWith can set selectedId/hoveredId to null explicitly', () {
      final initial = SegmentsState(
        segments: [_segment('s1')],
        selectedId: 'sel-1',
        hoveredId: 'hov-1',
      );

      final cleared = initial.copyWith(selectedId: null, hoveredId: null);

      expect(cleared.selectedId, isNull);
      expect(cleared.hoveredId, isNull);
    });
  });

  group('SnowTypesState', () {
    test('copyWith replaces snowTypes when provided', () {
      final initial = SnowTypesState(snowTypes: [_snowType('st1')]);

      final updated = initial.copyWith(
        snowTypes: [_snowType('st1'), _snowType('st2')],
      );

      expect(initial.snowTypes!.length, 1);
      expect(updated.snowTypes!.length, 2);
    });

    test('copyWith keeps snowTypes when omitted', () {
      final initial = SnowTypesState(snowTypes: [_snowType('st1')]);

      final updated = initial.copyWith();

      expect(updated.snowTypes, same(initial.snowTypes));
    });
  });
}

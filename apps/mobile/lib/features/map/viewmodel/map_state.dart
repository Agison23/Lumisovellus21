import 'package:lumisovellus_api/lumisovellus_api.dart';

const _sentinel = Object();

class SegmentsState {
  final List<Segment>? segments;
  final String? selectedId;
  final String? hoveredId;

  const SegmentsState({this.segments, this.selectedId, this.hoveredId});

  SegmentsState copyWith({
    List<Segment>? segments,
    Object? selectedId = _sentinel,
    Object? hoveredId = _sentinel,
  }) {
    return SegmentsState(
      segments: segments ?? this.segments,
      selectedId: identical(selectedId, _sentinel)
          ? this.selectedId
          : selectedId as String?,
      hoveredId: identical(hoveredId, _sentinel)
          ? this.hoveredId
          : hoveredId as String?,
    );
  }
}

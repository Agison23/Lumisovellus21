const _sentinel = Object();

class InteractiveAreaState {
  final Map<String, dynamic>? fc;
  final String? selectedId;
  final String? hoveredId;
  const InteractiveAreaState({this.fc, this.selectedId, this.hoveredId});

  InteractiveAreaState copyWith({
    Map<String, dynamic>? fc,
    Object? selectedId = _sentinel,
    Object? hoveredId = _sentinel,
  }) {
    return InteractiveAreaState(
      fc: fc ?? this.fc,
      selectedId: identical(selectedId, _sentinel) ? this.selectedId : selectedId as String?,
      hoveredId: identical(hoveredId, _sentinel) ? this.hoveredId : hoveredId as String?,
    );
  }
}
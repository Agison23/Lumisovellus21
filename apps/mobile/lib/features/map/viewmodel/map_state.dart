class InteractiveAreaState {
  final Map<String, dynamic>? fc;
  final String? selectedId;
  final String? hoveredId;
  const InteractiveAreaState({this.fc, this.selectedId, this.hoveredId});
  InteractiveAreaState copyWith({
    Map<String, dynamic>? fc,
    String? selectedId,
    String? hoveredId,
  }) => InteractiveAreaState(
    fc: fc ?? this.fc,
    selectedId: selectedId ?? this.selectedId,
    hoveredId: hoveredId ?? this.hoveredId,
  );
}

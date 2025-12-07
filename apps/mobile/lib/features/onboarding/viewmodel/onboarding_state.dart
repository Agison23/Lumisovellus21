class OnboardingState {
  final String fName;
  final String lName;
  final String pNumber;
  final bool saving;
  const OnboardingState({this.fName = '', this.lName = '', this.pNumber = '', this.saving = false});
  OnboardingState copyWith({String? fName, String? lName, String? pNumber, bool? saving}) {
    return OnboardingState(fName: fName ?? this.fName, lName: lName ?? this.lName, pNumber: pNumber ?? this.pNumber, saving: saving ?? this.saving);
  }
}

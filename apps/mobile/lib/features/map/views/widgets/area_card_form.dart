import 'package:flutter/material.dart';
import 'package:lumisovellus_api/lumisovellus_api.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';

class AreaCardSelectCategoryStep extends StatelessWidget {
  final AppLocalizations t;
  final List<SnowType> snowTypes;
  final ValueChanged<String> onPick;
  final VoidCallback onBack;

  const AreaCardSelectCategoryStep({
    required this.t,
    required this.snowTypes,
    required this.onPick,
    required this.onBack,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          t.selectSnowType,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Center(
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final st in snowTypes)
                ElevatedButton(
                  onPressed: () => onPick(st.id),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 50),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                  ),
                  child: Text(
                    st.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onBack,
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 243, 243, 243),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
              ),
              child: Text(t.back),
            ),
          ],
        ),
      ],
    );
  }
}

class AreaCardSpecifyTypeStep extends StatelessWidget {
  final AppLocalizations t;
  final String segmentId;
  final List<SnowType> allTypes;
  final String? selectedCategoryId;
  final String? selectedSnowTypeId;
  final List<String> hazards;
  final List<String> selectedHazards;
  final ValueChanged<String> onPickType;
  final ValueChanged<String> onToggleHazard;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const AreaCardSpecifyTypeStep({
    required this.t,
    required this.segmentId,
    required this.allTypes,
    required this.selectedCategoryId,
    required this.selectedSnowTypeId,
    required this.hazards,
    required this.selectedHazards,
    required this.onPickType,
    required this.onToggleHazard,
    required this.onBack,
    required this.onSubmit,
    super.key,
  });

  String _labelForHazard(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final options = allTypes
        .where(
          (st) =>
              st.primarySnowTypeId == selectedCategoryId ||
              st.id == selectedCategoryId,
        )
        .toList();
    final selected = allTypes.where((e) => e.id == selectedSnowTypeId).toList();
    final selectedDesc =
        selected.isEmpty ? '' : (selected.first.explanation ?? '');
    final hazardButtons = hazards;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          t.specifySnowType,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final st in options)
              ElevatedButton(
                onPressed: () => onPickType(st.id),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(100, 50),
                  backgroundColor:
                      selectedSnowTypeId == st.id ? Colors.black : Colors.white,
                  foregroundColor:
                      selectedSnowTypeId == st.id ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                ),
                child: Text(
                  st.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (selectedDesc.isNotEmpty)
          Text(
            selectedDesc,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        const SizedBox(height: 16),
        if (hazardButtons.isNotEmpty)
          Text(
            t.obstacles,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final hazard in hazardButtons)
              ElevatedButton(
                onPressed: () => onToggleHazard(hazard),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedHazards.contains(hazard)
                      ? Colors.black
                      : Colors.white,
                  foregroundColor: selectedHazards.contains(hazard)
                      ? Colors.white
                      : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                ),
                child: Text(
                  _labelForHazard(hazard),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: onBack,
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 243, 243, 243),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
              ),
              child: Text(t.back),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: selectedSnowTypeId != null ? onSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
              ),
              child: Text(t.submit),
            ),
          ],
        ),
      ],
    );
  }
}

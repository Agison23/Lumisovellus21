import 'package:flutter/material.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import '../../data/models/snow_type.dart';

class AreaCard extends StatefulWidget {
  final AppLocalizations t;
  final String name;
  final String terrain;
  final String danger;
  final VoidCallback onAdd;
  final VoidCallback onClose;
  final List<SnowType> snowTypes;

  const AreaCard({
    required this.t,
    required this.name,
    required this.terrain,
    required this.danger,
    required this.onAdd,
    required this.onClose,
    required this.snowTypes,
    super.key,
  });

  @override
  State<AreaCard> createState() => _AreaCardState();
}

class _AreaCardState extends State<AreaCard> {
  int step = 0;
  int? selectedCategoryId;
  int? selectedSnowTypeId;
  List<int> obstacleIds = [];

  void _start() => setState(() => step = 1);
  void _backTo0() => setState(() => step = 0);
  void _toStep2(int id) => setState(() { selectedCategoryId = id; selectedSnowTypeId = id; step = 2; });
  void _pickType(int id) => setState(() => selectedSnowTypeId = id);
  void _toggleObstacle(int id) => setState(() {
    if (obstacleIds.contains(id)) {
      obstacleIds = obstacleIds.where((e) => e != id).toList();
    } else {
      obstacleIds = [...obstacleIds, id];
    }
  });
  void _backTo1() => setState(() { selectedSnowTypeId = null; obstacleIds = []; step = 1; });
  void _submit() {
    final payload = {
      'areaName': widget.name,
      'selectedSnowTypeId': selectedSnowTypeId,
      'obstacleIds': obstacleIds,
      'timestamp': DateTime.now().toIso8601String(),
    };
    debugPrint('Observation: $payload');
    setState(() {
      step = 0;
      selectedCategoryId = null;
      selectedSnowTypeId = null;
      obstacleIds = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 250,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(widget.terrain, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              switch (step) {
                0 => _StepZeroButtons(
                  t: widget.t,
                  onAdd: _start,
                  onClose: widget.onClose,
                  danger: widget.danger,
                ),
                1 => _StepSelectCategory(
                  t: widget.t,
                  snowTypes: widget.snowTypes.where((st) => st.categoryId == null).toList(),
                  onPick: _toStep2,
                  onBack: _backTo0,
                ),
                _ => _StepSpecifyType(
                  t: widget.t,
                  allTypes: widget.snowTypes,
                  selectedCategoryId: selectedCategoryId,
                  selectedSnowTypeId: selectedSnowTypeId,
                  obstacleIds: obstacleIds,
                  onPickType: _pickType,
                  onToggleObstacle: _toggleObstacle,
                  onBack: _backTo1,
                  onSubmit: _submit,
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}

class _StepZeroButtons extends StatelessWidget {
  final AppLocalizations t;
  final VoidCallback onAdd;
  final VoidCallback onClose;
  final String danger;

  const _StepZeroButtons({
    required this.t,
    required this.onAdd,
    required this.onClose,
    required this.danger
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(danger, style: const TextStyle(fontSize: 14, color: Colors.black)),
        const SizedBox(height: 4),
        Row(mainAxisSize: MainAxisSize.min, children: [
          ElevatedButton(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            ),
            child: Text(t.addObservation),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onClose,
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 243, 243, 243),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            ),
            child: Text(t.close),
          ),
        ]),
      ]
    );
  }
}

class _StepSelectCategory extends StatelessWidget {
  final AppLocalizations t;
  final List<SnowType> snowTypes;
  final ValueChanged<int> onPick;
  final VoidCallback onBack;

  const _StepSelectCategory({
    required this.t,
    required this.snowTypes,
    required this.onPick,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(t.selectSnowType, style: const TextStyle(fontSize: 14, color: Colors.black)),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
                child: Text(st.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
              ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
          onPressed: onBack,
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 243, 243, 243),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          ),
          child: Text(t.back),
        ),
      ]),
    ]);
  }
}

class _StepSpecifyType extends StatelessWidget {
  final AppLocalizations t;
  final List<SnowType> allTypes;
  final int? selectedCategoryId;
  final int? selectedSnowTypeId;
  final List<int> obstacleIds;
  final ValueChanged<int> onPickType;
  final ValueChanged<int> onToggleObstacle;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const _StepSpecifyType({
    required this.t,
    required this.allTypes,
    required this.selectedCategoryId,
    required this.selectedSnowTypeId,
    required this.obstacleIds,
    required this.onPickType,
    required this.onToggleObstacle,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final options = allTypes.where((st) => st.categoryId == selectedCategoryId || st.id == selectedCategoryId).toList();
    final obstacles = allTypes.where((st) => st.categoryId == 7).toList();
    final selected = allTypes.where((e) => e.id == selectedSnowTypeId);
    final selectedDesc = selected.isEmpty ? '' : selected.first.explanation;

    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(t.specifySnowType, style: const TextStyle(fontSize: 14, color: Colors.black)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: [
        for (final st in options)
          ElevatedButton(
            onPressed: () => onPickType(st.id),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(100, 50),
              backgroundColor: selectedSnowTypeId == st.id ? Colors.black : Colors.white,
              foregroundColor: selectedSnowTypeId == st.id ? Colors.white : Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
            child: Text(st.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
          ),
      ]),
      const SizedBox(height: 8),
      if (selectedDesc.isNotEmpty) Text(selectedDesc, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
      const SizedBox(height: 16),
      if (obstacles.isNotEmpty) Text(t.obstacles, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
      Wrap(spacing: 8, runSpacing: 8, children: [
        for (final ob in obstacles)
          ElevatedButton(
            onPressed: () => onToggleObstacle(ob.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: obstacleIds.contains(ob.id) ? Colors.black : Colors.white,
              foregroundColor: obstacleIds.contains(ob.id) ? Colors.white : Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
            child: Text(ob.name, style: const TextStyle(fontSize: 12)),
          ),
      ]),
      const SizedBox(height: 8),
      Row(mainAxisSize: MainAxisSize.min, children: [
        ElevatedButton(
          onPressed: onBack,
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 243, 243, 243),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          ),
          child: Text(t.back),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: (selectedSnowTypeId != null || obstacleIds.isNotEmpty) ? onSubmit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          ),
          child: Text(t.submit),
        ),
      ]),
    ]);
  }
}

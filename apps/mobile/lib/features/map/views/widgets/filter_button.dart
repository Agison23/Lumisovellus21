import 'package:flutter/material.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';

final _segmentsVisibleProvider = StateProvider<bool>((_) => true);

class FilterButton extends ConsumerWidget {
  final AppLocalizations t;

  const FilterButton({required this.t, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final areasMgr = ref.watch(areasLayerManagerProvider);
    final visible = ref.watch(_segmentsVisibleProvider);

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      shadowColor: Colors.transparent,
      side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
      alignment: Alignment.centerLeft,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    );

    return PopupMenuButton<String>(
      constraints: const BoxConstraints(maxWidth: 150),
      offset: const Offset(0, -120),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      elevation: 6,
      itemBuilder: (context) => [
        PopupMenuItem(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          value: 'segments',
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: buttonStyle,
              icon: const Icon(Icons.flag, color: Color(0xFF1EC28B), size: 20),
              label: Text(t.segments, style: const TextStyle(fontSize: 14)),
              onPressed: () {
                Navigator.pop(context);
                final newVal = !visible;
                ref.read(_segmentsVisibleProvider.notifier).state = newVal;
                areasMgr.setAreasVisible(newVal);
              },
            ),
          ),
        ),
        PopupMenuItem(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          value: 'sensors',
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: buttonStyle,
              icon: const Icon(Icons.show_chart, color: Colors.black, size: 20),
              label: Text(t.sensors, style: const TextStyle(fontSize: 14)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 243, 243, 243),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: const Icon(Icons.filter_list, color: Colors.black),
      ),
    );
  }
}

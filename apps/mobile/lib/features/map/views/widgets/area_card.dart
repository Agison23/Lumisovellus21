import 'package:flutter/material.dart';
import 'package:lumisovellus/l10n/app_localizations.dart';

class AreaCard extends StatelessWidget {
  final AppLocalizations t;
  final String name;
  final String terrain;
  final String danger;
  final VoidCallback onAdd;
  final VoidCallback onClose;

  const AreaCard({
    required this.t,
    required this.name,
    required this.terrain,
    required this.danger,
    required this.onAdd,
    required this.onClose,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(terrain, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Text(danger, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

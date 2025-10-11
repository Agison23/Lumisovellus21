import 'package:flutter/material.dart';

class IntroStep extends StatelessWidget {
  final String text;
  final String selected;
  final void Function(String) onLangChange;
  final VoidCallback onNext;
  final String tNext;
  const IntroStep({super.key, required this.text, required this.selected, required this.onLangChange, required this.onNext, required this.tNext});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, color: Colors.white)),
          const SizedBox(height: 20),
          SegmentedButton<String>(
            segments: const [ButtonSegment(value: 'fi', label: Text('Suomi')), ButtonSegment(value: 'en', label: Text('English'))],
            selected: {selected},
            onSelectionChanged: (v) => onLangChange(v.first),
          ),
          const Spacer(),
          SizedBox(width: 260, child: ElevatedButton(onPressed: onNext, child: Text(tNext))),
        ],
      ),
    );
  }
}

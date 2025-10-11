import 'package:flutter/material.dart';

class LocationStep extends StatelessWidget {
  final String title;
  final String body;
  final String allowText;
  final String skipText;
  final VoidCallback onAllow;
  final VoidCallback onSkip;
  const LocationStep({super.key, required this.title, required this.body, required this.allowText, required this.skipText, required this.onAllow, required this.onSkip});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          Text(body, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.white)),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onAllow, child: Text(allowText)),
          const SizedBox(height: 8),
          TextButton(onPressed: onSkip, child: Text(skipText)),
        ],
      ),
    );
  }
}

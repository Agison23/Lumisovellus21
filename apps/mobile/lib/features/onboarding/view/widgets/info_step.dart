import 'package:flutter/material.dart';
import 'underline_text_field.dart';

class InfoStep extends StatelessWidget {
  final String title;
  final String body;
  final String firstNameLabel;
  final String lastNameLabel;
  final String phoneLabel;
  final TextEditingController fName;
  final TextEditingController lName;
  final TextEditingController phone;
  final bool saving;
  final VoidCallback onSave;
  final String tNext;
  const InfoStep(
      {super.key,
      required this.title,
      required this.body,
      required this.firstNameLabel,
      required this.lastNameLabel,
      required this.phoneLabel,
      required this.fName,
      required this.lName,
      required this.phone,
      required this.saving,
      required this.onSave,
      required this.tNext});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text(body, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.white)),
          const SizedBox(height: 16),
          UnderlineTextField(controller: fName, label: firstNameLabel),
          const SizedBox(height: 8),
          UnderlineTextField(controller: lName, label: lastNameLabel),
          const SizedBox(height: 8),
          UnderlineTextField(controller: phone, label: phoneLabel, numeric: true),
          const Spacer(),
          SizedBox(
            width: 260,
            child: ElevatedButton(
              onPressed: onSave,
              child: saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : Text(tNext),
            ),
          ),
        ],
      ),
    );
  }
}

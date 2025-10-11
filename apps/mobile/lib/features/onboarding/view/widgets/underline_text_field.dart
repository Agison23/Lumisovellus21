import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UnderlineTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool numeric;
  const UnderlineTextField({super.key, required this.controller, required this.label, this.numeric = false});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      keyboardType: numeric ? TextInputType.number : null,
      inputFormatters: numeric ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))] : null,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration().copyWith(
        label: Center(child: Text(label)),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.white)),
      ),
    );
  }
}

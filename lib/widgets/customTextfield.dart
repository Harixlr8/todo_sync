import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isMultiline;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: isMultiline ? 3 : 1,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade600, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade600, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}

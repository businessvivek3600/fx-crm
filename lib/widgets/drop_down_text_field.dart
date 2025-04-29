

// Your given CustomTextFormField
import 'package:flutter/material.dart';

class DropDownTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final bool readOnly;
  final bool isDate;
  final TextEditingController? controller;
  final VoidCallback? onTap;

  const DropDownTextFormField({
    super.key,
    required this.label,
    required this.hint,
    this.readOnly = false,
    this.isDate = false,
    this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black87, fontSize: 14)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly || isDate,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.shade100,
            suffixIcon:  const Icon(Icons.arrow_drop_down, color: Colors.grey), // show dropdown arrow
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blueAccent),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
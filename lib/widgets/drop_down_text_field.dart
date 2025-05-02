

// Your given CustomTextFormField
import 'package:flutter/material.dart';

class DropDownTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final bool readOnly;
  final bool isDate;
  final TextStyle? style;
  final Color? colors;
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
    this.colors,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = readOnly || isDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: style ?? TextStyle(color: colors ?? Colors.black87, fontSize: 14)),
        const SizedBox(height: 6),
        AbsorbPointer(
          absorbing: isDisabled, // ✅ disables interaction completely
          child: TextFormField(
            controller: controller,
            readOnly: true, // Always true since user should not type manually
            onTap: isDisabled ? null : onTap,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: isDisabled ? Colors.grey.shade200 : Colors.white,
              suffixIcon: Icon(Icons.arrow_drop_down,
                  color: isDisabled ? Colors.grey.shade400 : Colors.grey),
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
        ),
      ],
    );
  }
}

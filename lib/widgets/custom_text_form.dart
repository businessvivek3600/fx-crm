import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final bool readOnly;
  final bool isDate;
  final TextEditingController? controller;
  final String? initialValue;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  final Color? labelColor;
  final Icon? icon;
  final FocusNode? focusNode;
  final Color? fillColor;
  final String? Function(String?)? validator;       // 🛑 validator callback
  final void Function(String)? onChanged;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.hint,
    this.readOnly = false,
    this.isDate = false,
    this.controller,
    this.initialValue,
    this.onTap,
    this.validator,    // 🛑 initialize
    this.onChanged,
    this.textStyle,
    this.icon,
    this.labelColor, this.fillColor, this.focusNode
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: labelColor ?? Colors.white70, fontSize: 14)),
        const SizedBox(height: 6),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          initialValue: controller == null ? initialValue : null, // 🛑 Important
          readOnly: readOnly || isDate,
          onTap:  onTap,
          validator: validator, // 🛑 attach validator
          onChanged: onChanged,
          focusNode: focusNode,
          decoration: InputDecoration(
            prefixIcon: icon,
            hintText: hint,
            hintStyle: textStyle ?? const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: fillColor ?? Colors.grey.shade100,
            suffixIcon: isDate
                ? const Icon(Icons.calendar_today, color: Colors.grey, size: 20)
                : null,

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

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isFullWidth;

  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isFullWidth = true,

  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(

          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

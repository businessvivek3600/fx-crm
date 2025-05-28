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
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;

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
    this.autovalidateMode,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = readOnly || isDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: style ??
              TextStyle(
                color: colors ?? Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 6),
        AbsorbPointer(
          absorbing: isDisabled,
          child: TextFormField(
            controller: controller,
            autovalidateMode: autovalidateMode,
            validator: validator,
            readOnly: true,
            onTap: isDisabled ? null : onTap,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white60),
              filled: true,
              fillColor: Colors.white.withOpacity(0.08),
              suffixIcon: Icon(
                Icons.arrow_drop_down,
                color: isDisabled ? Colors.white30 : Colors.white60,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

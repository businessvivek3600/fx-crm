import 'package:flutter/material.dart';

class DropDownTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final bool readOnly;
  final bool isDate;
  final TextStyle? style;
  final TextStyle? textStyle;
  final Color? colors;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final AutovalidateMode? autovalidateMode;
  final Color? fillColor;
  final Color? focusedBorder;
  final Color? enabledBorder;
  final Color? dropdownDisableColor;
  final Color? dropdownEnableColor;
  final TextStyle? fieldStyle;
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
    this.focusedBorder,
    this.enabledBorder,
    this.textStyle,
    this.fillColor,
    this.dropdownDisableColor,
    this.dropdownEnableColor,
    this.fieldStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = readOnly || isDate;

    // Detect brightness of fillColor to auto-assign white or black text colors
    final Color bgColor = fillColor ?? Colors.white.withOpacity(0.08);
    final bool isDark = bgColor.computeLuminance() < 0.5;
    final Color defaultTextColor = isDark ? Colors.white : Colors.black;
    final Color defaultHintColor = isDark ? Colors.white60 : Colors.black45;
    final Color defaultBorderColor = isDark ? Colors.white30 : Colors.black26;
    final Color defaultDropdownEnableColor =
        isDark ? Colors.white60 : Colors.black87;
    final Color defaultDropdownDisableColor =
        isDark ? Colors.white30 : Colors.black26;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              style ??
              TextStyle(
                color: colors ?? defaultTextColor,
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
            style: fieldStyle ?? TextStyle(color: defaultTextColor),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: textStyle ?? TextStyle(color: defaultHintColor),
              filled: true,
              fillColor: bgColor,
              suffixIcon: Icon(
                Icons.arrow_drop_down,
                color:
                    isDisabled
                        ? dropdownDisableColor ?? defaultDropdownDisableColor
                        : dropdownEnableColor ?? defaultDropdownEnableColor,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: enabledBorder ?? defaultBorderColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: focusedBorder ?? defaultBorderColor,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

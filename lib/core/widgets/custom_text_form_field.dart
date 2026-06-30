import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.textAlign,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.textInputAction,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.focusNode,
    this.suffixText,
    this.prefixText,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
  });

  final TextEditingController controller;
  final TextAlign textAlign;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final int? maxLines;
  final FocusNode? focusNode;
  final String? suffixText;
  final String? prefixText;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      textAlign: textAlign,
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(
        color: isDark ? Colors.white : AppColors.textPrimaryLight,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        prefixText: prefixText,
        suffixText: suffixText,
        labelText: labelText,
        labelStyle: TextStyle(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: isDark ? AppColors.primary : AppColors.primary,
              )
            : null,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}

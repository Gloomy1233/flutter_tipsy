// lib/widgets/custom_text_form_field.dart

import 'package:flutter/material.dart';

import '../utils/constants.dart'; // Ensure this imports your constants like gradient, primaryDark, etc.

class AppThemeTextFormField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool readOnly;
  final TextInputType keyboardType;
  final int? maxLines;

  const AppThemeTextFormField({
    Key? key,
    required this.labelText,
    this.controller,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.suffixIcon,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle gradientTextStyle() {
      return TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        foreground: Paint()
          ..shader = gradient.createShader(
            Rect.fromLTWH(0.0, 0.0, MediaQuery.of(context).size.width, 24),
          ),
      );
    }

    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      validator: validator,
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          foreground: Paint()
            ..shader = gradient.createShader(
              const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
            ),
          backgroundColor: primaryDarkLighter,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryDark),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryOrange, width: 2.0),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
        ),
        filled: true,
        fillColor: primaryDarkLighter,
        suffixIcon: suffixIcon,
      ),
      style: gradientTextStyle(),
    );
  }
}

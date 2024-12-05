import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/constants.dart'; // Ensure this imports your constants like gradient, primaryDark, etc.

class AppThemeTextFormField extends StatelessWidget {
  final String labelText;
  final String? hintText; // New property for the hint text
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
    this.hintText, // Accepting the hintText as an optional parameter
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            color: primaryDarkLighter, // Required placeholder color
            fontSize: 16.sp,
            fontWeight: FontWeight.w100,
          ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          validator: validator,
          readOnly: readOnly,
          keyboardType: keyboardType,
          maxLines: maxLines,
          showCursor: true,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: primaryPink, width: 3.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: primaryOrange, width: 3.0),
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
            hintText: hintText,
          ),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            foreground: Paint()
              ..shader = gradient.createShader(
                const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
              ),
          ),
        ),
      ],
    );
  }
}

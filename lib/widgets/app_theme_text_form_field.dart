import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/constants.dart'; // Ensure this imports your constants like gradient, primaryDark, etc.

class AppThemeTextFormField extends StatelessWidget {
  final String labelText;
  final String? hintText; // Hint text
  final TextEditingController? controller;
  final bool obscureText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool readOnly;
  final TextInputType keyboardType;
  final int? maxLines;
  final int? maxLength; // Add maxLength for the character counter
  final String? errorText; // Add errorText for custom error messages
  final FocusNode? focusNode; // FocusNode for managing focus behavior
  final VoidCallback? onTap; // onTap for custom behavior

  const AppThemeTextFormField({
    Key? key,
    required this.labelText,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.suffixIcon,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.maxLength, // Pass maxLength as a constructor argument
    this.errorText,
    this.focusNode,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          labelText,
          style: TextStyle(
            color: primaryDarkLighter,
            fontSize: 18.sp,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8.0),

        // TextFormField with counter and error handling
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          onChanged: (value) {
            // Trigger external onChanged if provided
            if (onChanged != null) {
              onChanged!(value);
            }
          },

          validator: validator,
          obscureText: obscureText,
          readOnly: readOnly,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength, // Enforce maxLength here
          onTap: onTap,
          decoration: InputDecoration(
            filled: true,
            fillColor: primaryDarkLighter,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: primaryDarkLighter, width: 3.0),
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
            hintText: hintText,
            focusColor: primaryDarkLighter,
            hoverColor: primaryDarkLighter,
            hintStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              foreground: Paint()
                ..shader = gradientLight.createShader(
                  const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                ),
            ),
            errorText: errorText, // Display custom error messages
            counterText: maxLength != null
                ? '${maxLength! - (controller?.text.length ?? 0)} characters remaining'
                : null, // Show remaining characters if maxLength is defined
            counterStyle: TextStyle(
              fontSize: 10.sp,
              color: primaryDark,
            ),
            suffixIcon: suffixIcon,
          ),

          style: TextStyle(
            fontSize: 16.sp,
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

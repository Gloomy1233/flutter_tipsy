import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/constants.dart'; // Ensure this imports your constants like gradient, primaryDark, etc.

class AppThemeTextFormField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool readOnly;
  final bool isDisabled; // New property for explicitly disabling the field
  final TextInputType keyboardType;
  final int? maxLines;
  final int? maxLength;
  final String? errorText;
  final FocusNode? focusNode;
  final VoidCallback? onTap;

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
    this.isDisabled = false, // Default to false
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.maxLength,
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
            color: isDisabled
                ? Colors.grey
                : primaryDarkLighter, // Dim the label when disabled
            fontSize: 18.sp,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8.0),

        // TextFormField
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          onChanged: (value) {
            if (onChanged != null) onChanged!(value);
          },
          validator: validator,
          obscureText: obscureText,
          readOnly: readOnly || isDisabled, // Treat `isDisabled` as readOnly
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          onTap: isDisabled ? null : onTap, // Disable onTap if `isDisabled`
          decoration: InputDecoration(
            filled: true,
            fillColor: isDisabled
                ? Colors.grey[300]
                : primaryDarkLighter, // Change background color when disabled
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDisabled ? Colors.grey : primaryDarkLighter,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDisabled ? Colors.grey : primaryOrange,
                width: 3.0,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 2.0,
              ),
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isDisabled ? Colors.grey : primaryDark,
            ),
            errorText: errorText,
            counterText: maxLength != null
                ? '${maxLength! - (controller?.text.length ?? 0)} characters remaining'
                : null,
            counterStyle: TextStyle(
              fontSize: 10.sp,
              color: isDisabled ? Colors.grey : primaryDark,
            ),
            suffixIcon: suffixIcon,
          ),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.normal,
            // color: isDisabled
            //     ? Colors.grey
            //     : Colors.black,
            foreground: Paint()
              ..shader = gradient.createShader(
                Rect.fromLTWH(
                  0.0,
                  0.0,
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height,
                ),
              ),
            // Change text color when disabled
          ),
        ),
      ],
    );
  }
}

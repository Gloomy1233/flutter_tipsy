import 'package:flutter/material.dart';

import '../utils/constants.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Gradient gradientBg;
  final double fontSize;
  final EdgeInsets padding;
  final BorderRadius radius;
  final double width;
  final double height;
  final bool isIcon;
  final Icon icon;
  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradientBg = gradient,
    this.fontSize = 12.0,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
    required this.radius,
    this.width = 200,
    this.isIcon = false,
    this.icon = const Icon(Icons.arrow_forward, color: Colors.white),
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradientBg,
        borderRadius: radius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onPressed,
          child: Padding(
            padding: padding,
            child: Center(
                child: isIcon
                    ? icon
                    : Text(
                        text,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize,
                        ),
                      )),
          ),
        ),
      ),
    );
  }
}

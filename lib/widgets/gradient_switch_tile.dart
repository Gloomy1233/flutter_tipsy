import 'package:flutter/material.dart';
import 'package:flutter_tipsy/utils/constants.dart';

class GradientSwitchTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String title;
  final Gradient thumbGradient;
  final Gradient trackGradient;
  final Color activeBackgroundColor;
  final Color inactiveBackgroundColor;

  const GradientSwitchTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    required this.thumbGradient,
    required this.trackGradient,
    required this.activeBackgroundColor,
    required this.inactiveBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        value ? activeBackgroundColor : inactiveBackgroundColor;

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
          Switch(
            value: false,
            onChanged: (value) {},
            activeColor: primaryOrange,
          ),
        ],
      ),
    );
  }
}

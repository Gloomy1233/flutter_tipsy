import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
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
          FlutterSwitch(
            width: 55.0,
            height: 25.0,
            toggleSize: 22.0,
            value: value,
            borderRadius: 30.0,
            padding: 2.0,
            activeColor: primaryPink,
            inactiveColor: primaryDark,
            toggleColor: primaryDark,
            activeToggleColor: primaryDark,
            inactiveToggleColor: primaryPink,
            switchBorder: Border.all(
              color: primaryDark,
              width: 0.0,
            ),
            toggleBorder: Border.all(
              color: Colors.transparent,
              width: 0.0,
            ),
            activeSwitchBorder: Border.all(
              color: primaryDark,
              width: 0.0,
            ),
            inactiveSwitchBorder: Border.all(
              color: primaryPink,
              width: 0.0,
            ),
            activeToggleBorder: Border.all(
              color: Colors.transparent,
              width: 0.0,
            ),
            inactiveToggleBorder: Border.all(
              color: Colors.transparent,
              width: 0.0,
            ),
            onToggle: onChanged,
          ),
        ],
      ),
    );
  }
}

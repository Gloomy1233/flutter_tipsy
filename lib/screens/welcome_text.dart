// widgets/welcome_text.dart
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/utils/constants.dart';
import 'package:sizer/sizer.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Let's Get The",
          style: TextStyle(
              fontSize: 24.sp, color: Colors.black, fontFamily: 'Serif'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Party ",
              style: TextStyle(
                  fontSize: 24.sp, color: primaryOrange, fontFamily: 'Serif'),
            ),
            Text(
              "Started!",
              style: TextStyle(
                  fontSize: 24.sp, color: Colors.black, fontFamily: 'Serif'),
            ),
          ],
        ),
      ],
    );
  }
}

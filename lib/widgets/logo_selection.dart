// widgets/logo_section.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20.w,
      backgroundColor: Colors.white,
      child: ClipOval(
        child: Image.asset(
          'assets/logo.png', // Replace with your logo asset path
          fit: BoxFit.cover,
          width: 40.w,
          height: 40.w,
        ),
      ),
    );
  }
}

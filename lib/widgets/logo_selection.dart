// widgets/logo_section.dart
import 'package:flutter/material.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'C:\\Users\\Administrator\\Desktop\\flutter_tipsy\\lib\\assets\\Logo.png', // Replace with your logo asset path
      width: 400,
      height: 400,
    );
  }
}

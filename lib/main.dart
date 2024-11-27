import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/screens/login_screen.dart';
import 'package:flutter_tipsy/utils/constants.dart';
import 'package:sizer/sizer.dart'; // For responsive sizing

void main() {
  Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Your App Name',
          theme: ThemeData(
            primaryColor: primaryDark,
            fontFamily: 'Serif',
          ),
          home: const LoginScreen(),
        );
      },
    );
  }
}

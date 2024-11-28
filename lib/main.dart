import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/screens/home_screens/home_screen.dart';
import 'package:flutter_tipsy/screens/login_screen.dart';
import 'package:flutter_tipsy/screens/register_screens/register_screen.dart';
import 'package:flutter_tipsy/test.dart';
import 'package:flutter_tipsy/utils/constants.dart';
import 'package:sizer/sizer.dart'; // For responsive sizing

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures bindings are initialized for async calls

  await Firebase.initializeApp(); // Initializes Firebase

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
          initialRoute: '/test',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const RegisterScreen(),
            '/home': (context) => const HomeScreen(),
            '/test': (context) => const Test()
            //'/profile': (context) => ProfilePage(),
            // Προσθέστε και άλλες διαδρομές αν χρειάζεται
          },
        );
      },
    );
  }
}

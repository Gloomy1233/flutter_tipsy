// lib/screens/login_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/screens/home_screens/home_screen.dart';
import 'package:flutter_tipsy/screens/register_screens/register_screen.dart';
import 'package:flutter_tipsy/screens/welcome_text.dart';
import 'package:flutter_tipsy/utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../utils/ThemePreferences.dart';
import '../viewmodels/current_user.dart';
import '../viewmodels/user_model.dart';
import '../widgets/logo_selection.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // State variables
  bool isLoading = false;
  String? errorMessage;

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Login function using Firebase Authentication
  Future<void> _login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Sign in with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Get user data from Firestore
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          UserDataModel userData = UserDataModel.fromMap(userDoc.data()!);
          CurrentUser().user = userData;
          // Navigate to HomeScreen and pass userData
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(userData: userData),
            ),
          );
        } else {
          setState(() {
            errorMessage = 'User data not found.';
            isLoading = false;
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'An unexpected error occurred.';
        isLoading = false;
      });
    }
  }

  // Forgot password function
  void _forgotPassword() {
    if (emailController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please enter your email to reset password.';
      });
      return;
    }

    FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim())
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent.')),
      );
    }).catchError((e) {
      setState(() {
        errorMessage = e.message;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.of(context);
    final isDarkMode = themeController?.themeMode == ThemeMode.dark;

    return Scaffold(
      // Use Stack to layer background shapes and content
      // Add the drawer here
      drawer: Drawer(
        child: Column(
          children: [
            // Drawer Header
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                        'assets/avatar.png'), // Replace with your image
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Amazing Skirt',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Primary account',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Drawer Items
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.sync),
                    title: Text('Connection and sync'),
                  ),
                  ListTile(
                    leading: Icon(Icons.account_balance_wallet),
                    title: Text('Wallets'),
                  ),
                  ListTile(
                    leading: Icon(Icons.contacts),
                    title: Text('Address book'),
                  ),
                  ListTile(
                    leading: Icon(Icons.security),
                    title: Text('Security and backup'),
                  ),
                  ListTile(
                    leading: Icon(Icons.privacy_tip),
                    title: Text('Privacy'),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Display settings'),
                  ),
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text('Support'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ), // AppBar with Menu Icon
      appBar: AppBar(
        title: const Text('Drawer Example'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context)
                    .openDrawer(); // Open the drawer programmatically
              },
            );
          },
        ),
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 6.h),
                  const LogoSection(),
                  SizedBox(height: 4.h),
                  const WelcomeText(),
                  SizedBox(height: 2.h),
                  EmailInput(controller: emailController),
                  SizedBox(height: 2.h),
                  PasswordInput(controller: passwordController),
                  if (errorMessage != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 10.sp),
                    ),
                  ],
                  ForgotPasswordButton(onForgotPassword: _forgotPassword),
                  SizedBox(height: 1.h),
                  LoginButton(onLogin: _login, isLoading: isLoading),
                  SizedBox(height: 2.h),
                  const SocialMediaLogin(),
                  SignUpSection(onSignUp: () {
                    // Navigate to Sign Up screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  }),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  final TextEditingController controller;

  const EmailInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    controller.text = "nikos123@gmail.com";
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'E-mail',
          prefixIcon: const Icon(Icons.email, color: primaryDark),
          labelStyle: TextStyle(color: primaryOrange, fontSize: 14.sp),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: primaryDark),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: primaryDark),
          ),
        ),
      ),
    );
  }
}

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;

  const PasswordInput({super.key, required this.controller});

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    widget.controller.text = "19961996";
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: TextField(
        controller: widget.controller,
        obscureText: !passwordVisible,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(color: primaryOrange, fontSize: 14.sp),
          prefixIcon: const Icon(Icons.lock, color: primaryDark),
          suffixIcon: IconButton(
            icon: Icon(
              passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: primaryDark,
            ),
            onPressed: () {
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: primaryDark),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: primaryDark),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  final VoidCallback onForgotPassword;

  const ForgotPasswordButton({super.key, required this.onForgotPassword});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onForgotPassword,
      child: Text(
        'Forgot Password',
        style: TextStyle(color: primaryOrange, fontSize: 13.sp),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final VoidCallback onLogin;
  final bool isLoading;

  const LoginButton(
      {super.key, required this.onLogin, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.w,
      height: 6.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 6,
        ),
        child: isLoading
            ? CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                'LOG IN',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader =
                        gradient.createShader(Rect.fromLTWH(0, 0, 80.w, 6.h)),
                  letterSpacing: 1.5,
                ),
              ),
      ),
    );
  }
}

class SocialMediaLogin extends StatelessWidget {
  const SocialMediaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          color: primaryDark,
          indent: 150,
          endIndent: 150,
        ),
        const Text(
          'Or use',
          style: TextStyle(color: gradientOrange),
        ),
        const Divider(
          color: primaryDark,
          indent: 150,
          endIndent: 150,
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: 80.w,
          child: OutlinedButton.icon(
            onPressed: () {
              // Implement Facebook login here
            },
            icon: const FaIcon(FontAwesomeIcons.facebook, color: primaryDark),
            label: Text(
              'Sign in with Facebook',
              style: TextStyle(fontSize: 14.sp, color: primaryDarkLighter),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: 80.w,
          child: OutlinedButton.icon(
            onPressed: () {
              // Implement Google sign-in here
            },
            icon: const FaIcon(FontAwesomeIcons.google, color: primaryDark),
            label: Text(
              'Sign in with Google',
              style: TextStyle(fontSize: 14.sp, color: primaryDarkLighter),
            ),
          ),
        ),
      ],
    );
  }
}

class SignUpSection extends StatelessWidget {
  final VoidCallback onSignUp;

  const SignUpSection({super.key, required this.onSignUp});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an Account?",
          style: TextStyle(fontSize: 14.sp, color: Colors.black),
        ),
        TextButton(
          onPressed: onSignUp,
          child: Text(
            'Sign Up',
            style: TextStyle(fontSize: 14.sp, color: primaryOrange),
          ),
        ),
      ],
    );
  }
}

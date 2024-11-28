// screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/screens/register_screens/register_screen.dart';
import 'package:flutter_tipsy/screens/welcome_text.dart';
// import 'package:your_app_name/screens/sign_in_screen.dart';
import 'package:flutter_tipsy/utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../widgets/logo_selection.dart';
import 'home_screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use Stack to layer background shapes and content
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
                  EmailInput(),
                  SizedBox(height: 2.h),
                  const PasswordInput(),
                  SizedBox(height: 2.h),
                  ForgotPasswordButton(onForgotPassword: () {
                    // Handle forgot password
                  }),
                  SizedBox(height: 2.h),
                  LoginButton(onLogin: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                    // Handle login success
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => HomeScreen()),
                    // );
                  }),
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
  final TextEditingController controller = TextEditingController();

  EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'E-mail',
          prefixIcon: const Icon(Icons.email, color: primaryDark),
          labelStyle: TextStyle(color: primaryOrange, fontSize: 10.sp),
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
  const PasswordInput({super.key});

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool passwordVisible = false;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: TextField(
        controller: controller,
        obscureText: !passwordVisible,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(color: primaryOrange, fontSize: 10.sp),
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
        style: TextStyle(color: primaryOrange, fontSize: 10.sp),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final VoidCallback onLogin;

  const LoginButton({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.w,
      height: 6.h,
      child: ElevatedButton(
        onPressed: onLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 6,
        ),
        child: Text(
          'LOG IN',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = gradient.createShader(Rect.fromLTWH(0, 0, 80.w, 6.h)),
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
        const Divider(color: primaryDark),
        const Text(
          'Or use',
          style: TextStyle(color: gradientOrange),
        ),
        const Divider(color: primaryDark),
        SizedBox(height: 2.h),
        SizedBox(
          width: 80.w,
          child: OutlinedButton.icon(
            onPressed: () {
              // Handle Facebook login
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
              // Handle Google login
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

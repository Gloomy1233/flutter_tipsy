// screens/step1_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';
import '../../viewmodels/registration_viewmodel.dart';

class Step1Screen extends StatefulWidget {
  const Step1Screen({super.key});

  @override
  _Step1ScreenState createState() => _Step1ScreenState();
}

class _Step1ScreenState extends State<Step1Screen> {
  bool visible = false;

  @override
  void initState() {
    super.initState();
    // Trigger the visibility after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegistrationViewModel>(context);

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Column(
            // Center the content vertically
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // User Card

              SizedBox(height: 32.0),
              // Animated Visibility Text
              const Text(
                "What account type do you want?\n(You can change this later)",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
              ),

              const SizedBox(height: 32.0),
              // Animated Buttons
              Column(
                children: [
                  _buildAccountTypeCard(
                    title: 'I just want to Party',
                    subtitle: 'Party',
                    isSelected: !viewModel.isGuest,
                    onTap: () => viewModel.setAccountType(false),
                  ),
                  const SizedBox(height: 16.0),
                  // Host Card
                  _buildAccountTypeCard(
                    title: 'I want to host Events',
                    subtitle: 'Host',
                    isSelected: viewModel.isGuest,
                    onTap: () => viewModel.setAccountType(true),
                  )
                ],
              ),

              const SizedBox(height: 32.0),
              // Sign In Text Button

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signin');
                },
                child: const Text(
                  "Already have an account? Sign in",
                  style: TextStyle(color: primaryOrange),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildAccountTypeCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      color: isSelected ? primaryDark : primaryOrange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: isSelected ? 8.0 : 4.0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Replace with your image asset
              CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.white,
                child: Icon(
                  isSelected ? Icons.check_circle : Icons.circle,
                  size: 30.0,
                  color: primaryOrange,
                ),
              ),
              const SizedBox(width: 16.0),
              // Text Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFC4C4),
                      ),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFFFFC4C4),
                      ),
                    ),
                  ],
                ),
              ),
              // Selection Icon
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFFFFC4C4),
                  size: 24.0,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_tipsy/utils/constants.dart';

// Import your HomeScreen
import '../home_screen.dart';

/// A reusable Floating Action Button that navigates to [HomeScreen]
/// at a specified [initialIndex] and [isHostInitially] state.
/// like this
/// floatingActionButton: Row(
//   mainAxisAlignment: MainAxisAlignment.end,
//   children: [
//     BackToHostHomeScreenButton(
//       initialIndex: 3,       // Jump straight to index 3 in the host tabs
//       isHostInitially: true, // Ensure host mode is enabled
//     ),
//   ],
// ),
// Import your HomeScreen

// Example normal button that navigates to HomeScreen as host at index = 3
class BackToHostHomeScreenButton extends StatelessWidget {
  final int initialIndex;
  final bool isHostInitially;

  const BackToHostHomeScreenButton({
    Key? key,
    this.initialIndex = 3,
    this.isHostInitially = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleBackToHostHomeScreen(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        shape: const CircleBorder(), // Circular shape
      ),
      // No text, just an icon
      child: Icon(
        Icons.close,
        color: primaryPink,
      ),
    );
  }

  void _handleBackToHostHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          userData: null, // or pass actual user data here
          initialIndex: initialIndex,
          isHostInitially: isHostInitially,
        ),
      ),
    );
  }
}

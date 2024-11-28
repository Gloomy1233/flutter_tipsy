import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/utils/constants.dart';

import '../../widgets/background_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isHost = false;

  // Initial Screens and Icons
  List<Widget> _screens = screensMainScreenGuest;

  List<Widget> _icons = iconsMainScreenGuest;

  final GlobalKey<CurvedNavigationBarState> _navBarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        const BackgroundWidget(),
        _screens[_currentIndex]
      ]), // Display the selected screen
      bottomNavigationBar: CurvedNavigationBar(
        key: _navBarKey,
        index: _currentIndex,
        height: 60,
        items: _icons,
        color: primaryDark,
        buttonBackgroundColor: primaryDark,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) async {
          if (index == 4) {
            // Show confirmation dialog for switching user
            bool shouldProceed = await _showSwitchUserDialog(context);
            if (!shouldProceed) {
              // Reset the navigation bar to the current index
              final navBarState = _navBarKey.currentState;
              navBarState?.setPage(_currentIndex);
            } else {
              // Change icons and screens dynamically
              if (_isHost) {
                _swapUser(iconsMainScreenHost, screensMainScreenHost);
                _isHost = !_isHost;
              } else {
                _swapUser(iconsMainScreenGuest, screensMainScreenGuest);
                _isHost = !_isHost;
              }
            }
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }

  Future<bool> _showSwitchUserDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Switch User"),
              content: const Text("Are you sure you want to switch users?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Return "false" to cancel
                  },
                  child: const Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return "true" to proceed
                  },
                  child: const Text("Yes"),
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if dialog is dismissed
  }

  void _swapUser(List<Widget> icons, List<Widget> screens) {
    // Update icons and screens for the new user
    setState(() {
      _icons = icons;

      _screens = screens;

      _currentIndex = 0; // Reset to the first tab
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User switched successfully!")),
    );
  }
}

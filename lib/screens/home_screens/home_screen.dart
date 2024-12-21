import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/utils/constants.dart';

import '../../viewmodels/user_model.dart';
import '../../widgets/background_widget.dart';

class HomeScreen extends StatefulWidget {
  final UserDataModel? userData;

  const HomeScreen({
    super.key,
    required this.userData,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isHost = false;

  // Icons and screens for guest and host views
  final List<Widget> _guestScreens = screensMainScreenGuest;
  final List<Widget> _hostScreens = screensMainScreenHost;

  final List<Widget> _guestIcons = iconsMainScreenGuest;
  final List<Widget> _hostIcons = iconsMainScreenHost;

  List<Widget> get _currentScreens => _isHost ? _hostScreens : _guestScreens;
  List<Widget> get _currentIcons => _isHost ? _hostIcons : _guestIcons;

  final GlobalKey<CurvedNavigationBarState> _navBarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background Widget
          const BackgroundWidget(),

          // Current screen
          _currentScreens[_currentIndex],

          // Dark Mode Toggle Button
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: Icon(isDarkMode ? Icons.brightness_7 : Icons.brightness_2),
              onPressed: _toggleDarkMode, // Fixed undefined reference
            ),
          ),

          // Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CurvedNavigationBar(
              key: _navBarKey,
              index: _currentIndex,
              height: 60,
              items: _currentIcons,
              color: primaryDark,
              buttonBackgroundColor: primaryDark,
              backgroundColor: Colors.transparent,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 300),
              onTap: (index) => _onNavItemTap(index, context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onNavItemTap(int index, BuildContext context) async {
    if (index == 4) {
      // Handle user switch
      bool shouldProceed = await _showSwitchUserDialog(context);
      if (shouldProceed) {
        _toggleUserMode();
      } else {
        // Reset the navigation bar to the current index
        _navBarKey.currentState?.setPage(_currentIndex);
      }
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
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
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("No"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Yes"),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _toggleUserMode() {
    setState(() {
      _isHost = !_isHost;
      _currentIndex = 0; // Reset to the first tab
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            _isHost ? "Switched to Host mode!" : "Switched to Guest mode!"),
      ),
    );
  }

  // New function to toggle dark mode
  void _toggleDarkMode() {
    // Simulated toggle logic: you may integrate with your state management
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    setState(() {
      if (isDarkMode) {
        // Switch to light mode
        ThemeMode.light;
      } else {
        // Switch to dark mode
        ThemeMode.dark;
      }
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp(Set<dynamic> set, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeNotifier.themeMode,
      builder: (context, currentTheme, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          themeMode: currentTheme,
          theme: ThemeData.light(), // Define your light theme
          darkTheme: ThemeData.dark(), // Define your dark theme
          home: const HomeScreen(
            userData: null,
          ),
        );
      },
    );
  }
}

class ThemeNotifier {
  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier(ThemeMode.light);

  static void toggleTheme() {
    themeMode.value =
        themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

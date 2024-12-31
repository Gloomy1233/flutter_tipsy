import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/screens/home_screens/host_screens/create_event_screens/create_event_screen.dart';
import 'package:flutter_tipsy/screens/login_screen.dart';
import 'package:flutter_tipsy/screens/register_screens/register_screen.dart';
import 'package:flutter_tipsy/utils/ThemePreferences.dart';
import 'package:flutter_tipsy/utils/constants.dart';
import 'package:flutter_tipsy/viewmodels/ThemeConstroler.dart';
import 'package:flutter_tipsy/viewmodels/user_view_model.dart';
import 'package:nominatim_flutter/nominatim_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'firebase_options.dart'; // For responsive sizing

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures bindings are initialized for async calls
  NominatimFlutter.instance.configureDioCache(
    useCacheInterceptor: true,
    maxStale: Duration(days: 7),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initializes Firebase

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserViewModel()),
      ChangeNotifierProvider(create: (_) => ThemeProvider()),

      // Μπορείτε να προσθέσετε και άλλους providers εδώ
    ],
    child: MyApp(),
  ));
  if (kIsWeb) {
    await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));
  } else {
    String storageLocation = (await getApplicationDocumentsDirectory()).path;
    await FastCachedImageConfig.init(
        subDir: storageLocation, clearCacheAfter: const Duration(days: 15));
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return ThemeController(
          themeMode: _themeMode,
          toggleTheme: _toggleTheme,
          child: MaterialApp(
            title: 'Your App Name',
            theme: AppTheme.light, // Use light theme
            darkTheme: AppTheme.dark, // Use dark theme
            themeMode: _themeMode,
            initialRoute: '/test',
            routes: {
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const RegisterScreen(),
              //'/home': (context) => const HomeScreen(userData: null,),
              '/test': (context) => CreateEventScreen(),
              //'/eventDetails': (context) => PartyDetailPage(title: title, activities: activities, attire: attire, decor: decor, imageUrl: imageUrl, iconUrl: iconUrl),
              // Προσθέστε και άλλες διαδρομές αν χρειάζεται
            },
          ),
        );
      },
    );
  }
}

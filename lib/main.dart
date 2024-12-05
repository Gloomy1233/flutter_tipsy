import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/screens/home_screens/host_screens/create_event_screens/create_event_screen.dart';
import 'package:flutter_tipsy/screens/login_screen.dart';
import 'package:flutter_tipsy/screens/register_screens/register_screen.dart';
import 'package:flutter_tipsy/utils/constants.dart';
import 'package:flutter_tipsy/viewmodels/user_view_model.dart';
import 'package:nominatim_flutter/nominatim_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart'; // For responsive sizing

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures bindings are initialized for async calls
  NominatimFlutter.instance.configureDioCache(
    useCacheInterceptor: true,
    maxStale: Duration(days: 7),
  );

  String storageLocation = (await getApplicationDocumentsDirectory()).path;
  await FastCachedImageConfig.init(
      subDir: storageLocation, clearCacheAfter: const Duration(days: 15));

  await Firebase.initializeApp(); // Initializes Firebase

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserViewModel())
      // Μπορείτε να προσθέσετε και άλλους providers εδώ
    ],
    child: MyApp(),
  ));
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
            // '/home': (context) => const HomeScreen(),
            '/test': (context) => CreateEventScreen()
            //'/profile': (context) => ProfilePage(),
            // Προσθέστε και άλλες διαδρομές αν χρειάζεται
          },
        );
      },
    );
  }
}

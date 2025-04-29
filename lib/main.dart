import 'package:flutter/material.dart';
import 'package:stockappflutter/pages/auth_page.dart';
import 'package:stockappflutter/pages/home_page.dart'; // Import the HomePage
import 'package:stockappflutter/pages/favorites_page.dart'; // Import the favorites page
import 'package:stockappflutter/pages/news_page.dart'; // Import the news page
import 'package:stockappflutter/pages/account_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
      routes: {
        '/home': (context) => HomePage(), // Define the /home route
        '/favorites' : (context) => Favorites(),
        '/news_page' : (context) => NewsPage(),
        '/account_page': (context) => AccountPage(),
      },
    );
  }
}
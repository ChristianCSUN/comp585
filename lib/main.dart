import 'package:flutter/material.dart';
import 'package:stockappflutter/pages/auth_page.dart';
import 'package:stockappflutter/pages/home_page.dart'; // Import the HomePage

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
      routes: {
        '/home': (context) => HomePage(), // Define the /home route
      },
    );
  }
}

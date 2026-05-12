import 'package:firebase_core/firebase_core.dart';
import 'package:fitnova/features/auth/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() async {   //Initializes Flutter framework and Firebase before launching the FitNova application
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitNova',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF000000),
        
      ),
      home: Splashscreen(),
    );
  }
}




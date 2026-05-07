import 'package:firebase_core/firebase_core.dart';
import 'package:fitnova/MainNavScreen.dart';
import 'package:fitnova/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitnova/tempinitscreen.dart';

void main() async {
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('App'),
      ),
      
      body: Center(
       child: Text('Hello world', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),),
      ),


      
    );
  }
}

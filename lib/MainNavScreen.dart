import 'package:flutter/material.dart';
import 'package:fitnova/bottom_nav.dart';
import 'HomePage.dart';
import 'profile_screen.dart';
import 'progress_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  late List<Widget> screens;
  int currentIndex = 0;

  int targetCalories = 2200;

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void updateCalories(int calories) {
    setState(() {
      targetCalories = calories;

      screens[1] = ProgressScreen(
        targetCalories: targetCalories,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    screens = [
      HomeScreen(),

      ProgressScreen(
        targetCalories: targetCalories,
      ),

      ProfileScreen(
        onCaloriesCalculated: updateCalories,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      bottomNavigationBar: BottomNav(
        currentIndex: currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
}
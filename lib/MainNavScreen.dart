import 'package:flutter/material.dart';
import 'package:fitnova/bottom_nav.dart';
import 'HomePage.dart';
import 'progress_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  int targetCalories = 2200; // default value

  late List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = [
      HomeScreen(),
      ProgressScreen(targetCalories: targetCalories),
      ProfileScreen(onCaloriesCalculated: updateCalories),
    ];
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  // ✅ FIXED: function in correct place
  void updateCalories(int calories) {
    setState(() {
      targetCalories = calories;

      // rebuild ProgressScreen with new calories
      screens[1] = ProgressScreen(targetCalories: targetCalories);
    });
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
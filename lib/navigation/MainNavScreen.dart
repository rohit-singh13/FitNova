import 'package:flutter/material.dart';
import 'package:fitnova/core/widgets/bottom_nav.dart';
import '../features/home/HomePage.dart';
import '../features/profile/profile_screen.dart';
import '../features/progress/progress_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  late List<Widget> screens;
  int currentIndex = 0;
  int targetCalories = 2200;

  void onTabTapped(int index) {   //Handles the bottom navigation tab switching
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
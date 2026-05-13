import 'package:flutter/material.dart';
import 'package:fitnova/core/widgets/app_background.dart';
import 'package:fitnova/features/progress/nutrition_tab.dart';
import 'package:fitnova/features/progress/overview_tab.dart';
import 'package:fitnova/features/progress/workout_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProgressScreen extends StatefulWidget {
  final int targetCalories;

  final Map<String, dynamic>? generatedWorkout;

  const ProgressScreen({
    super.key,
    required this.targetCalories,
    this.generatedWorkout,
  });

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class WeightData {
  final String date;
  final double weight;

  WeightData({required this.date, required this.weight});
}

class _ProgressScreenState extends State<ProgressScreen>  with SingleTickerProviderStateMixin{

  int? workoutDays;
  String? level;
  String? goal;
  bool isLoadingUser = true;

  late TabController _tabController;

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      final data = doc.data();

      if (data != null) {
        setState(() {
          workoutDays = data["workoutDays"];
          String normalizedLevel = data["experience"].toLowerCase();

          if (normalizedLevel.contains("beginner")) {
            normalizedLevel = "beginner";
          } else if (normalizedLevel.contains("intermediate")) {
            normalizedLevel = "intermediate";
          } else {
            normalizedLevel = "advanced";
          }
          level = normalizedLevel;
          goal = data["goal"];
          isLoadingUser = false;
        });
      }
    } catch (e) {
      debugPrint("ERROR FETCHING USER: $e");
      setState(() => isLoadingUser = false);
    }
  }



  @override
  void initState() {    //Initializes tabs and loads user progress data
    super.initState();
    _tabController = TabController(length: 3, vsync: this);   //Controls tab switching

    fetchUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 20),
                _buildTabs(),
                SizedBox(height: 20),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [

                      OverviewTab(),

                      isLoadingUser
                          ? Center(child: CircularProgressIndicator(color: Colors.white))
                          : (workoutDays == null || level == null || goal == null)
                          ? Center(
                        child: Text(
                          "Missing user data",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                          : WorkoutTab(
                        days: workoutDays!,
                        level: level!,
                        goal: goal!,
                        workout: widget.generatedWorkout,
                      ),

                      NutritionTab(targetCalories: widget.targetCalories),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {   //Builds top navigation tabs for progress sections
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Color(0xFF6C5CE7),
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white54,
        tabs: [
          Tab(text: "Overview"),
          Tab(text: "Workouts"),
          Tab(text: "Nutrition"),
        ],
      ),
    );
  }


}
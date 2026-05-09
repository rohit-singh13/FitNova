import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fitnova/core/widgets/app_background.dart';
import 'package:fitnova/features/progress/nutrition_tab.dart';
import 'package:fitnova/data/food_database.dart';
import 'package:fitnova/features/progress/overview_tab.dart';
import 'package:fitnova/features/progress/workout_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnova/data/workout_storage.dart';

class ProgressScreen extends StatefulWidget {
  final int targetCalories;

  // 🔥 ADD THIS
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

  List<WeightData> weightData = [
    WeightData(date: "May 10", weight: 76),
    WeightData(date: "May 12", weight: 75),
    WeightData(date: "May 15", weight: 76.5),
    WeightData(date: "May 18", weight: 75),
    WeightData(date: "May 22", weight: 73),
    WeightData(date: "May 25", weight: 74.5),
    WeightData(date: "May 28", weight: 73),
    WeightData(date: "May 31", weight: 71),
    WeightData(date: "Jun 3", weight: 70),
    WeightData(date: "Jun 7", weight: 68),
  ];

  int totalWorkouts = 24;     //for workout summary
  double totalHours = 18.6;   //for workout summary
  int caloriesBurned = 4250;  //for workout summary
  FoodItem? food;

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
      print("ERROR FETCHING USER: $e");
      setState(() => isLoadingUser = false);
    }
  }



  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    fetchUserData();

    food = getFood("chicken");

    if (food != null) {
      double qty = 100;

      double calories = qty * food!.caloriesPerGram;
      double protein = qty * food!.proteinPerGram;
      double carbs = qty * food!.carbsPerGram;
      double fats = qty * food!.fatsPerGram;

      print("Calories: $calories");
      print("Protein: $protein");
      print("Carbs: $carbs");
      print("Fats: $fats");
    }
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

                      // 🔹 TAB 2 → Workouts
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

                      // 🔹 TAB 3 → Nutrition
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

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
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
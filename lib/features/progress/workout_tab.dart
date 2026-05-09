import 'package:flutter/material.dart';
import 'package:fitnova/features/workout/services/workout_services.dart';
import 'package:fitnova/data/workout_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnova/data/workout_storage.dart';

class WorkoutTab extends StatefulWidget {
  final int days;
  final String level;
  final String goal;
  final Map<String, dynamic>? workout;


  const WorkoutTab({
    required this.days,
    required this.level,
    required this.goal,
    this.workout,
  });

  @override
  State<WorkoutTab> createState() => _WorkoutTabState();
}

class _WorkoutTabState extends State<WorkoutTab> {
  late Map<String, dynamic> todayWorkout;

  Set<String> completedExercises = {};

  Future<void> initializeTodayProgress() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid);

    final doc = await docRef.get();

    final data = doc.data();

    final now = DateTime.now();

    final today =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    // If no progress exists OR old date
    if (data == null ||
        data["todayWorkoutProgress"] == null ||
        data["todayWorkoutProgress"]["date"] != today) {

      await docRef.set({
        "todayWorkoutProgress": {
          "date": today,
          "completed": [],
        }
      }, SetOptions(merge: true));

      completedExercises.clear();
    }
  }

  Future<void> loadProgress() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    final data = doc.data();

    if (data == null ||
        data["todayWorkoutProgress"] == null) {
      return;
    }

    // 🔥 ALL EXERCISES IN TODAY'S WORKOUT
    Set<String> validExercises = {};

    for (var e in todayWorkout["warmup"]) {
      validExercises.add(e.name);
    }

    for (var e in todayWorkout["main"]) {
      validExercises.add(e.name);
    }

    for (var e in todayWorkout["stretching"]) {
      validExercises.add(e.name);
    }

    // 🔥 LOADED FROM FIRESTORE
    List completed =
        data["todayWorkoutProgress"]["completed"] ?? [];

    // 🔥 KEEP ONLY TODAY'S VALID EXERCISES
    Set<String> filtered = completed
        .map((e) => e.toString())
        .where((e) => validExercises.contains(e))
        .toSet();

    setState(() {
      completedExercises = filtered;
    });
  }

  Future<void> updateProgress(String exerciseName, bool isChecked) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid);

    if (isChecked) {
      completedExercises.add(exerciseName);
    } else {
      completedExercises.remove(exerciseName);
    }

    await docRef.update({
      "todayWorkoutProgress.completed": completedExercises.toList()
    });


// 🔥 CALCULATE TOTAL EXERCISES
    int totalExercises =
        (todayWorkout["warmup"] as List).length +
            (todayWorkout["main"] as List).length +
            (todayWorkout["stretching"] as List).length;


// 🔥 CALCULATE PROGRESS
    double progress =
    (completedExercises.length / totalExercises)
        .clamp(0.0, 1.0);


// 🔥 SAVE FOR GRAPH
    await WorkoutStorage.saveWorkoutProgress(progress);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    todayWorkout = widget.workout ??
        WorkoutService.generateTodayWorkout(
          days: widget.days,
          level: widget.level,
          goal: widget.goal,
        );

    _setupProgress();
  }



  Future<void> _setupProgress() async {
    await initializeTodayProgress();
    await loadProgress();
  }

  @override
  Widget build(BuildContext context) {

    // 🛑 Safety check (prevents crashes)
    if (todayWorkout.isEmpty) {
      return Center(
        child: Text(
          "No workout available",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    if (todayWorkout["dayType"] == "Rest") {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hotel, color: Colors.white70, size: 50),
            SizedBox(height: 10),
            Text(
              "Rest Day 😴",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Recovery is part of progress",
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🔥 HEADER


          Text(
            "${widget.goal} - ${todayWorkout["dayType"]} Day",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),


          SizedBox(height: 20),

          // 🔥 Warmup
          _buildSection("Warm Up", todayWorkout["warmup"] ?? []),

          // 🔥 Main Workout
          _buildSection("Workout", todayWorkout["main"] ?? []),

          // 🔥 Stretching
          _buildSection("Stretching", todayWorkout["stretching"] ?? []),
        ],
      ),
    );
  }

  // 🔹 Exercise Tile
  Widget _exerciseTile(Exercise e) {
    bool isChecked = completedExercises.contains(e.name);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // 🔹 Exercise name
          Expanded(
            child: Text(
              e.name,
              style: TextStyle(color: Colors.white),
            ),
          ),

          // 🔹 Sets / duration
          Text(
            e.duration ?? "${e.sets ?? ''} x ${e.reps ?? ''}",
            style: TextStyle(color: Colors.white54),
          ),

          SizedBox(width: 10),

          // 🔥 CHECKBOX
          Checkbox(
            value: isChecked,
            onChanged: (value) {
              updateProgress(e.name, value!);
            },
            activeColor: Color(0xFF6C5CE7),
          ),
        ],
      ),
    );
  }

  // 🔹 Section UI
  Widget _buildSection(String title, List<Exercise> list) {
    if (list.isEmpty) return SizedBox(); // ✅ avoid empty boxes

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 10),

          Column(
            children: list.map((e) {
              return Column(
                children: [
                  _exerciseTile(e),
                  Divider(
                    color: Colors.white24,
                    indent: 10,
                    endIndent: 10,
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
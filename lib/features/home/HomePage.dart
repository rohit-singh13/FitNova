import 'package:fitnova/core/widgets/app_background.dart';
import 'package:fitnova/features/progress/progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import '../../core/utils/quotes.dart';
import 'package:fitnova/services/attendance_service.dart';
import 'package:fitnova/core/widgets/attendance_widget.dart';
import 'package:fitnova/core/widgets/glass_card.dart';
import 'package:fitnova/features/workout/services/workout_services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget{
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String userName = "";
  bool isLoading = true;
  int targetCalories = 0;

  Map<String, dynamic>? generatedWorkout;

  String workoutTitle = "";
  int totalExercises = 0;
  int duration = 0;
  double progress = 0.0;

  Map<String, bool> attendance = {};
  Map<String, String> quote = {};
  String? uid;

  int streak = 0;
  int longestStreak = 0;


  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() {
          userName = "User";
          isLoading = false;
        });
        return;
      }

      var doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final prefs = await SharedPreferences.getInstance();

        String name = doc.data()!["name"] ?? "User";

        await prefs.setString("userName", name);

        setState(() {
          userName = name;
          attendance = Map<String, bool>.from(
              doc.data()!["attendance"] ?? {}
          );

          streak = AttendanceService.calculateStreak(attendance); // current streak
          longestStreak = AttendanceService.calculateLongestStreak(attendance); // best streak

          targetCalories = doc.data()!["targetCalories"] ?? 2000;

          int days = doc.data()!["workoutDays"];
          String level = doc.data()!["experience"];
          String goal = doc.data()!["goal"];

          String normalizedLevel = level.toLowerCase();

          if (normalizedLevel.contains("beginner")) {
            normalizedLevel = "beginner";
          } else if (normalizedLevel.contains("intermediate")) {
            normalizedLevel = "intermediate";
          } else {
            normalizedLevel = "advanced";
          }

          generatedWorkout =
              WorkoutService.generateTodayWorkout(
            days: days,
            level: normalizedLevel,
            goal: goal,
          );

          if (generatedWorkout!["dayType"] == "Rest") {
            workoutTitle = "Rest Day 😴";
            totalExercises = 0;
            duration = 0;
          } else {
            int count =
                (generatedWorkout!["warmup"] as List).length +
                    (generatedWorkout!["main"] as List).length +
                    (generatedWorkout!["stretching"] as List).length;

            workoutTitle = generatedWorkout!["dayType"];
            totalExercises = count;
            duration = count * 5;
          }



          isLoading = false;
        });
      } else {
        setState(() {
          userName = "User";
          isLoading = false;
        });
      }
    } catch (e) {
      print("FETCH ERROR: $e"); // 👈 VERY IMPORTANT
      setState(() {
        userName = "User";
        isLoading = false;
      });
    }
  }
  void _showFocusDialog(String title, List<String> points) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: points.map((point) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                "• $point",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }).toList(),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(color: Color(0xFF6C5CE7)),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString("userName") ?? "User";
    });
  }




  @override
  void initState() {
    super.initState();
    loadLocalData();
    uid = FirebaseAuth.instance.currentUser?.uid;
    fetchUserData().then((_) async{
      if (uid != null) {
        AttendanceService.markTodayAttendance(
          uid: uid!,
          attendance: attendance,
        ).then((_) {
          setState(() {
            streak = AttendanceService.calculateStreak(attendance);
            longestStreak = AttendanceService.calculateLongestStreak(attendance);
          });
        });
      }

    });
    loadQuote();

  }
  void loadQuote() {
    final random = Random();
    setState(() {
      quote = Quotes.all[random.nextInt(Quotes.all.length)];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView( // 👈 IMPORTANT (prevents overflow)
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 20),

                  // 🔹 HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Home",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // 🔹 GREETING
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Text("Good Morning, ${userName.isNotEmpty ? userName : "User"}! 👋", style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                  ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "Let’s crush your goals today.",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildStreakCard(streak, longestStreak),

                  const SizedBox(height: 15,),

                  glassCard(
                    child: AttendanceWidget(attendance: attendance),
                  ),

                  const SizedBox(height: 15),

                  _buildWorkoutProgressCard(),

                  SizedBox(height: 15),

                  _buildFocusCard(),

                  const SizedBox(height: 15),

                  _buildQuoteCard(),

                  SizedBox(height: 12),
                ],

              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildWorkoutCard({
  required String title,
  required int exercises,
  required int duration,
  required double progress,

}) {
    bool isCompleted = progress >= 1.0;
    return glassCard(
      child: Row(
        children: [
          // 🔹 RIGHT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  isCompleted
                      ? "Workout Completed 🎉"
                      : (title.isEmpty ? "Loading..." : "$title Day"),
                  style: TextStyle(fontSize: 21, color: Colors.white),
                ),

                SizedBox(height: 5),

                Text(
                  title == "Rest Day 😴"
                      ? "Recovery & mobility"
                      : "$exercises Exercises • $duration min",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),

                SizedBox(height: 10),

                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation(
                    isCompleted ? Colors.green : Color(0xFF6C5CE7),
                  ),
                ),

                SizedBox(height: 5),

                Text(isCompleted
                ? "100% Completed"
                    : "${(progress * 100).toInt()}% Completed", style: TextStyle(fontSize: 11, color: Colors.white),),

                SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6C5CE7),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: (title == "Rest Day 😴" || isCompleted)
                        ? null
                        : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProgressScreen(
                            targetCalories: targetCalories,
                            generatedWorkout: generatedWorkout!,
                          ),
                      ));
                    },
                    child: Text(isCompleted ? "Completed" : "Start Workout", style: TextStyle(fontSize: 20, color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildQuoteCard() {
    return glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "\"${quote["quote"] ?? ""}\"",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "- ${quote["author"] ?? ""}",
            style: TextStyle(color: Colors.greenAccent.shade400.withOpacity(0.8), fontSize: 13),
          ),
        ],
      ),
    );
  }
  Widget _buildStreakCard(int streak, int longestStreak) {
    return glassCard(
      child: Row(
        children: [
          Icon(Icons.local_fire_department, color: Colors.orange, size: 40),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$streak Day Streak",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 2),
              Text(
                "Best: $longestStreak days",
                style: TextStyle(color: Colors.white60),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFocusCard() {
    return glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Focus",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: _focusTile(
                  icon: Icons.fitness_center,
                  title: "Workout",
                  color: Colors.redAccent, // 🔥 energetic
                  description: [
                    "Complete your planned workout today",
                    "Focus on form and consistency"
                  ],
                ),
              ),
              SizedBox(width: 10),

              Expanded(
                child: _focusTile(
                  icon: Icons.water_drop,
                  title: "Hydration",
                  color: Colors.blue, // 💧 perfect
                  description: [
                    "Drink enough water throughout the day",
                    "Stay hydrated for better performance"
                  ],
                ),
              ),
              SizedBox(width: 10),

              Expanded(
                child: _focusTile(
                  icon: Icons.self_improvement,
                  title: "Consistency",
                  color: Colors.orange, // ⚡ discipline vibe
                  description: [
                    "Show up even if motivation is low",
                    "Small actions daily build long-term results"
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
  Widget _focusTile({
    required IconData icon,
    required String title,
    required Color color,
    required List<String> description,
  }) {
    return GestureDetector(
      onTap: () => _showFocusDialog(title, description),

      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05), // clean (no glow)
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildWorkoutProgressCard() {

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return SizedBox();

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .snapshots(),

      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return glassCard(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;

        if (data == null) {
          return glassCard(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          );
        }

        final progressData = data["todayWorkoutProgress"];

        if (workoutTitle == "Rest Day 😴") {
          return _buildWorkoutCard(
            title: workoutTitle,
            exercises: 0,
            duration: 0,
            progress: 0,
          );
        }

// 🔥 TODAY DATE
        final now = DateTime.now();

        final today =
            "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

// 🔥 CHECK IF PROGRESS BELONGS TO TODAY
        bool isToday = progressData?["date"] == today;

// 🔥 ONLY USE TODAY'S COMPLETED DATA
        Set completed = isToday
            ? Set.from(progressData?["completed"] ?? [])
            : {};


        int done = completed.length;

        double percent =
        totalExercises == 0 ? 0 : done / totalExercises;

        return _buildWorkoutCard(
          title: workoutTitle,
          exercises: totalExercises,
          duration: duration,
          progress: percent,
        );
      },
    );
  }


}
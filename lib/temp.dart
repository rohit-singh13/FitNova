import 'package:fitnova/app_background.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "Alex";
  //workout variables
  String workoutTitle = "Upper Body";
  int totalExercises = 6;
  int duration = 45;
  double progress = 0.0;
  //nutrition variables
  int caloriesConsumed = 1650;
  int calorieGoal = 2200;

  int protein = 120;
  int proteinGoal = 150;

  int carbs = 180;
  int carbsGoal = 250;

  int fats = 50;
  int fatsGoal = 70;
  //streak variable
  int streakDays = 7;
  //water intake variable
  double waterLiters = 1.5;
  //meals tracking variable
  int mealsLogged = 2;
  int mealsGoal = 3;
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
                      Stack(
                        children: [
                          Icon(Icons.notifications_none, color: Colors.white, size: 28),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "3",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 15),

                  // 🔹 GREETING
                  Text(
                    "Good Morning, $userName! 👋",
                    style: TextStyle(
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

                  const SizedBox(height: 25),

                  // 🔹 Section Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Workout",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "View all",
                        style: TextStyle(
                          color: Color(0xFF6C5CE7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 🔹 Workout Card
                  _buildWorkoutCard(
                    title: workoutTitle,
                    exercises: totalExercises,
                    duration: duration,
                    progress: progress,
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Nutrition Card
                  _buildNutritionCard(),

                  const SizedBox(height: 20),

                  // 🔹 Stats Row
                  _buildStatsRow(),

                  const SizedBox(height: 100),
                ],

              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }
  Widget _buildWorkoutCard({
    required String title,
    required int exercises,
    required int duration,
    required double progress,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [

          // 🔹 LEFT IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              "Assets/Images/workout.png",
              height: 150,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: 15),

          // 🔹 RIGHT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(title, style: TextStyle(fontSize: 21, color: Colors.white),),

                SizedBox(height: 5),

                Text("$exercises Exercises • $duration min", style: TextStyle(fontSize: 15, color: Colors.white),),

                SizedBox(height: 10),

                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation(Color(0xFF6C5CE7)),
                ),

                SizedBox(height: 5),

                Text("${(progress * 100).toInt()}% Completed", style: TextStyle(fontSize: 11, color: Colors.white),),

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
                    onPressed: () {},
                    child: Text("Start Workout", style: TextStyle(fontSize: 20, color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildBottomNav() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border(
          top: BorderSide(color: Colors.white10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home, "Home", true),
          _navItem(Icons.bar_chart, "Progress", false),
          _navItem(Icons.person_outline, "Profile", false),
        ],
      ),
    );
  }

  Widget _buildNutritionCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🔹 Title
          Text(
            "Daily Nutrition",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 15),

          Row(
            children: [

              // 🔥 Calories Circle (Simple version)
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFF6C5CE7),
                    width: 6,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$caloriesConsumed",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "kcal",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 20),

              // 🔹 Macros
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _macroRow("Protein", protein, proteinGoal, Colors.blue),
                    SizedBox(height: 6),

                    _macroRow("Carbs", carbs, carbsGoal, Colors.orange),
                    SizedBox(height: 6),

                    _macroRow("Fats", fats, fatsGoal, Colors.pink),
                  ],
                ),
              )
            ],
          ),

          SizedBox(height: 15),

          // 🔹 Log Meal Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white30),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: Text(
                "Log a Meal",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _macroRow(String name, int value, int goal, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(color: Colors.white70),
        ),
        Text(
          "$value / $goal g",
          style: TextStyle(color: color),
        ),
      ],
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? Color(0xFF6C5CE7) : Colors.white54,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Color(0xFF6C5CE7) : Colors.white54,
            fontSize: 12,
          ),
        )
      ],
    );
  }
  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statCard(
          icon: Icons.local_fire_department,
          value: "$streakDays",
          label: "Day Streak",
        ),
        _statCard(
          icon: Icons.water_drop,
          value: "$waterLiters L",
          label: "Water",
        ),
        _statCard(
          icon: Icons.check_circle,
          value: "$mealsLogged / $mealsGoal",
          label: "Meals",
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Icon(icon, color: Color(0xFF6C5CE7), size: 28),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
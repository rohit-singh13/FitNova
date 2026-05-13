import 'package:flutter/material.dart';
import '../../core/widgets/app_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnova/features/profile/edit_profile.dart';
import 'package:fitnova/core/utils/calorie_calculator.dart';
import 'package:fitnova/features/ai/ai_report_screen.dart';
import 'package:fitnova/features/auth/screens/tempinitscreen.dart';

class ProfileScreen extends StatefulWidget {
  final Function(int) onCaloriesCalculated;

  const ProfileScreen({required this.onCaloriesCalculated});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String name = "";
  String email = "";
  String selectedAvatar = "Assets/Avatars/avatar1.png";

  double weight = 0;
  int height = 0;

  String goal = "";
  String experience = "";
  int? bodyFat;

  int age = 0;
  String gender = "male";
  String activityLevel = "low";

  double calories = 0;
  int protein = 0;
  int carbs = 0;
  int fats = 0;

  bool notificationsEnabled = true;
  String unitSystem = "Metric";



  bool isLoading = true;

  double getTargetWeight() {    //Calculates target weight based on user's goal and BMI range
    if (height == 0 || weight == 0) return weight;

    if (goal.toLowerCase().contains("loss")) {
      return 22 * ((height / 100) * (height / 100));
    } else if (goal.toLowerCase().contains("gain")) {
      return 24 * ((height / 100) * (height / 100));
    } else {
      return weight;
    }
  }


  Future<void> fetchUserData() async {    //Fetches user profile data from Firestore and calculate nutrition targets
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() => isLoading = false);
        return;
      }

      var doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        var data = doc.data()!;

        setState(() {
          name = data["name"] ?? "User";
          email = data["email"] ?? "";
          selectedAvatar =
              data["avatar"] ?? "Assets/Avatars/avatar1.png";

          age = data["age"] ?? 0;
          String rawGender = (data["gender"] ?? "male").toLowerCase();

          if (rawGender == "others") {
            gender = "female";
          } else {
            gender = rawGender;
          }

          height = data["height"] ?? 0;
          weight = (data["weight"] ?? 0).toDouble();

          goal = data["goal"] ?? "";
          experience = data["experience"] ?? "";

          if (experience.contains("Beginner")) {
            activityLevel = "low";
          } else if (experience.contains("Intermediate")) {
            activityLevel = "medium";
          } else {
            activityLevel = "high";
          }

          bodyFat = data["bodyFat"] != null ? data["bodyFat"] as int : null;

          isLoading = false;
        });

        double bmr = (height > 0 && weight > 0 && age > 0)
            ? CalorieCalculator.calculateBMR(
          gender: gender,
          weight: weight.toInt(),
          height: height,
          age: age,
        )
            : 0;

        double tdee = CalorieCalculator.calculateTDEE(bmr, activityLevel);
        double calculatedCalories = CalorieCalculator.adjustCalories(tdee, goal);

        widget.onCaloriesCalculated(calculatedCalories.toInt());    //Sends calculated calories to parent navigation screen
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("PROFILE ERROR: $e");
      setState(() => isLoading = false);
    }
  }
  Future<void> logoutUser() async {   //Shows logout confirmation dialog and signs out user
    bool? confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => TempInitScreen()),
            (route) => false,
      );
    }
  }

  Future<void> openAvatarPicker() async {   // Opens avatar selection bottom sheet and saves selected avatar
    List<String> avatars = [
      "Assets/Avatars/avatar1.png",
      "Assets/Avatars/avatar2.png",
      "Assets/Avatars/avatar3.png",
      "Assets/Avatars/avatar4.png",
      "Assets/Avatars/avatar5.png",
      "Assets/Avatars/avatar6.png",
      "Assets/Avatars/avatar7.png",
      "Assets/Avatars/avatar8.png",
      "Assets/Avatars/avatar9.png",
      "Assets/Avatars/avatar10.png",
      "Assets/Avatars/avatar11.png",
      "Assets/Avatars/avatar12.png",
      "Assets/Avatars/avatar13.png",
    ];

    String? selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Color(0xFF1C1C1E),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: avatars.length,
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (_, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context, avatars[index]);
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(avatars[index]),
                ),
              );
            },
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        selectedAvatar = selected;
      });

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update({
          "avatar": selected,
        });
      }
    }
  }

  @override   //Loads profile data when screen starts
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    double bmi = height > 0
        ? weight / ((height / 100) * (height / 100))
        : 0;
    double bmr = (height > 0 && weight > 0 && age > 0)
        ? CalorieCalculator.calculateBMR(
      gender: gender,
      weight: weight.toInt(),
      height: height,
      age: age,
    )
        : 0;

    double tdee = CalorieCalculator.calculateTDEE(bmr, activityLevel);

    calories = CalorieCalculator.adjustCalories(tdee, goal);


    var macros = CalorieCalculator.calculateMacros(calories, weight.toInt());

    protein = macros["protein"] ?? 0;
    carbs = macros["carbs"] ?? 0;
    fats = macros["fats"] ?? 0;
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),

                SizedBox(height: 20),

                _glassCard(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: openAvatarPicker,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(selectedAvatar),
                        ),
                      ),

                      SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(height: 4),
                            Text(email,
                                style: TextStyle(color: Colors.white60)),
                            SizedBox(height: 10),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF6C5CE7).withValues(alpha: 0.85),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => EditProfileScreen()),
                                );

                                await fetchUserData();
                              },
                              child: Text("Edit Profile", style: TextStyle(color: Colors.white),),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 20),

                _sectionTitle("My Goals", ""),
                SizedBox(height: 10),

                _glassCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _goalItem(Icons.flag, "Goal", goal),
                      _goalItem(Icons.fitness_center, "Level", experience),
                      _goalItem(
                        Icons.track_changes,
                        "Target",
                        "${getTargetWeight().toStringAsFixed(1)} kg",
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                _sectionTitle("Body Stats", ""),

                SizedBox(height: 10),

                _glassCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statItem("$weight", "kg", "Weight"),
                      _statItem("$height", "cm", "Height"),
                      _statItem(bmi.toStringAsFixed(1), "", "BMI"),
                      _statItem(
                        bodyFat != null ? "$bodyFat %" : "--",
                        "",
                        "Body Fat",
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10,),

                _glassCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "AI Health Risk Analysis",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2C2C2E),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          double bmi = height > 0
                              ? weight / ((height / 100) * (height / 100))
                              : 0;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AIReportScreen(
                                age: age,
                                height: height,
                                weight: weight,
                                bodyFat: bodyFat,
                                bmi: bmi,
                                goal: goal,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "View AI Report",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                _buildNutritionCard(),

                SizedBox(height: 20),

                _sectionTitle("App Settings", ""),
                SizedBox(height: 10),

                _glassCard(
                  child: Column(
                    children: [
                      _settingsRow("Notifications", notificationsEnabled ? "On" : "Off", onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Notifications"),
                            content: Text("Turn notifications on or off"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  setState(() => notificationsEnabled = false);
                                  Navigator.pop(context);
                                },
                                child: Text("Off"),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() => notificationsEnabled = true);
                                  Navigator.pop(context);
                                },
                                child: Text("On"),
                              ),
                            ],
                          ),
                        );
                      }),
                      Divider(color: Colors.white12, thickness: 0.5),
                      _settingsRow(unitSystem, "", onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Units"),
                            content: Text("Choose unit system"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  setState(() => unitSystem = "Metric");
                                  Navigator.pop(context);
                                },
                                child: Text("Metric (kg, cm)"),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() => unitSystem = "Imperial");
                                  Navigator.pop(context);
                                },
                                child: Text("Imperial (lbs, ft)"),
                              ),
                            ],
                          ),
                        );
                      }),
                      Divider(color: Colors.white12, thickness: 0.5),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text("Logout", style: TextStyle(color: Colors.redAccent)),
                        trailing: Icon(Icons.logout, color: Colors.redAccent),
                        onTap: logoutUser,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _glassCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _sectionTitle(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        if (action.isNotEmpty)
          Text(action, style: TextStyle(color: Color(0xFF6C5CE7))),
      ],
    );
  }

  Widget _goalItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFF6C5CE7)),
        SizedBox(height: 6),
        Text(label, style: TextStyle(color: Colors.white60, fontSize: 12)),
        SizedBox(height: 4),
        Text(value, style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _statItem(String value, String unit, String label) {
    return Column(
      children: [
        Text(
          "$value $unit",
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white60, fontSize: 12)),
      ],
    );
  }

  Widget _settingsRow(String title, String value, {VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: TextStyle(color: Colors.white)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value.isNotEmpty)
            Text(value, style: TextStyle(color: Colors.white60)),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white54),
        ],
      ),
      onTap: onTap,
    );
  }
  Widget _buildNutritionCard() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "Daily Nutrition Target",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 15),

          Row(
            children: [
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white24,
                      width: 2,
                    ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        calories > 0 ? "${calories.toInt()}" : "--",
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

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _macroRow("Protein", protein),
                    SizedBox(height: 6),
                    _macroRow("Carbs", carbs),
                    SizedBox(height: 6),
                    _macroRow("Fats", fats),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _macroRow(String name, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: TextStyle(color: Colors.white70)),
        Text("$value g", style: TextStyle(color: Color(0xFF6C5CE7))),
      ],
    );
  }

}
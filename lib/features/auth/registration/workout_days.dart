import 'package:fitnova/features/auth/registration/Experiencelvl.dart';
import 'package:fitnova/core/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:fitnova/data/user_data.dart';

class WorkoutDays extends StatefulWidget {
  final UserData userData;

  const WorkoutDays({super.key, required this.userData});

  @override
  State<WorkoutDays> createState() => _WorkoutDaysState();
}

class _WorkoutDaysState extends State<WorkoutDays> {
  int selectedIndex = -1;

  List<String> workoutdayslabels = [
    "2-3 days",
    "4-5 days",
    "6 days",
  ];

  List<int> workoutdaysvalues = [
    3,
    5,
    6,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: Colors.red),
                    ),
                    Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: LinearProgressIndicator(
                          value: 0.5,
                          backgroundColor: Colors.red,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  SizedBox(height: 20),

                  Text(
                    "How many days do you workout per week?",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 30),

                  ...List.generate(workoutdayslabels.length, (index) {
                    bool isSelected = selectedIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.red.withValues(alpha: 0.3)
                              : Color(0xFF1E1E2E),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isSelected ? Colors.red : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          workoutdayslabels[index],
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    );
                  }),

                  SizedBox(height: 100),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedIndex == -1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please select workout days")),
                      );
                      return;
                    }

                    widget.userData.workoutDays = workoutdaysvalues[selectedIndex];

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Experiencelvl(userData: widget.userData),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6C5CE7),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
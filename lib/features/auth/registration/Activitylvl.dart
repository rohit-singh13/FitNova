import 'package:fitnova/core/widgets/app_background.dart';
import 'package:fitnova/features/auth/registration/workout_days.dart';
import 'package:flutter/material.dart';
import 'package:fitnova/data/user_data.dart';

class Activitylvl extends StatefulWidget{
  final UserData userData;

  Activitylvl({required this.userData});
  @override
  State<Activitylvl> createState() => _ActivitylvlState();
}

class _ActivitylvlState extends State<Activitylvl>{


  int selectedIndex = -1;   //Stores index of the currently fitness goal selected by the user

  List<String> goals = [
    "Lift heavier",
    "Build muscle",
    "Weight Gain",
    "Weight Loss",
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Stack(
          children: [


            Column(
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
                              value: 0.4,
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
                        "What is your top fitness goal?",
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 30),

                      ...List.generate(goals.length, (index) {
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
                              goals[index],
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
                            SnackBar(content: Text("Please select a goal")),
                          );
                          return;
                        }

                        widget.userData.goal = goals[selectedIndex];

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkoutDays(userData: widget.userData),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6C5CE7),
                      ),
                      child: Text('Next', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
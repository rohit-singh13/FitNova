import 'package:fitnova/app_background.dart';
import 'package:fitnova/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitnova/user_data.dart';

class Experiencelvl extends StatefulWidget{
  final UserData userData;

  Experiencelvl({required this.userData});
  @override
  State<Experiencelvl> createState() => _ExperiencelvlState();
}

class _ExperiencelvlState extends State<Experiencelvl>{



  int selectedIndex = -1;

  List<String> goals = [
    "Beginner (0-1 year)",
    "Intermediate (1-3 years)",
    "Advance (3+ years)",
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
                              value: 0.60,
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
                        "What is your Experience Level?",
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
                                  ? Colors.red.withOpacity(0.3)
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
                            SnackBar(content: Text("Please select your experience level")),
                          );
                          return;
                        }

                        widget.userData.experience = goals[selectedIndex];

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => signup(userData: widget.userData),
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
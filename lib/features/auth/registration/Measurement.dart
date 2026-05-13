import 'package:fitnova/features/auth/registration/Activitylvl.dart';
import 'package:fitnova/core/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:fitnova/data/user_data.dart';

class Measurement extends StatefulWidget {
  const Measurement({super.key});
  @override
  State<Measurement> createState() => _MeasurementState();
}

class _MeasurementState extends State<Measurement> {
  UserData userData = UserData();   //Stores user onboarding data across registration screens

  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController fatController = TextEditingController();

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
                              value: 0.2,
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
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),

                        Text('What is your height?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                        SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: heightController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white),
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                  child: Text(
                                    'cm',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ),
                              suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        Text('What is your Weight?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                        SizedBox(height: 10),

                        TextField(
                          keyboardType: TextInputType.number,
                          controller: weightController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 12),

                                child: Text(
                                  'kg',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                            ),
                            suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                          ),
                        ),

                        SizedBox(height: 20),

                        //Optional field used for more advanced health analysis and can be update later
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'What is your Body fat%? ',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: '(optional)',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: fatController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(


                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white),
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Text(
                                  '%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                            ),
                          ),
                        ),

                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (heightController.text.isEmpty || weightController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please enter height and weight")),
                          );
                          return;
                        }

                        int? fat = int.tryParse(fatController.text);

                        if (fatController.text.isNotEmpty && fat == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Enter a valid number for body fat")),
                          );
                          return;
                        }

                        if (fat != null && (fat < 1 || fat > 60)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Enter valid body fat % (1–60)")),
                          );
                          return;
                        }

                        userData.height = int.tryParse(heightController.text);
                        userData.weight = int.tryParse(weightController.text);
                        userData.bodyFat = fat;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Activitylvl(userData: userData),
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
            )

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    fatController.dispose();
    super.dispose();
  }
}

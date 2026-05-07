import 'package:flutter/material.dart';
import 'app_background.dart';
import 'health_risk_calculator.dart';

class AIReportScreen extends StatelessWidget {
  final int age;
  final int height;
  final double weight;
  final int? bodyFat;
  final double bmi;
  final String goal;

  const AIReportScreen({
    super.key,
    required this.age,
    required this.height,
    required this.weight,
    this.bodyFat,
    required this.bmi,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    var ai = HealthRiskEngine.analyze(
      age: age,
      bmi: bmi,
      bodyFat: bodyFat,
      goal: goal,
    );

    String bmiRange;
    if (bmi < 18.5) {
      bmiRange = "Underweight";
    } else if (bmi < 25) {
      bmiRange = "Normal";
    } else if (bmi < 30) {
      bmiRange = "Overweight";
    } else {
      bmiRange = "Obese";
    }

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                /// 🔹 LOGO
                SizedBox(height: 10),
                Image.asset(
                  "Assets/Images/328a5979-cb64-46de-b0c2-4bb12f960cd2-Photoroom.png", // change if needed
                  height: 120,
                ),

                SizedBox(height: 10),

                /// 🔹 TITLE
                Text(
                  "Our AI Report",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20),

                /// 🔹 USER STATS CARD
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text("Your Stats",
                          style: _titleStyle()),

                      SizedBox(height: 10),

                      _row("Height", "$height cm"),
                      _row("Weight", "$weight kg"),
                      _row("Body Fat", bodyFat != null ? "$bodyFat %" : "--"),
                      _row("BMI", bmi.toStringAsFixed(1)),
                      _row("BMI Range", bmiRange),
                    ],
                  ),
                ),

                SizedBox(height: 15),

                /// 🔹 AI ANALYSIS
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text("AI Health Analysis",
                          style: _titleStyle()),

                      SizedBox(height: 10),

                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: getRiskColor(ai["risk"].toString()).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: getRiskColor(ai["risk"].toString())),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              getRiskIcon(ai["risk"].toString()),
                              color: getRiskColor(ai["risk"].toString()),
                              size: 28,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ai["risk"],
                                    style: TextStyle(
                                      color: getRiskColor(ai["risk"].toString()),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    ai["status"],
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),

                      Text("Insights", style: _subtitleStyle()),

                      SizedBox(height: 5),

                      ...(ai["insights"] as List).map((insight) {
                        IconData icon;

                        if (insight.toString().toLowerCase().contains("risk")) {
                          icon = Icons.warning; // ⚠️
                        } else if (insight.toString().toLowerCase().contains("good") ||
                            insight.toString().toLowerCase().contains("balanced")) {
                          icon = Icons.local_fire_department; // 🔥
                        } else {
                          icon = Icons.fitness_center; // 💪
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Icon(icon, color: Color(0xFF6C5CE7), size: 20),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  insight,
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      SizedBox(height: 10),

                      Text("AI Suggestion", style: _subtitleStyle()),

                      SizedBox(height: 5),

                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF6C5CE7).withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.psychology, color: Color(0xFF6C5CE7)),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                ai["suggestion"],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Spacer(),

                /// 🔹 CTA BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6C5CE7),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // go back to Home/Profile
                    },
                    child: Text(
                      "Let's Grind 💪",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
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

  /// 🔹 UI helpers

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            Color(0xFF6C5CE7).withOpacity(0.2),
            Colors.transparent,
          ],
        ),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white60)),
          Text(value, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  TextStyle _titleStyle() => TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  TextStyle _subtitleStyle() => TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  Color getRiskColor(String risk) {
    switch (risk) {
      case "Low Risk":
        return Colors.green;
      case "Moderate Risk":
        return Colors.orange;
      case "High Risk":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getRiskIcon(String risk) {
    switch (risk) {
      case "Low Risk":
        return Icons.check_circle;
      case "Moderate Risk":
        return Icons.warning;
      case "High Risk":
        return Icons.error;
      default:
        return Icons.info;
    }
  }
}
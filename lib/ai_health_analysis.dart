import 'package:flutter/material.dart';
import 'app_background.dart';
import 'health_risk_calculator.dart';

class AIAnalysisScreen extends StatelessWidget {
  final int age;
  final double bmi;
  final int? bodyFat;
  final String goal;

  const AIAnalysisScreen({
    super.key,
    required this.age,
    required this.bmi,
    this.bodyFat,
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

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text("AI Health Report",
                    style: TextStyle(color: Colors.white, fontSize: 26)),

                SizedBox(height: 20),

                Text("Risk Level: ${ai["risk"]}",
                    style: TextStyle(color: Colors.greenAccent, fontSize: 18)),

                SizedBox(height: 10),

                Text("Status: ${ai["status"]}",
                    style: TextStyle(color: Colors.white70)),

                SizedBox(height: 20),

                Text("Insights",
                    style: TextStyle(color: Colors.white, fontSize: 18)),

                ...List.generate(
                  (ai["insights"] as List).length,
                      (i) => Text("• ${ai["insights"][i]}",
                      style: TextStyle(color: Colors.white60)),
                ),

                SizedBox(height: 20),

                Text("AI Suggestion",
                    style: TextStyle(color: Colors.white, fontSize: 18)),

                Text(ai["suggestion"],
                    style: TextStyle(color: Colors.white60)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class HealthRiskEngine {
  static Map<String, dynamic> analyze({
    required int age,
    required double bmi,
    required int? bodyFat,
    required String goal,
  }) {
    String risk = "Low Risk ✅";
    String status = "You are in a healthy BMI range";

    List<String> insights = [];
    String suggestion = "";

    // 🔹 BMI Logic
    if (bmi >= 30) {
      risk = "High Risk ❗";
      status = "Obesity range";

      insights = [
        "High BMI indicates obesity",
        "Increased risk of heart disease",
        "Possible metabolic issues",
      ];

      suggestion =
      "Start a calorie deficit diet, increase physical activity, and consult a healthcare professional.";
    } else if (bmi >= 25) {
      risk = "Moderate Risk ⚠️";
      status = "Overweight range";

      insights = [
        "BMI is above normal range",
        "Risk of future weight-related issues",
        "Improvement recommended",
      ];

      suggestion =
      "Focus on fat loss through diet and cardio training.";
    } else if (bmi < 18.5) {
      risk = "Moderate Risk ⚠️";
      status = "Underweight";

      insights = [
        "Low body weight detected",
        "Possible nutrient deficiency",
        "Low muscle mass",
      ];

      suggestion =
      "Increase calorie intake and focus on strength training.";
    } else {
      // 🔥 PERFECT CASE (your example)
      insights = [
        "Your weight is well balanced for your height",
        "No immediate health risks detected",
        "Good metabolic profile for your age",
      ];

      // 🎯 Goal-based AI
      if (goal.contains("Muscle")) {
        suggestion =
        "Great base! Increase protein intake and start strength training for muscle gain.";
      } else if (goal.contains("Fat")) {
        suggestion =
        "You're already in a good range. Focus on maintaining weight and improving definition.";
      } else {
        suggestion =
        "Maintain your current lifestyle. Focus on balanced nutrition and regular exercise.";
      }
    }

    return {
      "risk": risk,
      "status": status,
      "insights": insights,
      "suggestion": suggestion,
    };
  }
}
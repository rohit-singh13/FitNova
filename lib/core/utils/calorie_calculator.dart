// Used Mifflin-St Jeor Equation top calculate the Required calories and Macros

class CalorieCalculator {

  static double calculateBMR({
    required String gender,
    required int weight,
    required int height,
    required int age,
  }) {
    if (gender == "male") {
      return (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      return (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }
  }

  static double calculateTDEE(double bmr, String activityLevel) {
    switch (activityLevel) {
      case "low":
        return bmr * 1.2;
      case "medium":
        return bmr * 1.55;
      case "high":
        return bmr * 1.725;
      default:
        return bmr * 1.2;
    }
  }

  static double adjustCalories(double tdee, String goal) {
    switch (goal) {
      case "lose":
        return tdee - 500;
      case "gain":
        return tdee + 300;
      default:
        return tdee;
    }
  }

  static Map<String, int> calculateMacros(double calories, int weight) {
    int protein = weight * 2;
    int fats = (calories * 0.25 ~/ 9);
    int remainingCalories = calories.toInt() - (protein * 4) - (fats * 9);
    int carbs = remainingCalories ~/ 4;

    return {
      "protein": protein,
      "fats": fats,
      "carbs": carbs,
    };
  }
}
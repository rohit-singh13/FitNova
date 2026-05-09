import 'package:fitnova/data/workout_database.dart';

class WorkoutService {

  static List<Exercise> getWarmups() {
    return exercises.where((e) => e.type == "warmup").toList();
  }

  static List<Exercise> getStretching() {
    return exercises.where((e) => e.type == "stretching").toList();
  }

  static Exercise? findExercise(String name) {
    try {
      return exercises.firstWhere((e) => e.name == name);
    } catch (e) {
      return null;
    }
  }

  //FULL BODY

  static List<Exercise> fullBodyA() {
    return [
      findExercise("Bench Press")!,
      findExercise("Barbell Row")!,
      findExercise("Barbell Squat")!,
      findExercise("Overhead Press")!,
      findExercise("Barbell Curl")!,
      findExercise("Tricep Pushdown")!,
    ];
  }

  static List<Exercise> fullBodyB() {
    return [
      findExercise("Incline Dumbbell Press")!,
      findExercise("Lat Pulldown")!,
      findExercise("Leg Press")!,
      findExercise("Arnold Press")!,
      findExercise("Hammer Curl")!,
      findExercise("Skull Crushers")!,
    ];
  }

  static List<Exercise> fullBodyC() {
    return [
      findExercise("Machine Chest Press")!,
      findExercise("T-Bar Row")!,
      findExercise("Romanian Deadlift")!,
      findExercise("Lateral Raise")!,
      findExercise("EZ Bar Curl")!,
      findExercise("Close Grip Bench Press")!,
    ];
  }

  //UPPER LOWER

  static List<Exercise> upperA() {
    return [
      findExercise("Bench Press")!,
      findExercise("Pull-Up")!,
      findExercise("Overhead Press")!,
      findExercise("Barbell Curl")!,
      findExercise("Tricep Pushdown")!,
    ];
  }

  static List<Exercise> lowerA() {
    return [
      findExercise("Barbell Squat")!,
      findExercise("Romanian Deadlift")!,
      findExercise("Walking Lunges")!,
      findExercise("Standing Calf Raise")!,
      findExercise("Crunches")!,
    ];
  }

  static List<Exercise> upperB() {
    return [
      findExercise("Incline Dumbbell Press")!,
      findExercise("Barbell Row")!,
      findExercise("Arnold Press")!,
      findExercise("Hammer Curl")!,
      findExercise("Skull Crushers")!,
    ];
  }

  static List<Exercise> lowerB() {
    return [
      findExercise("Hack Squat")!,
      findExercise("Leg Press")!,
      findExercise("Leg Curl")!,
      findExercise("Seated Calf Raise")!,
      findExercise("Plank")!,
    ];
  }

  //PPL

  static List<Exercise> pushA() {
    return [
      findExercise("Bench Press")!,
      findExercise("Incline Dumbbell Press")!,
      findExercise("Overhead Press")!,
      findExercise("Lateral Raise")!,
      findExercise("Tricep Pushdown")!,
      findExercise("Skull Crushers")!,
    ];
  }

  static List<Exercise> pullA() {
    return [
      findExercise("Deadlift")!,
      findExercise("Pull-Up")!,
      findExercise("Barbell Row")!,
      findExercise("Barbell Curl")!,
      findExercise("Hammer Curl")!,
      findExercise("Barbell Shrug")!,
    ];
  }

  static List<Exercise> legsA() {
    return [
      findExercise("Barbell Squat")!,
      findExercise("Romanian Deadlift")!,
      findExercise("Leg Press")!,
      findExercise("Walking Lunges")!,
      findExercise("Crunches")!,
      findExercise("Leg Raises")!,
    ];
  }

  static List<Exercise> pushB() {
    return [
      findExercise("Decline Bench Press")!,
      findExercise("Cable Crossover")!,
      findExercise("Arnold Press")!,
      findExercise("Front Raise")!,
      findExercise("Close Grip Bench Press")!,
      findExercise("Rope Pushdown")!,
    ];
  }

  static List<Exercise> pullB() {
    return [
      findExercise("Lat Pulldown")!,
      findExercise("T-Bar Row")!,
      findExercise("Face Pull")!,
      findExercise("EZ Bar Curl")!,
      findExercise("Concentration Curl")!,
      findExercise("Farmer’s Walk")!,
    ];
  }

  static List<Exercise> legsB() {
    return [
      findExercise("Hack Squat")!,
      findExercise("Bulgarian Split Squat")!,
      findExercise("Leg Curl")!,
      findExercise("Standing Calf Raise")!,
      findExercise("Plank")!,
      findExercise("Russian Twist")!,
    ];
  }

  //TODAY WORKOUT

  static Map<String, dynamic> generateTodayWorkout({
    required int days,
    required String level,
    required String goal,
  }) {

    int weekday = DateTime.now().weekday;

    String dayType;
    List<Exercise> mainWorkout = [];

    //FULL BODY

    if (days <= 3) {

      List<String> split = [
        "Full Body A",
        "Rest",
        "Full Body B",
        "Rest",
        "Full Body C",
        "Rest",
        "Rest",
      ];

      dayType = split[weekday - 1];

      if (dayType == "Full Body A") {
        mainWorkout = fullBodyA();
      }

      else if (dayType == "Full Body B") {
        mainWorkout = fullBodyB();
      }

      else if (dayType == "Full Body C") {
        mainWorkout = fullBodyC();
      }
    }

    //UPPER LOWER

    else if (days <= 5) {

      List<String> split = [
        "Upper A",
        "Lower A",
        "Rest",
        "Upper B",
        "Lower B",
        "Rest",
        "Rest",
      ];

      dayType = split[weekday - 1];

      if (dayType == "Upper A") {
        mainWorkout = upperA();
      }

      else if (dayType == "Lower A") {
        mainWorkout = lowerA();
      }

      else if (dayType == "Upper B") {
        mainWorkout = upperB();
      }

      else if (dayType == "Lower B") {
        mainWorkout = lowerB();
      }
    }

    //PPL

    else {

      List<String> split = [
        "Push A",
        "Pull A",
        "Legs A",
        "Push B",
        "Pull B",
        "Legs B",
        "Rest",
      ];

      dayType = split[weekday - 1];

      if (dayType == "Push A") {
        mainWorkout = pushA();
      }

      else if (dayType == "Pull A") {
        mainWorkout = pullA();
      }

      else if (dayType == "Legs A") {
        mainWorkout = legsA();
      }

      else if (dayType == "Push B") {
        mainWorkout = pushB();
      }

      else if (dayType == "Pull B") {
        mainWorkout = pullB();
      }

      else if (dayType == "Legs B") {
        mainWorkout = legsB();
      }
    }

    //REST DAY

    if (dayType.contains("Rest")) {
      return {
        "dayType": "Rest",
        "warmup": [],
        "main": [],
        "stretching": [],
      };
    }

    //FINAL RETURN

    return {
      "dayType": dayType,
      "warmup": getWarmups().take(4).toList(),
      "main": mainWorkout,
      "stretching": getStretching().take(4).toList(),
    };
  }
}
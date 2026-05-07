import 'package:fitnova/data/workout_database.dart';

//Service class responsible for generating workout plans and exercise splits
class WorkoutService {


  static List<Exercise> getWarmups() {
    return exercises.where((e) => e.type == "warmup").toList();
  }


  static List<Exercise> getStretching() {
    return exercises.where((e) => e.type == "stretching").toList();
  }


  static List<Exercise> getByMuscle(String muscle, String level) {
    return exercises
        .where((e) => e.muscle == muscle && e.difficulty == level)
        .toList();
  }


  static List<Exercise> getByLevel(String level) {
    return exercises.where((e) => e.difficulty == level).toList();
  }

  //Randomly selects exercises from a list
  static List<Exercise> pickExercises(List<Exercise> list, int count) {
    list.shuffle();
    return list.length >= count ? list.take(count).toList() : list;
  }

  //Generates a full body workout split
  static List<List<Exercise>> fullBody(String level) {
    return [
      [
        ...pickExercises(getByMuscle("chest", level), 1),
        ...pickExercises(getByMuscle("back", level), 1),
        ...pickExercises(getByMuscle("legs", level), 1),
        ...pickExercises(getByMuscle("shoulders", level), 1),
        ...pickExercises(getByMuscle("biceps", level), 1),
        ...pickExercises(getByMuscle("triceps", level), 1),
        ...pickExercises(getByMuscle("traps", level), 1),
        ...pickExercises(getByMuscle("forearms", level), 1),
      ]
    ];
  }

  //Generates an upper-lower workout split
  static List<List<Exercise>> upperLower(String level) {
    return [

      [
        ...pickExercises(getByMuscle("chest", level), 2),
        ...pickExercises(getByMuscle("back", level), 2),
        ...pickExercises(getByMuscle("shoulders", level), 1),
        ...pickExercises(getByMuscle("biceps", level), 1),
        ...pickExercises(getByMuscle("triceps", level), 1),
        ...pickExercises(getByMuscle("traps", level), 1),
      ],


      [
        ...pickExercises(getByMuscle("legs", level), 3),
        ...pickExercises(getByMuscle("abs", level), 2),
        ...pickExercises(getByMuscle("forearms", level), 1),
      ]
    ];
  }

  //Generates a push-pull-legs workout split
  static List<List<Exercise>> ppl(String level) {
    return [

      [
        ...pickExercises(getByMuscle("chest", level), 2),
        ...pickExercises(getByMuscle("shoulders", level), 2),
        ...pickExercises(getByMuscle("triceps", level), 2),
      ],


      [
        ...pickExercises(getByMuscle("back", level), 3),
        ...pickExercises(getByMuscle("biceps", level), 2),
        ...pickExercises(getByMuscle("traps", level), 1),
        ...pickExercises(getByMuscle("forearms", level), 1),
      ],


      [
        ...pickExercises(getByMuscle("legs", level), 4),
        ...pickExercises(getByMuscle("abs", level), 2),
      ],
    ];
  }

  //Returns main workout exercises based on workout day type
  static List<Exercise> _getMainWorkout(String dayType, String level) {
    switch (dayType) {
      case "Push":
        return [
          ...pickExercises(getByMuscle("chest", level), 2),
          ...pickExercises(getByMuscle("shoulders", level), 2),
          ...pickExercises(getByMuscle("triceps", level), 2),
        ];

      case "Pull":
        return [
          ...pickExercises(getByMuscle("back", level), 3),
          ...pickExercises(getByMuscle("biceps", level), 2),
          ...pickExercises(getByMuscle("traps", level), 1),
          ...pickExercises(getByMuscle("forearms", level), 1),
        ];

      case "Legs":
        return [
          ...pickExercises(getByMuscle("legs", level), 4),
          ...pickExercises(getByMuscle("abs", level), 2),
        ];

      case "Upper":
        return [
          ...pickExercises(getByMuscle("chest", level), 2),
          ...pickExercises(getByMuscle("back", level), 2),
          ...pickExercises(getByMuscle("shoulders", level), 1),
          ...pickExercises(getByMuscle("biceps", level), 1),
          ...pickExercises(getByMuscle("triceps", level), 1),
        ];

      case "Lower":
        return [
          ...pickExercises(getByMuscle("legs", level), 4),
          ...pickExercises(getByMuscle("abs", level), 2),
        ];

      default:
        return [
          ...pickExercises(getByMuscle("chest", level), 1),
          ...pickExercises(getByMuscle("back", level), 1),
          ...pickExercises(getByMuscle("legs", level), 1),
          ...pickExercises(getByMuscle("shoulders", level), 1),
          ...pickExercises(getByMuscle("biceps", level), 1),
          ...pickExercises(getByMuscle("triceps", level), 1),
        ];
    }
  }



  //Generates a workout plan based on training days and difficulty level
  static List<List<Exercise>> generateWorkoutPlan({
    required int days,
    required String level,
    required String goal,
  }) {
    if (days <= 3) {
      return fullBody(level);
    }

    if (days <= 5) {
      return upperLower(level);
    }


    final pplPlan = ppl(level);

    return [
      pplPlan[0],
      pplPlan[1],
      pplPlan[2],
      pplPlan[0],
      pplPlan[1],
      pplPlan[2],
    ];
  }


  //Generates today's workout routine dynamically
  static Map<String, dynamic> generateTodayWorkout({
    required int days,
    required String level,
    required String goal,
  }) {
    int todayIndex = DateTime
        .now()
        .weekday - 1;

    String dayType;


    if (days <= 3) {
      List<String> split = [
        "Full",
        "Rest",
        "Full",
        "Rest",
        "Full",
        "Rest",
        "Rest",
      ];

      dayType = split[todayIndex];
    }


    else if (days <= 5) {
      List<String> split = [
        "Upper",
        "Lower",
        "Rest",
        "Upper",
        "Lower",
        "Rest",
        "Rest",
      ];

      dayType = split[todayIndex];
    }


    else {
      List<String> split = [
        "Push",
        "Pull",
        "Legs",
        "Push",
        "Pull",
        "Legs",
        "Rest",
      ];

      dayType = split[todayIndex];
    }


    if (dayType == "Rest") {
      return {
        "dayType": "Rest",
        "warmup": [],
        "main": [],
        "stretching": [],
      };
    }


    return {
      "dayType": dayType,
      "warmup": pickExercises(getWarmups(), 4),
      "main": _getMainWorkout(dayType, level),
      "stretching": pickExercises(getStretching(), 4),
    };
  }
}

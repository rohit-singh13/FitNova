import 'package:fitnova/data/workout_database.dart';

class WorkoutService {

  // Warmup
  static List<Exercise> getWarmups() {
    return exercises.where((e) => e.type == "warmup").toList();
  }

// Stretching
  static List<Exercise> getStretching() {
    return exercises.where((e) => e.type == "stretching").toList();
  }

  // 🔹 Get exercises by muscle
  static List<Exercise> getByMuscle(String muscle, String level) {
    return exercises
        .where((e) => e.muscle == muscle && e.difficulty == level)
        .toList();
  }

  // 🔹 Get exercises by difficulty
  static List<Exercise> getByLevel(String level) {
    return exercises.where((e) => e.difficulty == level).toList();
  }

  static List<Exercise> pickExercises(List<Exercise> list, int count) {
    list.shuffle();
    return list.length >= count ? list.take(count).toList() : list;
  }

  static List<List<Exercise>> fullBody(String level) {
    return [
      [
        ...pickExercises(getByMuscle("chest", level), 1),
        ...pickExercises(getByMuscle("back", level), 1),
        ...pickExercises(getByMuscle("legs", level), 1),
        ...pickExercises(getByMuscle("shoulders", level), 1),
        ...pickExercises(getByMuscle("biceps", level), 1),
        ...pickExercises(getByMuscle("triceps", level), 1),
        ...pickExercises(getByMuscle("traps", level), 1), // ✅ added
        ...pickExercises(getByMuscle("forearms", level), 1), // ✅ added
      ]
    ];
  }

  static List<List<Exercise>> upperLower(String level) {
    return [
      // Upper
      [
        ...pickExercises(getByMuscle("chest", level), 2),
        ...pickExercises(getByMuscle("back", level), 2),
        ...pickExercises(getByMuscle("shoulders", level), 1),
        ...pickExercises(getByMuscle("biceps", level), 1),
        ...pickExercises(getByMuscle("triceps", level), 1),
        ...pickExercises(getByMuscle("traps", level), 1), // ✅
      ],

      // Lower
      [
        ...pickExercises(getByMuscle("legs", level), 3),
        ...pickExercises(getByMuscle("abs", level), 2),
        ...pickExercises(getByMuscle("forearms", level), 1), // optional
      ]
    ];
  }

  static List<List<Exercise>> ppl(String level) {
    return [
      // Push
      [
        ...pickExercises(getByMuscle("chest", level), 2),
        ...pickExercises(getByMuscle("shoulders", level), 2),
        ...pickExercises(getByMuscle("triceps", level), 2),
      ],

      // Pull
      [
        ...pickExercises(getByMuscle("back", level), 3),
        ...pickExercises(getByMuscle("biceps", level), 2),
        ...pickExercises(getByMuscle("traps", level), 1), // ✅
        ...pickExercises(getByMuscle("forearms", level), 1), // ✅
      ],

      // Legs
      [
        ...pickExercises(getByMuscle("legs", level), 4),
        ...pickExercises(getByMuscle("abs", level), 2),
      ],
    ];
  }

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

      default: // Full Body
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


  // 🔹 Generate workout
  static List<List<Exercise>> generateWorkoutPlan({
    required int days,
    required String level,
    required String goal,
  }) {
    if (days <= 3) {
      return fullBody(level);
    }

    if (days <= 5) {
      return upperLower(level); // you can expand later
    }

    // 🔥 6 DAYS → PPL x2
    final pplPlan = ppl(level);

    return [
      pplPlan[0], // Push
      pplPlan[1], // Pull
      pplPlan[2], // Legs
      pplPlan[0], // Push
      pplPlan[1], // Pull
      pplPlan[2], // Legs
    ];
  }

  static String _getDayType(int days, int weekday) {
    if (days >= 6) {
      List<String> split = ["Push", "Pull", "Legs", "Push", "Pull", "Legs"];
      return split[(weekday - 1) % split.length];
    }

    if (days >= 4) {
      List<String> split = ["Upper", "Lower", "Upper", "Lower"];
      return split[(weekday - 1) % split.length];
    }

    return "Full Body";
  }

  static Map<String, dynamic> generateTodayWorkout({
    required int days,
    required String level,
    required String goal,
  }) {
    int todayIndex = DateTime
        .now()
        .weekday - 1; // 0–6

    String dayType;

    // 🔥 FULL BODY (2–3 days)
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

    // 🔥 UPPER LOWER (4–5 days)
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

    // 🔥 PPL (6 days)
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

    // 🛑 REST DAY
    if (dayType == "Rest") {
      return {
        "dayType": "Rest",
        "warmup": [],
        "main": [],
        "stretching": [],
      };
    }

    // 🔥 Generate sections
    return {
      "dayType": dayType,
      "warmup": pickExercises(getWarmups(), 4),
      "main": _getMainWorkout(dayType, level),
      "stretching": pickExercises(getStretching(), 4),
    };
  }
}

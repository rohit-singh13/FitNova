class Exercise {
  final String name;
  final String muscle;
  final String type;        // compound / isolation / warmup / stretching
  final String equipment;
  final String difficulty;

  final String? sets;       // "3-4"
  final String? reps;       // "8-12"
  final String? duration;   // "30 sec", "1 min"

  Exercise({
    required this.name,
    required this.muscle,
    required this.type,
    required this.equipment,
    required this.difficulty,
    this.sets,
    this.reps,
    this.duration,
  });
}

final List<Exercise> exercises = [

  // 🔥 WARMUP
  Exercise(
    name: "Jumping Jacks",
    muscle: "full",
    type: "warmup",
    equipment: "bodyweight",
    difficulty: "beginner",
    duration: "30 sec",
  ),

  Exercise(
    name: "Arm Circles",
    muscle: "shoulders",
    type: "warmup",
    equipment: "bodyweight",
    difficulty: "beginner",
    duration: "30 sec",
  ),

  Exercise(
    name: "High Knees",
    muscle: "legs",
    type: "warmup",
    equipment: "bodyweight",
    difficulty: "beginner",
    duration: "30 sec",
  ),

  Exercise(
    name: "Bodyweight Squats",
    muscle: "legs",
    type: "warmup",
    equipment: "bodyweight",
    difficulty: "beginner",
    sets: "2",
    reps: "15",
  ),

  Exercise(
    name: "Push-ups (Warmup)",
    muscle: "chest",
    type: "warmup",
    equipment: "bodyweight",
    difficulty: "beginner",
    sets: "2",
    reps: "10",
  ),

  // Chest
  Exercise(
    name: "Bench Press",
    muscle: "chest",
    type: "compound",
    equipment: "barbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Incline Dumbbell Press",
    muscle: "chest",
    type: "compound",
    equipment: "dumbbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Decline Bench Press",
    muscle: "chest",
    type: "compound",
    equipment: "barbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Chest Fly",
    muscle: "chest",
    type: "isolation",
    equipment: "dumbbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Cable Crossover",
    muscle: "chest",
    type: "isolation",
    equipment: "cable",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Push-Up",
    muscle: "chest",
    type: "compound",
    equipment: "bodyweight",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Dips",
    muscle: "chest",
    type: "compound",
    equipment: "bodyweight",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Machine Chest Press",
    muscle: "chest",
    type: "compound",
    equipment: "machine",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Pec Deck Fly",
    muscle: "chest",
    type: "isolation",
    equipment: "machine",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Incline Cable Fly",
    muscle: "chest",
    type: "isolation",
    equipment: "cable",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

// Back
  Exercise(
    name: "Deadlift",
    muscle: "back",
    type: "compound",
    equipment: "barbell",
    difficulty: "advanced",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Pull-Up",
    muscle: "back",
    type: "compound",
    equipment: "bodyweight",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Lat Pulldown",
    muscle: "back",
    type: "compound",
    equipment: "cable",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Barbell Row",
    muscle: "back",
    type: "compound",
    equipment: "barbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Seated Cable Row",
    muscle: "back",
    type: "compound",
    equipment: "cable",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "T-Bar Row",
    muscle: "back",
    type: "compound",
    equipment: "barbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Single Arm Dumbbell Row",
    muscle: "back",
    type: "compound",
    equipment: "dumbbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Face Pull",
    muscle: "back",
    type: "isolation",
    equipment: "cable",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Straight Arm Pulldown",
    muscle: "back",
    type: "isolation",
    equipment: "cable",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Hyperextension",
    muscle: "back",
    type: "isolation",
    equipment: "bodyweight",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  // Biceps
  Exercise(
    name: "Barbell Curl",
    muscle: "biceps",
    type: "isolation",
    equipment: "barbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Dumbbell Curl",
    muscle: "biceps",
    type: "isolation",
    equipment: "dumbbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Hammer Curl",
    muscle: "biceps",
    type: "isolation",
    equipment: "dumbbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Preacher Curl",
    muscle: "biceps",
    type: "isolation",
    equipment: "machine",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Cable Curl",
    muscle: "biceps",
    type: "isolation",
    equipment: "cable",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Concentration Curl",
    muscle: "biceps",
    type: "isolation",
    equipment: "dumbbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Incline Dumbbell Curl",
    muscle: "biceps",
    type: "isolation",
    equipment: "dumbbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "EZ Bar Curl",
    muscle: "biceps",
    type: "isolation",
    equipment: "barbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Spider Curl",
    muscle: "biceps",
    type: "isolation",
    equipment: "dumbbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Reverse Curl",
    muscle: "biceps",
    type: "isolation",
    equipment: "barbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

// Triceps
  Exercise(
    name: "Tricep Pushdown",
    muscle: "triceps",
    type: "isolation",
    equipment: "cable",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Overhead Tricep Extension",
    muscle: "triceps",
    type: "isolation",
    equipment: "dumbbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Skull Crushers",
    muscle: "triceps",
    type: "isolation",
    equipment: "barbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Close Grip Bench Press",
    muscle: "triceps",
    type: "compound",
    equipment: "barbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Bench Dips",
    muscle: "triceps",
    type: "compound",
    equipment: "bodyweight",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Cable Overhead Extension",
    muscle: "triceps",
    type: "isolation",
    equipment: "cable",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Rope Pushdown",
    muscle: "triceps",
    type: "isolation",
    equipment: "cable",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Dumbbell Kickback",
    muscle: "triceps",
    type: "isolation",
    equipment: "dumbbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Parallel Bar Dips",
    muscle: "triceps",
    type: "compound",
    equipment: "bodyweight",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Single Arm Cable Pushdown",
    muscle: "triceps",
    type: "isolation",
    equipment: "cable",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  // Legs
  Exercise(
    name: "Barbell Squat",
    muscle: "legs",
    type: "compound",
    equipment: "barbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Leg Press",
    muscle: "legs",
    type: "compound",
    equipment: "machine",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Romanian Deadlift",
    muscle: "legs",
    type: "compound",
    equipment: "barbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Walking Lunges",
    muscle: "legs",
    type: "compound",
    equipment: "dumbbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Bulgarian Split Squat",
    muscle: "legs",
    type: "compound",
    equipment: "dumbbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Leg Extension",
    muscle: "legs",
    type: "isolation",
    equipment: "machine",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Leg Curl",
    muscle: "legs",
    type: "isolation",
    equipment: "machine",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Standing Calf Raise",
    muscle: "legs",
    type: "isolation",
    equipment: "machine",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Seated Calf Raise",
    muscle: "legs",
    type: "isolation",
    equipment: "machine",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Hack Squat",
    muscle: "legs",
    type: "compound",
    equipment: "machine",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

// Shoulders
  Exercise(
    name: "Overhead Press",
    muscle: "shoulders",
    type: "compound",
    equipment: "barbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Dumbbell Shoulder Press",
    muscle: "shoulders",
    type: "compound",
    equipment: "dumbbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Lateral Raise",
    muscle: "shoulders",
    type: "isolation",
    equipment: "dumbbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Front Raise",
    muscle: "shoulders",
    type: "isolation",
    equipment: "dumbbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Rear Delt Fly",
    muscle: "shoulders",
    type: "isolation",
    equipment: "dumbbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Face Pull",
    muscle: "shoulders",
    type: "isolation",
    equipment: "cable",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Arnold Press",
    muscle: "shoulders",
    type: "compound",
    equipment: "dumbbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Upright Row",
    muscle: "shoulders",
    type: "compound",
    equipment: "barbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Cable Lateral Raise",
    muscle: "shoulders",
    type: "isolation",
    equipment: "cable",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Machine Shoulder Press",
    muscle: "shoulders",
    type: "compound",
    equipment: "machine",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  // Abs
  Exercise(
    name: "Crunches",
    muscle: "abs",
    type: "isolation",
    equipment: "bodyweight",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Leg Raises",
    muscle: "abs",
    type: "isolation",
    equipment: "bodyweight",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Hanging Leg Raise",
    muscle: "abs",
    type: "compound",
    equipment: "bodyweight",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Cable Crunch",
    muscle: "abs",
    type: "isolation",
    equipment: "cable",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Plank",
    muscle: "abs",
    type: "isometric",
    equipment: "bodyweight",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Russian Twist",
    muscle: "abs",
    type: "isolation",
    equipment: "bodyweight",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Decline Sit-Up",
    muscle: "abs",
    type: "compound",
    equipment: "bench",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Ab Wheel Rollout",
    muscle: "abs",
    type: "compound",
    equipment: "bodyweight",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Mountain Climbers",
    muscle: "abs",
    type: "compound",
    equipment: "bodyweight",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Bicycle Crunch",
    muscle: "abs",
    type: "isolation",
    equipment: "bodyweight",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

// Forearms
  Exercise(
    name: "Wrist Curl",
    muscle: "forearms",
    type: "isolation",
    equipment: "dumbbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Reverse Wrist Curl",
    muscle: "forearms",
    type: "isolation",
    equipment: "dumbbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Hammer Curl",
    muscle: "forearms",
    type: "compound",
    equipment: "dumbbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Farmer’s Walk",
    muscle: "forearms",
    type: "compound",
    equipment: "dumbbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Dead Hang",
    muscle: "forearms",
    type: "isometric",
    equipment: "bodyweight",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Reverse Curl",
    muscle: "forearms",
    type: "compound",
    equipment: "barbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Plate Pinch Hold",
    muscle: "forearms",
    type: "isometric",
    equipment: "plate",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Cable Wrist Curl",
    muscle: "forearms",
    type: "isolation",
    equipment: "cable",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Towel Pull-Up",
    muscle: "forearms",
    type: "compound",
    equipment: "bodyweight",
    difficulty: "advanced",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Behind the Back Wrist Curl",
    muscle: "forearms",
    type: "isolation",
    equipment: "barbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

// Traps
  Exercise(
    name: "Barbell Shrug",
    muscle: "traps",
    type: "isolation",
    equipment: "barbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Dumbbell Shrug",
    muscle: "traps",
    type: "isolation",
    equipment: "dumbbell",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Upright Row",
    muscle: "traps",
    type: "compound",
    equipment: "barbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Face Pull",
    muscle: "traps",
    type: "isolation",
    equipment: "cable",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Rack Pull",
    muscle: "traps",
    type: "compound",
    equipment: "barbell",
    difficulty: "advanced",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Farmer’s Walk",
    muscle: "traps",
    type: "compound",
    equipment: "dumbbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Snatch Grip Deadlift",
    muscle: "traps",
    type: "compound",
    equipment: "barbell",
    difficulty: "advanced",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Cable Shrug",
    muscle: "traps",
    type: "isolation",
    equipment: "cable",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Machine Shrug",
    muscle: "traps",
    type: "isolation",
    equipment: "machine",
    difficulty: "beginner",
    sets: "3",
    reps: "8-12",
  ),

  Exercise(
    name: "Trap Bar Deadlift",
    muscle: "traps",
    type: "compound",
    equipment: "barbell",
    difficulty: "intermediate",
    sets: "3",
    reps: "8-12",
  ),

  // 🔥 STRETCHING
  Exercise(
    name: "Hamstring Stretch",
    muscle: "legs",
    type: "stretching",
    equipment: "bodyweight",
    difficulty: "beginner",
    duration: "30 sec",
  ),

  Exercise(
    name: "Quad Stretch",
    muscle: "legs",
    type: "stretching",
    equipment: "bodyweight",
    difficulty: "beginner",
    duration: "30 sec",
  ),

  Exercise(
    name: "Chest Stretch",
    muscle: "chest",
    type: "stretching",
    equipment: "bodyweight",
    difficulty: "beginner",
    duration: "30 sec",
  ),

  Exercise(
    name: "Shoulder Stretch",
    muscle: "shoulders",
    type: "stretching",
    equipment: "bodyweight",
    difficulty: "beginner",
    duration: "30 sec",
  ),

  Exercise(
    name: "Child’s Pose",
    muscle: "back",
    type: "stretching",
    equipment: "bodyweight",
    difficulty: "beginner",
    duration: "45 sec",
  ),
];
import 'package:flutter/material.dart';
import 'package:fitnova/data/food_database.dart';
import 'package:fitnova/services/spoonacular_service.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fitnova/data/nutrition_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Meal {
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;

  Meal({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });
}

class MealInput {
  String name;
  double quantity;
  String unit;
  TextEditingController controller;

  MealInput({
    this.name = "",
    this.quantity = 0,
    this.unit = "g",
  })  : controller = TextEditingController();
}

class NutritionTab extends StatefulWidget {
  final int targetCalories;
  const NutritionTab({required this.targetCalories});

  @override
  State<NutritionTab> createState() => _NutritionTabState();
}

class _NutritionTabState extends State<NutritionTab> {

  List<Meal> meals = [];

  int totalCalories = 0;
  int totalProtein = 0;
  int totalCarbs = 0;
  int totalFats = 0;

  bool isLoading = false;

  late int proteinTarget;
  late int carbsTarget;
  late int fatsTarget;

  void checkNewDay() async {    //Resets nutrition data when a new day starts
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split("T")[0];

    final lastDate = prefs.getString("last_date");

    if (lastDate != today) {
      setState(() {
        meals.clear();
        totalCalories = 0;
        totalProtein = 0;
        totalCarbs = 0;
        totalFats = 0;
      });

      prefs.setString("last_date", today);
    }
  }

  @override
  void initState() {
    super.initState();
      checkNewDay();

    proteinTarget = (widget.targetCalories * 0.3 / 4).toInt();
    carbsTarget   = (widget.targetCalories * 0.4 / 4).toInt();
    fatsTarget    = (widget.targetCalories * 0.3 / 9).toInt();
  }
  Meal? getLocalMeal(String input) {    //Calculates nutrition using local food database
    input = input.toLowerCase().trim();
    final regex = RegExp(r'(\d+)\s*(g|grams)?\s*(.+)');
    final match = regex.firstMatch(input);

    if (match == null) return null;

    double qty = double.tryParse(match.group(1)!) ?? 0;
    String foodName = match.group(3)!.trim();

    final food = getFood(foodName);

    if (food == null || qty == 0) return null;

    return Meal(
      name: input,
      calories: (qty * food.caloriesPerGram).toInt(),
      protein: (qty * food.proteinPerGram).toInt(),
      carbs: (qty * food.carbsPerGram).toInt(),
      fats: (qty * food.fatsPerGram).toInt(),
    );
  }

  String getSuggestion() {    //Gives nutrition feedback based on daily intake
    if (totalProtein < proteinTarget * 0.7) {
      return "You need more protein today 💪";
    } else if (totalCarbs < carbsTarget * 0.7) {
      return "You should increase carbs ⚡";
    } else if (totalFats > fatsTarget * 1.2) {
      return "Fats are a bit high ⚠️";
    } else if (totalCalories > widget.targetCalories) {
      return "You've exceeded your calories 🚨";
    } else {
      return "You're doing great today ✅";
    }
  }

  void _addMealDialog() {   //Opens popup to add meal items manually
    List<MealInput> inputs = [MealInput()];

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text("Add Meal", style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    ...inputs.asMap().entries.map((entry) {
                      MealInput item = entry.value;

                      return Column(
                        children: [
                          TextField(
                            controller: item.controller,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Food (e.g. chicken)",
                              hintStyle: TextStyle(color: Colors.white54),
                            ),
                            onChanged: (val) {
                              item.name = val;
                            },
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Qty",
                                    hintStyle: TextStyle(color: Colors.white54),
                                  ),
                                  onChanged: (val) {
                                    item.quantity = double.tryParse(val) ?? 0;
                                  },
                                ),
                              ),

                              SizedBox(width: 10),

                              DropdownButton<String>(
                                value: item.unit,
                                dropdownColor: Colors.grey[900],
                                style: TextStyle(color: Colors.white),
                                items: ["g", "ml", "piece"]
                                    .map((u) => DropdownMenuItem(
                                  value: u,
                                  child: Text(u),
                                ))
                                    .toList(),
                                onChanged: (val) {
                                  setDialogState(() {
                                    item.unit = val!;
                                  });
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: 15),
                        ],
                      );
                    }).toList(),

                    TextButton(
                      onPressed: () {
                        setDialogState(() {
                          inputs.add(MealInput());
                        });
                      },
                      child: Text("➕ Add another item"),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    setState(() => isLoading = true);

                    int mealCalories = 0;
                    int mealProtein = 0;
                    int mealCarbs = 0;
                    int mealFats = 0;

                    List<String> names = [];

                    for (var item in inputs) {    //Loops through all entered food items
                      print("RAW NAME: '${item.name}'");
                      print("Item: ${item.name}, Qty: ${item.quantity}, Unit: ${item.unit}");
                      if (item.quantity <= 0 || item.name.trim().isEmpty) {
                        continue;
                      }

                      final food = getFood(item.name.toLowerCase().trim());    //Checks if food exists in local database

                      double grams;

                      if (food != null) {
                        if (item.unit == "g") {
                          grams = item.quantity;
                        } else {
                          grams = item.quantity * food.gramsPerUnit;
                        }

                        mealCalories += (grams * food.caloriesPerGram).toInt();
                        mealProtein += (grams * food.proteinPerGram).toInt();
                        mealCarbs += (grams * food.carbsPerGram).toInt();
                        mealFats += (grams * food.fatsPerGram).toInt();

                        names.add("${item.quantity}${item.unit} ${item.name}");
                      }

                      else {
                        String foodName = item.name.toLowerCase().trim();

                        if (!foodName.endsWith("s")) {
                          foodName = foodName + "s";
                        }

                        final query = "${item.quantity}${item.unit} $foodName";
                        print("👉 Calling API for: $query");

                        final data = await SpoonacularService.fetchNutrition(query);

                        if (data == null) {
                          final fallbackQuery = "${item.quantity} ${item.unit} ${item.name}";
                          print("🔁 Retrying with: $fallbackQuery");

                          final retryData = await SpoonacularService.fetchNutrition(fallbackQuery);

                          if (retryData != null) {
                          }
                        }

                        if (data != null) {
                          final calories = (data["calories"] as num?)?.toInt() ?? 0;
                          final protein  = (data["protein"] as num?)?.toInt() ?? 0;
                          final carbs    = (data["carbs"] as num?)?.toInt() ?? 0;
                          final fats     = (data["fats"] as num?)?.toInt() ?? 0;

                          mealCalories += calories;
                          mealProtein += protein;
                          mealCarbs += carbs;
                          mealFats += fats;

                          names.add(query);
                        } else {
                          print("❌ API FAILED for $query");

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${item.name} not found")),
                          );
                        }
                      }
                    }

                    if (names.isEmpty) {
                      setState(() => isLoading = false);
                      return;
                    }

                    final combinedMeal = Meal(
                      name: names.join(", "),
                      calories: mealCalories,
                      protein: mealProtein,
                      carbs: mealCarbs,
                      fats: mealFats,
                    );

                    setState(() {
                      meals.add(combinedMeal);
                      totalCalories += combinedMeal.calories;
                      totalProtein += combinedMeal.protein;
                      totalCarbs += combinedMeal.carbs;
                      totalFats += combinedMeal.fats;
                    });
                    await NutritionStorage.saveToday(
                      calories: totalCalories,
                      protein: totalProtein,
                      carbs: totalCarbs,
                      fats: totalFats,
                    );

                    setState(() => isLoading = false);
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: _addMealDialog,
            child: _card(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFF6C5CE7),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                  SizedBox(width: 15),
                  Text(
                    "Add a meal",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 15),

          Column(
            children: meals.asMap().entries.map((entry) {
              int index = entry.key;
              Meal meal = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Expanded(
                  child: Text(
                  "Meal ${index + 1} - ${meal.name}",
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                      Text(
                        "${meal.calories} kcal",
                        style: TextStyle(color: Colors.white60),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 15),

          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Intake",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _macroCircle(
                          label: "Calories",
                          value: totalCalories,
                          max: widget.targetCalories,
                          color: Colors.orange,
                        ),
                        _macroCircle(
                          label: "Protein",
                          value: totalProtein,
                          max: proteinTarget,
                          color: Colors.green,
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _macroCircle(
                          label: "Carbs",
                          value: totalCarbs,
                          max: carbsTarget,
                          color: Colors.blue,
                        ),
                        _macroCircle(
                          label: "Fats",
                          value: totalFats,
                          max: fatsTarget,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  getSuggestion(),
                  style: TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }

  Widget _macroCircle({
    required String label,
    required int value,
    required int max,
    required Color color,
  }) {
    double percent = max == 0 ? 0 : (value / max).clamp(0.0, 1.0);

    return Column(
      children: [
        CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 10.0,
          percent: percent,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${(percent * 100).toInt()}%",
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$value",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          progressColor: color,
          backgroundColor: Colors.white10,
          circularStrokeCap: CircularStrokeCap.round,
        ),
        SizedBox(height: 6),
        Text(label, style: TextStyle(color: Colors.white70)),
      ],
    );
  }
}
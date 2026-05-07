
//Class for storing nutritional information of food items
class FoodItem {
  final double caloriesPerGram;
  final double proteinPerGram;
  final double carbsPerGram;
  final double fatsPerGram;

  final String defaultUnit;
  final double gramsPerUnit;

  FoodItem({
    required this.caloriesPerGram,
    required this.proteinPerGram,
    required this.carbsPerGram,
    required this.fatsPerGram,
    required this.defaultUnit,
    required this.gramsPerUnit,
  });
}

//Main food database containing nutrition values per gram/unit
Map<String, FoodItem> foodDatabase = {


  "chicken": FoodItem(caloriesPerGram: 1.65, proteinPerGram: 0.31, carbsPerGram: 0, fatsPerGram: 0.036, defaultUnit: "g", gramsPerUnit: 1),
  "turkey": FoodItem(caloriesPerGram: 1.35, proteinPerGram: 0.29, carbsPerGram: 0, fatsPerGram: 0.01, defaultUnit: "g", gramsPerUnit: 1),
  "fish": FoodItem(caloriesPerGram: 2.06, proteinPerGram: 0.22, carbsPerGram: 0, fatsPerGram: 0.12, defaultUnit: "g", gramsPerUnit: 1),
  "tuna": FoodItem(caloriesPerGram: 1.32, proteinPerGram: 0.28, carbsPerGram: 0, fatsPerGram: 0.01, defaultUnit: "g", gramsPerUnit: 1),

  "egg": FoodItem(caloriesPerGram: 1.55, proteinPerGram: 0.13, carbsPerGram: 0.01, fatsPerGram: 0.11, defaultUnit: "piece", gramsPerUnit: 50),
  "egg white": FoodItem(caloriesPerGram: 0.52, proteinPerGram: 0.11, carbsPerGram: 0.01, fatsPerGram: 0.002, defaultUnit: "piece", gramsPerUnit: 30),


  "beef": FoodItem(caloriesPerGram: 2.5, proteinPerGram: 0.26, carbsPerGram: 0, fatsPerGram: 0.15, defaultUnit: "g", gramsPerUnit: 1),
  "mutton": FoodItem(caloriesPerGram: 2.94, proteinPerGram: 0.25, carbsPerGram: 0, fatsPerGram: 0.21, defaultUnit: "g", gramsPerUnit: 1),
  "paneer": FoodItem(caloriesPerGram: 2.65, proteinPerGram: 0.18, carbsPerGram: 0.01, fatsPerGram: 0.20, defaultUnit: "g", gramsPerUnit: 1),
  "tofu": FoodItem(caloriesPerGram: 0.76, proteinPerGram: 0.08, carbsPerGram: 0.02, fatsPerGram: 0.04, defaultUnit: "g", gramsPerUnit: 1),


  "soya chunks": FoodItem(caloriesPerGram: 3.45, proteinPerGram: 0.52, carbsPerGram: 0.33, fatsPerGram: 0.005, defaultUnit: "g", gramsPerUnit: 1),
  "dal": FoodItem(caloriesPerGram: 1.16, proteinPerGram: 0.09, carbsPerGram: 0.20, fatsPerGram: 0.004, defaultUnit: "g", gramsPerUnit: 1),
  "rajma": FoodItem(caloriesPerGram: 1.27, proteinPerGram: 0.087, carbsPerGram: 0.23, fatsPerGram: 0.005, defaultUnit: "g", gramsPerUnit: 1),
  "chole": FoodItem(caloriesPerGram: 1.64, proteinPerGram: 0.089, carbsPerGram: 0.27, fatsPerGram: 0.026, defaultUnit: "g", gramsPerUnit: 1),


  "milk": FoodItem(caloriesPerGram: 0.64, proteinPerGram: 0.033, carbsPerGram: 0.05, fatsPerGram: 0.035, defaultUnit: "ml", gramsPerUnit: 1),
  "curd": FoodItem(caloriesPerGram: 0.98, proteinPerGram: 0.11, carbsPerGram: 0.04, fatsPerGram: 0.04, defaultUnit: "g", gramsPerUnit: 1),
  "yogurt": FoodItem(caloriesPerGram: 0.59, proteinPerGram: 0.10, carbsPerGram: 0.036, fatsPerGram: 0.004, defaultUnit: "g", gramsPerUnit: 1),
  "cheese": FoodItem(caloriesPerGram: 4.02, proteinPerGram: 0.25, carbsPerGram: 0.013, fatsPerGram: 0.33, defaultUnit: "g", gramsPerUnit: 1),


  "rice": FoodItem(caloriesPerGram: 1.30, proteinPerGram: 0.028, carbsPerGram: 0.28, fatsPerGram: 0.003, defaultUnit: "g", gramsPerUnit: 1),
  "brown rice": FoodItem(caloriesPerGram: 1.23, proteinPerGram: 0.026, carbsPerGram: 0.25, fatsPerGram: 0.01, defaultUnit: "g", gramsPerUnit: 1),
  "oats": FoodItem(caloriesPerGram: 3.89, proteinPerGram: 0.17, carbsPerGram: 0.66, fatsPerGram: 0.07, defaultUnit: "g", gramsPerUnit: 1),

  "bread": FoodItem(caloriesPerGram: 2.65, proteinPerGram: 0.09, carbsPerGram: 0.49, fatsPerGram: 0.03, defaultUnit: "piece", gramsPerUnit: 30),
  "roti": FoodItem(caloriesPerGram: 2.97, proteinPerGram: 0.09, carbsPerGram: 0.50, fatsPerGram: 0.03, defaultUnit: "piece", gramsPerUnit: 40),


  "potato": FoodItem(caloriesPerGram: 0.77, proteinPerGram: 0.02, carbsPerGram: 0.17, fatsPerGram: 0.001, defaultUnit: "g", gramsPerUnit: 1),
  "sweet potato": FoodItem(caloriesPerGram: 0.86, proteinPerGram: 0.016, carbsPerGram: 0.20, fatsPerGram: 0.001, defaultUnit: "g", gramsPerUnit: 1),


  "peanuts": FoodItem(caloriesPerGram: 5.67, proteinPerGram: 0.26, carbsPerGram: 0.16, fatsPerGram: 0.49, defaultUnit: "g", gramsPerUnit: 1),
  "peanut butter": FoodItem(caloriesPerGram: 5.88, proteinPerGram: 0.25, carbsPerGram: 0.20, fatsPerGram: 0.50, defaultUnit: "g", gramsPerUnit: 1),
  "almonds": FoodItem(caloriesPerGram: 5.76, proteinPerGram: 0.21, carbsPerGram: 0.22, fatsPerGram: 0.49, defaultUnit: "g", gramsPerUnit: 1),


  "butter": FoodItem(caloriesPerGram: 7.17, proteinPerGram: 0.01, carbsPerGram: 0.01, fatsPerGram: 0.81, defaultUnit: "g", gramsPerUnit: 1),
  "oil": FoodItem(caloriesPerGram: 8.84, proteinPerGram: 0, carbsPerGram: 0, fatsPerGram: 1.0, defaultUnit: "ml", gramsPerUnit: 1),


  "banana": FoodItem(caloriesPerGram: 0.89, proteinPerGram: 0.011, carbsPerGram: 0.23, fatsPerGram: 0.003, defaultUnit: "piece", gramsPerUnit: 120),
  "apple": FoodItem(caloriesPerGram: 0.52, proteinPerGram: 0.003, carbsPerGram: 0.14, fatsPerGram: 0.002, defaultUnit: "piece", gramsPerUnit: 150),
  "orange": FoodItem(caloriesPerGram: 0.47, proteinPerGram: 0.009, carbsPerGram: 0.12, fatsPerGram: 0.001, defaultUnit: "piece", gramsPerUnit: 130),


  "broccoli": FoodItem(caloriesPerGram: 0.34, proteinPerGram: 0.028, carbsPerGram: 0.07, fatsPerGram: 0.003, defaultUnit: "g", gramsPerUnit: 1),
  "spinach": FoodItem(caloriesPerGram: 0.23, proteinPerGram: 0.029, carbsPerGram: 0.036, fatsPerGram: 0.004, defaultUnit: "g", gramsPerUnit: 1),
  "carrot": FoodItem(caloriesPerGram: 0.41, proteinPerGram: 0.009, carbsPerGram: 0.10, fatsPerGram: 0.002, defaultUnit: "g", gramsPerUnit: 1),
};

//Alternative food names mapped to standard database names
Map<String, String> foodAliases = {


  "chicken breast": "chicken",
  "boiled chicken": "chicken",
  "fried chicken": "chicken",
  "grilled chicken": "chicken",


  "eggs": "egg",
  "boiled egg": "egg",
  "egg white": "egg white",
  "egg whites": "egg white",


  "milkshake": "milk",
  "dahi": "curd",
  "curd": "curd",
  "yoghurt": "yogurt",
  "lassi": "curd",


  "chapati": "roti",
  "chapati roti": "roti",
  "phulka": "roti",
  "roti": "roti",


  "white rice": "rice",
  "basmati rice": "rice",
  "boiled rice": "rice",


  "aloo": "potato",
  "sweet potato": "sweet potato",


  "paneer cheese": "paneer",


  "soya chunks": "soya chunks",
  "soy chunks": "soya chunks",
  "nutri nuggets": "soya chunks",

  "peanut": "peanuts",
  "groundnuts": "peanuts",

  "peanut butter": "peanut butter",


  "kela": "banana",
  "seb": "apple",
  "santra": "orange",
};

// Returns FoodItem after normalizing aliases and user input
FoodItem? getFood(String name) {
  name = name.toLowerCase().trim();


  if (foodAliases.containsKey(name)) {
    name = foodAliases[name]!;
  }

  return foodDatabase[name];
}